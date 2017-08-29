#!/bin/bash 


# Can override the year with the -y argument
YEAR="current"

while getopts "h:y:u:" opt; do
    case $opt in 
        h) export MESHRDF_HOME=$OPTARG ;;
        y) export YEAR=$OPTARG ;;
        u) export MESHRDF_URI=$OPTARG ;;
        *) echo "Usage: $0 [-h meshrdf-home] [-y year] [-u uri] [-i]" 1>&2 ; exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

if [ -z "$MESHRDF_HOME" ]; then
    echo "Please define MESHRDF_HOME environment variable" 1>&2
    exit 1
fi

mkdir -p "$MESHRDF_HOME/out"

# Can override default URI with MESHRDF_URI environment variable

if [[ $YEAR = 'current' ]]; then
    OUTDIR=$MESHRDF_HOME/out
    URI=${MESHRDF_URI:-ftp://ftp.nlm.nih.gov/online/mesh}
    YEAR=""
else
    OUTDIR=$MESHRDF_HOME/out/$YEAR
    URI=${MESHRDF_URI:-ftp://ftp.nlm.nih.gov/online/mesh/$YEAR}
fi


mkdir "$OUTDIR" >& /dev/null

echo ""
echo "curl \"$URI/mesh${YEAR}.nt.gz\" -o \"$OUTDIR/mesh${YEAR}.nt.gz\""
curl "$URI/mesh${YEAR}.nt.gz" -o "$OUTDIR/mesh${YEAR}.nt.gz"

echo ""
echo "gunzip -c \"$OUTDIR/mesh${YEAR}.nt.gz\" > \"$OUTDIR/mesh${YEAR}.nt\""
gunzip -c "$OUTDIR/mesh${YEAR}.nt.gz" > "$OUTDIR/mesh${YEAR}.nt"

