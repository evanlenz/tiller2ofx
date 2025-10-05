# tiller2ofx
I created these little scripts to make a fast way to transform
downloaded transactions from Tiller Money into the OFX format
so that it can be opened by YNAB 4, the budgeting desktop application
that I'm still stubbornly using.

## Setup
Edit config.sample.xml and rename to config.xml

If your downloads folder is somewhere other than $HOME/Downloads, you
can configure it by creating a file in the same directory as config.xml
called settings.txt, e.g.:

```
DOWNLOADS_FOLDER_BASH=/cygdrive/c/Users/evanl/Downloads
```

This was what I used in Cygwin before I switched over to Mac.

## Requirements
The SaxonJ-HE .jar file must be in your CLASSPATH.
See https://www.saxonica.com/download/java.xml

If you need more details on installation, Java, and classpaths, see
https://www.saxonica.com/documentation12/index.html#!about/gettingstarted/gettingstartedjava

## Usage
./run.sh BUSINESS

or

./run.sh PERSONAL

Or replace "BUSINESS" or "PERSONAL" with whatever budget name you've
configured in config.xml.

See the comments in config.sample.xml to know how to name your
Google Sheet that has Tiller Money transactions in it. For example,
my business sheet is called "Tiller Foundation Template (BUSINESS)",
and this is what effects the download file names such as
"Tiller Foundation Template (BUSINESS) - Transactions (35)" where
the "(35)" is the browser's way of disambiguating the file from
earlier downloads of the same file.

You should download your sheet in .tsv format. From inside Google
Sheets, select File...Download...Tab Separated Values (.tsv).
This is the format expected by the tiller2ofx script (run.sh).

Once you've done that, jump over to the command prompt and type
./run.sh BUSINESS. The run.sh script will find the newest download
of your business transactions (when you type "./run.sh BUSINESS").
Then it will convert them to OFX format and attempt to open them
in your OS, using whatever application is associated with OFX
files. For me, that's YNAB 4.
