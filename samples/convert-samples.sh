#!/bin/sh
# This script will convert the sample XML files, which contain all the entities listed
# in sample-list.txt.

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

sed -e "s,MESHRDF_PATH,$PREFIX,g" ../xslt/mesh-rdf-prefixes.ent.template > ../xslt/mesh-rdf-prefixes.ent

java -jar $SAXON_JAR -s:qual-samples.xml -xsl:../xslt/qual.xsl > qual-samples.nt
java -jar $SAXON_JAR -s:desc-samples.xml -xsl:../xslt/desc.xsl > desc-samples.nt
java -jar $SAXON_JAR -s:supp-samples.xml -xsl:../xslt/supp.xsl > supp-samples.nt
cat qual-samples.nt desc-samples.nt supp-samples.nt > samples-dups.nt
sort -u samples-dups.nt > samples.nt