#!/bin/sh
#
# This script will convert all of the MeSH XML to RDF, assuming that your machine has
# enough memory and resources.  It will also copy over the vocabulary and void files.
# It should be run from the root directory of the clone of the hhs/meshrdf repository.
# The environment variable $MESHRDF_HOME is used to determine the `data` and `out`
# directories. 
#
# It is parameterized according to the following environment variables:
# - MESHRDF_YEAR - default is "2015". Set this to override the *source* data. In other
#   words, this is used to determine which XML files are used as input.
# - MESHRDF_URI_YEAR
#   By default:
#     - the generated URIs will not include the year,
#     - the output file will be named mesh.nt, and
#     - it will be put into the output directory $MESHRDF_HOME/out
#   If this is set to "yes", then:
#     - the generated URIs will include the year,
#     - the output file will be have the name meshYYYY.nt, and
#     - it will be put into the output directory $MESHRDF_HOME/out/YYYY

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

# Set the output file name, and the parameter that controls the RDF URIs,
# according to whether or not MESHRDF_URI_YEAR is "yes"
if [ "$MESHRDF_URI_YEAR" = "yes" ]; then
    OUTDIR=$MESHRDF_HOME/out/$YEAR
    OUTFILE=$OUTDIR/mesh$YEAR
    URI_YEAR_PARAM=uri-year-segment=$YEAR
    URI_PREFIX="http://id.nlm.nih.gov/mesh/$YEAR"
else
    OUTDIR=$MESHRDF_HOME/out
    OUTFILE=$OUTDIR/mesh
    URI_YEAR_PARAM=
    URI_PREFIX="http://id.nlm.nih.gov/mesh"
fi


mkdir -p $OUTDIR

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/qual$YEAR.xml" \
    -xsl:xslt/qual.xsl $URI_YEAR_PARAM > "$OUTFILE-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/qual$YEAR.xml" 1>&2
    exit 1
fi

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/desc$YEAR.xml" \
    -xsl:xslt/desc.xsl $URI_YEAR_PARAM >> "$OUTFILE-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/desc$YEAR.xml" 1>&2
    exit 1
fi

java -Xmx4G -jar $SAXON_JAR -s:"$MESHRDF_HOME/data/supp$YEAR.xml" \
    -xsl:xslt/supp.xsl $URI_YEAR_PARAM >> "$OUTFILE-dups.nt"
if [ $? -ne 0 ]; then
    echo "Error converting $MESHRDF_HOME/data/supp$YEAR.xml" 1>&2
    exit 1
fi

if [ -f "$MESHRDF_HOME/data/cns-disease-2014AB.nt" ]; then
    sed -e "s,http://id.nlm.nih.gov/mesh,$URI_PREFIX," \
        "$MESHRDF_HOME/data/cns-disease-2014AB.nt" >> "$OUTFILE-dups.nt"
fi

sort -u -T"$OUTDIR" "$OUTFILE-dups.nt" > "$OUTFILE.nt"
if [ $? -ne 0 ]; then 
    echo "Error deduplicating $OUTFILE-dups.nt" 1>&2
    exit 1
fi

gzip -c "$OUTFILE.nt" > "$OUTFILE.nt.gz"
if [ $? -ne 0 ]; then
    echo "Error compressing $OUTFILE.nt" 1>&2
    exit 1
fi

cp meta/vocabulary.ttl $OUTDIR
cp meta/void.ttl $OUTDIR

cd $OUTDIR

vocab_version=`awk '$1~/versionInfo/ { gsub(/"/, "", $2); print $2 }' vocabulary.ttl`
if [ -z "$vocab_version" ]; then 
    echo "Unable to determine vocabulary.ttl version" 1>&2
    exit 1
fi

void_version=`awk '$1~/versionInfo/ { gsub(/"/, "", $2); print $2 }' void.ttl`
if [ -z "$void_version" ]; then 
    echo "Unable to determine void.ttl version" 1>&2
fi

ln -f void.ttl void_$vocab_version.ttl
ln -f vocabulary.ttl vocabulary_$vocab_version.ttl

