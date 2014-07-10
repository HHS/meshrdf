# MeSH® RDF

This repository contains a set of XSLT files that transform MeSH XML into RDF.

Please read the [MeSH Memorandum of Understanding](http://www.nlm.nih.gov/mesh/2014/download/termscon.html)
before use.

First, clone this repository:

    git clone https://github.com/HHS/mesh-rdf.git
    cd mesh-rdf

Next, you will first need to download the MeSH XML.  Since they are very large, they are not included
with this repository.  You can get them from [the download page](http://www.nlm.nih.gov/mesh/filelist.html);
you will have to agree to the terms of use, and fill out a short form.

The mesh-xml subdirectory of this repository already includes many of the smaller downloadable
files, but not the very large ones.  In particular, you should download the following, and put
them into the mesh-xml directory:

* desc2014.xml
* supp2014.xml
* pa2014.xml

To run the XSLT transformations, the open-source Saxon Home Edition works fine. You can download
it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/).  Navigate to the latest version,
and follow the instructions there (the instructions appear after the list of files).  Typically, you'll
just download the Java Zip file, for example,
[SaxonHE9-5-1-5J.zip](http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip/download).

We'll assume that you've downloaded and unzipped that into the saxonhe subdirectory, for example:

```
unzip -d saxonhe SaxonHE9-5-1-5J.zip
```

You can then run the transforms as follows.  Since the files are quite huge, you might find that you
get an error about running out of heap space.  If so, try adding the command line option
`-Xmx2G` immediately after the `java` command.

```
cd mesh-xml
java -jar ../saxonhe/saxon9he.jar -s:desc2014.xml \
  -xsl:../transformMeSHDescriptors.xsl > desc2014.n3
java -jar ../saxonhe/saxon9he.jar -s:qual2014.xml \
  -xsl:../transformMeSHQualifierRecords.xsl > qual2014.n3
java -jar ../saxonhe/saxon9he.jar -s:supp2014.xml \
  -xsl:../supplConceptRecord.xsl > supp2014.n3
```



# Generation of the hierarchy

***FIXME:  where is this file?  How does it work?***

In an RDF database, script creatMeSHHierarchy.sql create a relation
child mesh:upperDescriptor parent based on tree numbers

