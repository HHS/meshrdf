# MeSH® RDF

This repository contains a set of XSLT files that transform MeSH XML into RDF.

Please read the [MeSH Memorandum of Understanding](http://www.nlm.nih.gov/mesh/2014/download/termscon.html)
before use.

## Quick start

First, clone this repository:

    git clone https://github.com/HHS/mesh-rdf.git
    cd mesh-rdf

Next, you will first need to download the MeSH XML files, and save them to the *data* subdirectory.
Some files (such as the DTDs) are already included with this repository, but the XML data files are not.
You can get them from [the download page](http://www.nlm.nih.gov/mesh/filelist.html);
you will have to agree to the terms of use, and fill out a short form.
In particular, you should download the following:

* desc2014.xml
* qual2014.xml
* supp2014.xml
* pa2014.xml

To run the XSLT transformations, the open-source Saxon Home Edition works fine. You can download
it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/).  Navigate to the latest version,
and follow the instructions there (the instructions appear after the list of files).  Typically, you'll
just download the Java Zip file, for example,
[SaxonHE9-5-1-5J.zip](http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip/download).

Download and unzip that into the *saxon* subdirectory.  Then, set an environment variable
to point to use to execute the Java command, with the Saxon jar file.  For example:

```
unzip -d saxon SaxonHE9-5-1-5J.zip
export SAXON="java -jar `pwd`/saxon/saxon9he.jar"
```

You can then run the transforms as follows (from the root directory of the project).
Since the files are quite huge, you might find that you
get an error about running out of heap space.  If so, try adding the command line option
`-Xmx2G` immediately after the `java` command.

```
mkdir out
$SAXON -s:data/qual2014.xml -xsl:xslt/qual.xsl > out/qual2014.n3
$SAXON -s:data/desc2014.xml -xsl:xslt/desc.xsl > out/desc2014.n3
$SAXON -s:data/supp2014.xml -xsl:xslt/supp.xsl > out/supp2014.n3
```


## Project directory structure

These are the subdirectories of this project -- either part of the repository, or created:

```
data - Source MeSH XML, DTD, and other ancillary files. The main data XML files are not part of the
  repository, but should be downloaded separately.
doc - Schema for the RDF, and other documentation
rnc - Relax NG Compact version of the MeSH XML file schema
samples - Contrived and stripped-down version of some XML data files, for testing, as well as sample
  SPARQL queries
saxon - Not part of the repository, this is where the Saxon XSLT processor should be extracted to.
sql - Some queries that are used to enhance the RDF graphs, in particular, by creating the links
  that encode the tree hierarchies
xslt - The main XSLT processor files that convert the XML into RDF.
```


# Generation of the hierarchy

***FIXME:  where is this file?  How does it work?***

In an RDF database, script creatMeSHHierarchy.sql create a relation
child mesh:upperDescriptor parent based on tree numbers

