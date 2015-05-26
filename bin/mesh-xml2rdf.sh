#!/bin/sh
#
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.
#
# It is parameterized according to the following environment variables:
# - MESHRDF_YEAR - default is "2015". Set this to override the *source* data. In other
#   words, this is used to determine which XML files are used as input.
# - MESHRDF_URI_YEAR - no default. If this is set to "yes", then the generated URIs will
#   include the year.

if [ -z "$MESHRDF_HOME" ]; then
    echo "Please define MESHRDF_HOME environment variable" 1>&2
    exit 1
fi

if [ -z "$SAXON_JAR" ]; then
    echo "Please define SAXON_JAR environment variable" 1>&2
    exit 1
fi

# Can override default year with MESHRDF_YEAR environment variable
YEAR=${MESHRDF_YEAR:-2015}

# Override the default Mesh prefix and output file by setting MESHRDF_URI_YEAR to "yes"
if [ "$MESHRDF_URI_YEAR" = "yes" ]; then
    PREFIX=mesh/$YEAR
    OUT=mesh$YEAR
else
    PREFIX=mesh
    OUT=mesh
fi

#echo PREFIX = $PREFIX
#echo OUT = $OUT

# substitute the prefix into the DTD entity file
sed -e "s,MESHRDF_PATH,$PREFIX,g" xslt/mesh-rdf-prefixes.ent.template > xslt/mesh-rdf-prefixes.ent
if [ $? -ne 0 ]; then 
    echo "Error creating xslt/mesh-rdf-prefixes.ent from template" 1>&2
    exit 1
fi

mkdir -p "$MESHRDF_HOME/out"

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/qual$YEAR.xml" \
    -xsl:xslt/qual.xsl > "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/qual$YEAR.xml" 1>&2
    exit 1
fi

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/desc$YEAR.xml" \
    -xsl:xslt/desc.xsl >> "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/desc$YEAR.xml" 1>&2
    exit 1
fi

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/supp$YEAR.xml" \
    -xsl:xslt/supp.xsl >> "$MESHRDF_HOME/out/$OUT-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/supp$YEAR.xml" 1>&2
    exit 1
fi

sort -u -T"$MESHRDF_HOME/out" "$MESHRDF_HOME/out/$OUT-dups.nt" > "$MESHRDF_HOME/out/$OUT.nt"
if [ $? -ne 0 ]; then 
    echo "Error deduplicating $MESHRDF_HOME/out/$OUT-dups.nt" 1>&2
    exit 1
fi

gzip -c "$MESHRDF_HOME/out/$OUT.nt" > "$MESHRDF_HOME/out/$OUT.nt.gz"
if [ $? -ne 0 ]; then
    echo "Error compressing $MESHRDF_HOME/out/$OUT.nt" 1>&2
    exit 1
fi
