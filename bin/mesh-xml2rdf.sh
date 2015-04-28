#!/bin/sh
#
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.
#
# Another option is to use the Perl script mesh-rdf2xml.pl, which first chops up the
# huge XML files into manageable chunks, and then passes each chunk through XSLT
# separately.
#

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

# Can override default Mesh prefix and output file with MESHRDF_PREFIX environment variable
PREFIX=${MESHRDF_PREFIX:-mesh/$YEAR}
OUT=`echo $PREFIX | sed -e 's,/,,'`

# substitute the prefix into the DTD entity file
sed -e "s,MESHRDF_PATH,$PREFIX,g" xslt/mesh-rdf-prefixes.ent.template > xslt/mesh-rdf-prefixes.ent
if [ $? -ne 0 ]; then 
    echo "Error creating xslt/mesh-rdf-prefixes.ent from template" 1>&2
    exit 1
fi

mkdir -p "$MESHRDF_HOME/out"

java -Xmx2G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/qual$YEAR.xml" \
    -xsl:xslt/qual.xsl > "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/qual$YEAR.xml" 1>&2
    exit 1
fi

java -Xmx2G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/desc$YEAR.xml" \
    -xsl:xslt/desc.xsl >> "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/desc$YEAR.xml"
    exit 1
fi


java -Xmx2G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/supp$YEAR.xml" \
    -xsl:xslt/supp.xsl >> "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/supp$YEAR.xml"
    exit 1
fi

sort -u -T"$MESHRDF_HOME/out" "$MESHRDF_HOME/out/$OUT-dups.nt" > "$MESHRDF_HOME/out/$OUT.nt"
gzip -c "$MESHRDF_HOME/out/$OUT.nt" > "$MESHRDF_HOME/out/$OUT.nt.gz"
