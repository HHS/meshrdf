#!/bin/bash 


while getopts "h:y:u:" opt; do
    case $opt in 
        h) export MESHRDF_HOME=$OPTARG ;;
        y) export MESHRDF_YEAR=$OPTARG ;;
        u) export MESHRDF_URI=$OPTARG ;;
        *) echo "Usage: $0 [-h meshrdf-home] [-y year] [-u uri] [-i]" 1>&2 ; exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

if [ -z "$MESHRDF_HOME" ]; then
    echo "Please define MESHRDF_HOME environment variable" 1>&2
    exit 1
fi

mkdir -p "$MESHRDF_HOME/data"

# CAn override default year with MESHRDF_YEAR environment variable
YEAR=${MESHRDF_YEAR:-2015}

# Can override default URI with MESHRDF_URI environment variable
URI=${MESHRDF_URI:-ftp://ftp.nlm.nih.gov/online/mesh/$YEAR}

wget "$URI/desc$YEAR.xml" -O "$MESHRDF_HOME/data/desc$YEAR.xml"
wget "$URI/qual$YEAR.xml" -O "$MESHRDF_HOME/data/qual$YEAR.xml"
wget "$URI/supp$YEAR.xml" -O "$MESHRDF_HOME/data/supp$YEAR.xml"

if [ $YEAR -le 2015 ]; then
    wget "$URI/desc$YEAR.dtd" -O "$MESHRDF_HOME/data/desc$YEAR.dtd"
    wget "$URI/qual$YEAR.dtd" -O "$MESHRDF_HOME/data/qual$YEAR.dtd"
    wget "$URI/supp$YEAR.dtd" -O "$MESHRDF_HOME/data/supp$YEAR.dtd"
fi

