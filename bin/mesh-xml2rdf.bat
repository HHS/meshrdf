rem This script will convert all of the MeSH XML to RDF, assuming that your machine has
rem enough memory and resources.
rem Another option is to use the Perl script convert-all.pl, which first chops up the
rem huge XML files into manageable chunks, and then passes each chunk through XSLT
rem separately.

mkdir %MESHRDF_HOME%\out
java -Xmx2G -jar %SAXON_JAR% -s:%MESHRDF_HOME%/data/qual2014.xml ^
    -xsl:xslt/qual.xsl > %MESHRDF_HOME%/out/qual2014.nt
java -Xmx2G -jar %SAXON_JAR% -s:%MESHRDF_HOME%/data/desc2014.xml ^
    -xsl:xslt/desc.xsl > %MESHRDF_HOME%/out/desc2014.nt
java -Xmx2G -jar %SAXON_JAR% -s:%MESHRDF_HOME%/data/supp2014.xml ^
    -xsl:xslt/supp.xsl > %MESHRDF_HOME%/out/supp2014.nt

