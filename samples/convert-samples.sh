java -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:qual-samples.xml -xsl:../xslt/qual.xsl > qual-samples.nt
java -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:desc-samples.xml -xsl:../xslt/desc.xsl > desc-samples.nt
java -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:supp-samples.xml -xsl:../xslt/supp.xsl > supp-samples.nt
cat qual-samples.nt desc-samples.nt supp-samples.nt > samples.nt
