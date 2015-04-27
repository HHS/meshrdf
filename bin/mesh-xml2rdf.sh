#!/bin/sh
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.
# Another option is to use the Perl script convert-all.pl, which first chops up the
# huge XML files into manageable chunks, and then passes each chunk through XSLT
# separately.

if [ -z "$MESHRDF_HOME" ]; then
    echo "Please define MESHRDF_HOME environment variable" 1>&2
    exit 1
fi

if [ -z "$SAXON_JAR" ]; then
    echo "Please define SAXON_JAR environment variable" 1>&2
    exit 1
fi

# Can override default year with MESHRDF_YEAR environment variable
YEAR=${MESHRDF_YEAR:-2014}

# Use year to modify $MESHRDF_HOME/xslt/mesh-rdf-prefixes.ent

mkdir -p "$MESHRDF_HOME/out"

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/qual$YEAR.xml \
    -xsl:xslt/qual.xsl > $MESHRDF_HOME/out/mesh$YEAR-dups.nt

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/desc$YEAR.xml \
    -xsl:xslt/desc.xsl >> $MESHRDF_HOME/out/mesh$YEAR-dups.nt

java -Xmx2G -jar $SAXON_JAR -s:$MESHRDF_HOME/data/supp$YEAR.xml \
    -xsl:xslt/supp.xsl >> $MESHRDF_HOME/out/mesh$YEAR-dups.nt

sort -u -T$MESHRDF_HOME/out $MESHRDF_HOME/out/mesh$YEAR-dups.nt > $MESHRDF_HOME/out/mesh$YEAR.nt
gzip -c $MESHRDF_HOME/out/mesh$YEAR.nt > $MESHRDF_HOME/out/mesh$YEAR.nt.gz
