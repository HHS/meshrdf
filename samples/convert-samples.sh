#!/bin/sh
# This script will convert the sample XML files, which contain all the entities listed
# in sample-list.txt.

# Can override default year with MESHRDF_YEAR environment variable
YEAR=${MESHRDF_YEAR:-2016}

# Override the default Mesh prefix and output file by setting MESHRDF_URI_YEAR to "yes"
if [ "$MESHRDF_URI_YEAR" = "yes" ]; then
    PREFIX=mesh/$YEAR
    OUT=mesh$YEAR
    URI_YEAR_PARAM=uri-year-segment=$YEAR
else
    PREFIX=mesh
    OUT=mesh
    URI_YEAR_PARAM=
fi

java -jar $SAXON_JAR -s:qual-samples.xml -xsl:../xslt/qual.xsl $URI_YEAR_PARAM > qual-samples.nt
java -jar $SAXON_JAR -s:desc-samples.xml -xsl:../xslt/desc.xsl $URI_YEAR_PARAM > desc-samples.nt
java -jar $SAXON_JAR -s:supp-samples.xml -xsl:../xslt/supp.xsl $URI_YEAR_PARAM > supp-samples.nt
cat qual-samples.nt desc-samples.nt supp-samples.nt > samples-dups.nt
sort -u samples-dups.nt > samples.nt