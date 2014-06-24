These are a set of XSLT files that transform MeSH XML into RDF.

To run them, you will first need to download the MeSH XML.  Next, you can use Saxon
Home edition to run the transformations.  We'll assume that you have downloaded the
MeSH XML into the same directory as the XSLTs, and Saxon HE into the $SAXON_HOME directory.

You can then run the transforms as follows:

```
java -jar $SAXON_HOME/saxon9he.jar -s:desc2014.xml -xsl:transformMeSHDescriptors.xsl >desc2014.n3
```
