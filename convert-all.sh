java -Xmx2G -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:data/qual2014.xml -xsl:xslt/qual.xsl > out/qual2014.nt
java -Xmx2G -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:data/desc2014.xml -xsl:xslt/desc.xsl > out/desc2014.nt
java -Xmx2G -jar /home/klortho/bin/saxon9he/saxon9he.jar -s:data/supp2014.xml -xsl:xslt/supp.xsl > out/supp2014.nt

