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
and follow the instructions (which appear after the list of files).  You can
just download the Java zip file, for example,
[SaxonHE9-5-1-5J.zip](http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip/download).

Download and unzip that into the *saxon* subdirectory.  Then, set an alias
to help in executing the Java command with the Saxon jar file.  For example (this
example assumes you're using a unix shell):

```
unzip -d saxon SaxonHE9-5-1-5J.zip
alias saxon="java -jar `pwd`/saxon/saxon9he.jar \$*"
```

You can then run the transforms as follows (from the root directory of the project).
Since the files are quite huge, you might find that you
get an error about running out of heap space.  If so, try adding the command line option
`-Xmx2G` immediately after the `java` command.

```
mkdir out
saxon -s:data/qual2014.xml -xsl:xslt/qual.xsl > out/qual2014.nt
saxon -s:data/desc2014.xml -xsl:xslt/desc.xsl > out/desc2014.nt
saxon -s:data/supp2014.xml -xsl:xslt/supp.xsl > out/supp2014.nt
```


## Project directory structure

These are the subdirectories of this project -- either part of the repository, or created:

* *data* - Source MeSH XML, DTD, and other ancillary files. The main data XML files are not part of the
  repository, but should be downloaded separately.
* *doc* - Schema for the RDF, and other documentation
* *rnc* - Relax NG Compact version of the MeSH XML file schema
* *samples* - Contrived and stripped-down version of some XML data files, for testing, as well as sample
  SPARQL queries
* *saxon* - Not part of the repository, this is where the Saxon XSLT processor should be extracted to.
* *sql* - Some queries that are used to enhance the RDF graphs, in particular, by creating the links
  that encode the tree hierarchies
* *xslt* - The main XSLT processor files that convert the XML into RDF.


## Generation of the tree hierarchy

Once the original RDF data has been loaded to an RDF database such as Virtuoso, the script
sql/createMeSHHierarchy.sql creates skos:broader links between parent and child nodes
of the tree hierarchy, based on the tree numbers.


## Testing

There are some files that can be used for testing in the samples directory.  In particular:

* desc2014-head.xml - the first 20000 lines (or so) of desc2014.xml
* qual2014.xml - a complete copy of this
* supp2014-head.xml - the first 10000 lines (or so) of supp2014.xml

In addition, the latest output from the XSLTs for these sample files is also included in the
repository, to act as a baseline for testing:

* desc2014-head.nt
* qual2014.nt
* supp2014-head.nt

For now, changes to the XSLTs (see issue #13) shouldn't result in significant changes to the RDF
output. After making changes to the XSLTs, to verify that the changes haven't done any significant
damage, do this (example for the other two types is similar):

```
cd samples
saxon -s:desc2014-head.xml -xsl:../xslt/desc.xsl > desc2014-head.new.nt
diff desc2014-head.nt desc2014-head.new.nt
```

If there were minor changes, like whitespace, or other changes that you deem okay, don't forget
to update the baseline:

```
cp desc2014-head.new.nt desc2014-head.nt
```

Also, don't forget to commit and push your changes after each sitting.
