#!/bin/sh
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.
# Another option is to use the Perl script convert-all.pl, which first chops up the
# huge XML files into manageable chunks, and then passes each chunk through XSLT
# separately.

mkdir -p out
java -Xmx2G -jar $SAXON_JAR -s:data/qual2014.xml -xsl:xslt/qual.xsl > out/qual2014.nt
java -Xmx2G -jar $SAXON_JAR -s:data/desc2014.xml -xsl:xslt/desc.xsl > out/desc2014.nt
java -Xmx2G -jar $SAXON_JAR -s:data/supp2014.xml -xsl:xslt/supp.xsl > out/supp2014.nt

