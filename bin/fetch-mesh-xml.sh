#!/bin/sh

mkdir -p $MESHRDF_HOME/data

wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/desc2014.dtd -O $MESHRDF_HOME/data/desc2014.dtd
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/desc2014.xml -O $MESHRDF_HOME/data/desc2014.xml
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/pa2014.dtd -O $MESHRDF_HOME/data/pa2014.dtd
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/pa2014.xml -O $MESHRDF_HOME/data/pa2014.xml
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/qual2014.dtd -O $MESHRDF_HOME/data/qual2014.dtd
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/qual2014.xml -O $MESHRDF_HOME/data/qual2014.xml
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/supp2014.dtd -O $MESHRDF_HOME/data/supp2014.dtd
wget ftp://ftp.nlm.nih.gov/online/mesh/.xmlmesh/supp2014.xml -O $MESHRDF_HOME/data/supp2014.xml

