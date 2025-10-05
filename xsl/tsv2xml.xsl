<xsl:stylesheet version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  expand-text="yes">

  <xsl:param name="input-file"/>

  <xsl:output indent="yes"/>

  <xsl:variable name="input-lines" select="unparsed-text-lines($input-file)"/>

  <xsl:variable name="field-names" select="tokenize($input-lines[1], '&#9;')
                                         ! (if (not(string(.))) then '_' else .)
                                         ! replace(., ' ', '')
                                         ! replace(., '#', 'Number')"/>

  <xsl:template match="/">
    <tsv>
      <xsl:for-each select="$input-lines[position() gt 1]">
        <row>
          <xsl:variable name="values" select="tokenize(., '&#9;')"/>
          <xsl:for-each select="$values">
            <xsl:variable name="position" select="position()"/>
            <xsl:element name="{$field-names[position() eq $position]}">
              <xsl:value-of select="."/>
            </xsl:element>
          </xsl:for-each>
        </row>
      </xsl:for-each>
    </tsv>
  </xsl:template>

</xsl:stylesheet>
