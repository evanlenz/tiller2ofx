<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  expand-text="yes">

  <xsl:param name="budget-name"/>

  <xsl:variable name="budget-config" select="doc('../config.xml')/accounts/budget[@name eq $budget-name]"/>

  <xsl:variable name="source" select="/"/>

  <xsl:template match="/">
    <OFX>
      <SIGNONMSGSRSV1>
        <SONRS>
          <STATUS>
            <CODE>0</CODE>
            <SEVERITY>INFO</SEVERITY>
            <MESSAGE>Success</MESSAGE>
          </STATUS>
          <LANGUAGE>ENG</LANGUAGE>
        </SONRS>
      </SIGNONMSGSRSV1>
      <BANKMSGSRSV1>
        <xsl:apply-templates select="$budget-config/bank-accounts/account"/>
      </BANKMSGSRSV1>
      <CREDITCARDMSGSRSV1>
        <xsl:apply-templates select="$budget-config/credit-cards/account"/>
      </CREDITCARDMSGSRSV1>
    </OFX>
  </xsl:template>

  <xsl:template match="bank-accounts/account">
    <STMTTRNRS>
      <STATUS>
        <CODE>0</CODE>
        <SEVERITY>INFO</SEVERITY>
        <MESSAGE>Success</MESSAGE>
      </STATUS>
      <CLTCOOKIE>4</CLTCOOKIE>
      <STMTRS>
        <CURDEF>USD</CURDEF>
        <BANKACCTFROM>
          <BANKID>foobarbat</BANKID>
          <ACCTID>{@number}</ACCTID>
          <ACCTTYPE>CHECKING</ACCTTYPE>
        </BANKACCTFROM>
        <BANKTRANLIST>
          <xsl:apply-templates mode="transaction"
                               select="$source/tsv/row[AccountNumber eq current()/@number]"/>
        </BANKTRANLIST>
      </STMTRS>
    </STMTTRNRS>
  </xsl:template>

  <xsl:template match="credit-cards/account">
    <CCSTMTTRNRS>
      <STATUS>
        <CODE>0</CODE>
        <SEVERITY>INFO</SEVERITY>
      </STATUS>
      <CLTCOOKIE>4</CLTCOOKIE>
      <CCSTMTRS>
        <CURDEF>USD</CURDEF>
        <CCACCTFROM>
          <ACCTID>{@number}</ACCTID>
        </CCACCTFROM>
        <BANKTRANLIST>
          <xsl:apply-templates mode="transaction"
                               select="$source/tsv/row[AccountNumber eq current()/@number]"/>
        </BANKTRANLIST>
      </CCSTMTRS>
    </CCSTMTTRNRS>
  </xsl:template>

  <xsl:template mode="transaction" match="row">
    <xsl:variable name="date-parts" select="tokenize(Date, '/')"/>
    <STMTTRN>
      <TRNTYPE>{if (starts-with(Amount,'-')) then 'DEBIT' else 'CREDIT'}</TRNTYPE>
      <DTPOSTED>{
        $date-parts[3] ||
        format-number(number($date-parts[1]),'00') ||
        format-number(number($date-parts[2]),'00') ||
        "1200000"
      }</DTPOSTED>
      <TRNAMT>{translate(Amount, '$', '')}</TRNAMT>
      <FITID>{TransactionID}</FITID>
      <NAME>{normalize-space(FullDescription)}</NAME>
    </STMTTRN>
  </xsl:template>

</xsl:stylesheet>
