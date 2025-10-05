#!/bin/bash

# Set default DOWNLOADS_FOLDER
DOWNLOADS_FOLDER="$HOME/Downloads"

# Check if settings.txt exists and read settings
if [ -f settings.txt ]; then
    while IFS='=' read -r key value
    do
        if [ "$key" == "DOWNLOADS_FOLDER_BASH" ]; then
            DOWNLOADS_FOLDER=$value
        fi
    done < settings.txt
fi

# Using DOWNLOADS_FOLDER
echo "DOWNLOADS_FOLDER is set to $DOWNLOADS_FOLDER"

# Check for the presence of the required argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <budget_name>"
    exit 1
fi

budget_name="$1"
echo "Budget name: $budget_name"

mkdir -p temp
cp xsl/* temp
cd temp

prefix="Tiller Foundation Template ($budget_name) - Transactions"
newest_file=$(find $DOWNLOADS_FOLDER -maxdepth 1 -type f -name "$prefix*" -printf "%T@ %p\n" | sort -rn | head -n 1 | cut -d' ' -f2-)

echo "Processing transactions in $newest_file"
cp "$newest_file" ./transactions.tsv

java net.sf.saxon.Transform -s:tsv2xml.xsl -xsl:tsv2xml.xsl -o:transactions.xml input-file=transactions.tsv
java net.sf.saxon.Transform -s:transactions.xml -xsl:rows2ofx.xsl -o:transactions.ofx budget-name="$budget_name"

# Cross-platform way to open transactions.ofx (according to ChatGPT, that is) (I use Cygwin)
case "$(uname -s)" in
    Linux*) xdg-open transactions.ofx ;;
    Darwin*) open transactions.ofx ;;
    CYGWIN_NT*) cygstart transactions.ofx ;;
    MINGW32*|MSYS_NT*) start transactions.ofx ;;
    *) echo "Unsupported OS" ;;
esac
