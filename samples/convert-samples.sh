#!/bin/sh
# This script will convert the sample XML files, which contain all the entities listed
# in sample-list.txt.

java -jar $SAXON_JAR -s:qual-samples.xml -xsl:../xslt/qual.xsl > qual-samples.nt
java -jar $SAXON_JAR -s:desc-samples.xml -xsl:../xslt/desc.xsl > desc-samples.nt
java -jar $SAXON_JAR -s:supp-samples.xml -xsl:../xslt/supp.xsl > supp-samples.nt
cat qual-samples.nt desc-samples.nt supp-samples.nt > samples.nt
