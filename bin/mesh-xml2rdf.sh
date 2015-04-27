#!/bin/sh
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.
# Another option is to use the Perl script convert-all.pl, which first chops up the
# huge XML files into manageable chunks, and then passes each chunk through XSLT
# separately.

mkdir -p $MESHRDF_HOME/out

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/qual2014.xml \
    -xsl:xslt/qual.xsl > $MESHRDF_HOME/out/mesh2014-dups.nt

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/desc2014.xml \
    -xsl:xslt/desc.xsl >> $MESHRDF_HOME/out/mesh2014-dups.nt

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/supp2014.xml \
    -xsl:xslt/supp.xsl >> $MESHRDF_HOME/out/mesh2014-dups.nt

sort -u -T$MESHRDF_HOME/out $MESHRDF_HOME/out/mesh2014-dups.nt > $MESHRDF_HOME/out/mesh2014.nt
gzip -c $MESHRDF_HOME/out/mesh2014.nt > $MESHRDF_HOME/out/mesh2014.nt.gz
