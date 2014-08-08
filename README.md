# MeSH® RDF

This repository contains a set of XSLT files that transform MeSH XML into RDF.

Please read the [MeSH Memorandum of Understanding](http://www.nlm.nih.gov/mesh/2014/download/termscon.html)
before use.

For documention, see the [GitHub wiki](https://github.com/HHS/mesh-rdf/wiki).

## Quick start

First, clone this repository:

    git clone https://github.com/HHS/mesh-rdf.git
    cd mesh-rdf

Next, you can either explore this repository using the included sample XML files (which are
relatively small), or, if you need complete and up-to-date data, you can download the latest
MeSH XML files from the NLM server.  The latter option is described first.

### Getting the MeSH XML files

When you download the MeSH XML files, save them to the *data* subdirectory.
Some files (such as the DTDs) are already included with this repository, but the XML data files are not.
You can get them from [the download page](http://www.nlm.nih.gov/mesh/filelist.html);
you will have to agree to the terms of use, and fill out a short form.
In particular, you should download at least the following:

* desc2014.dtd
* desc2014.xml
* pa2014.dtd
* pa2014.xml
* qual2014.dtd
* qual2014.xml
* supp2014.dtd
* supp2014.xml


### Getting Saxon

If you already have the Saxon XSLT processor on your system, you can skip this step.

There are a number of different ways to run the XSLT stylesheets to convert the XML data
into RDF.  The XSLTs are written in XSLT 2.0, though, so the very xsltproc command, which
comes on most Unix systems, will not work.

Probably the easiest way is to download and extract the open-source Saxon Home Edition, which
is written in Java, and will work on most platforms. You can download
it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/).  Navigate to the latest version,
and follow the instructions (which appear after the list of files).  You can
just download the Java zip file, for example,
[SaxonHE9-5-1-5J.zip](http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip/download).

Download and unzip that into the *saxon* subdirectory.  For example:

```
unzip -d saxon SaxonHE9-5-1-5J.zip
```

Next, all of the instructions below, and some of the scripts in the repository, assume that you
have set an environment variable SAXON_JAR to point to the executable Jar file that comes with the
Saxon download.

If you are on a Unix system:

```
export SAXON_JAR=`pwd`/saxon/saxon9he.jar
```

If your version of Saxon is in a different location, then, of course, set this environment variable
appropriately.

On Windows:

```
set SAXON_JAR=*repository-dir*\saxon\saxon9he.jar
```

Where "repository-dir" is the base directory of this repository.



### Running conversion scripts

There are a few conversion scripts in the repository which you can use to run the
XSLT conversions.


The conversion scripts are:

* convert-all.sh - For unix, this shell script will brute-force convert each of the three
  main MeSH XML files into RDF N-Triples format, and put the results into the *out* directory
* convert-all.bat - This does the same thing, but can be run from Windows.
* convert-all.pl - This Perl script takes a completely different approach, that is useful
  for doing the conversions on less-powerful machines.  It first chops up each of the
  input XML files into manageable sized chunks, and then runs each chunk through the
  XSLTs separately.  It should run on any machine that has Perl installed.


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

## Samples / testing

In the *samples* subdirectory are a number of sample files that can be used for testing

The *sample-list.txt* file includes a compilation of items from each of the three main XML
files that provide a fairly good

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
