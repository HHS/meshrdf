# MeSH® RDF

This repository contains a set of XSLT files that transform MeSH XML into RDF, and also contains
the content for the technical documentation pages, deployed as a set of GitHub pages, at
[http://hhs.github.io/meshrdf](http://hhs.github.io/meshrdf).

Please see that technical documentation for details about the data model, and how this new
RDF version of MeSH relates to the XML from which it derives.

The rest of this README describes how to set up a development environment, perform the
transformations yourself, if you are interested in doing that.  All the instructions assume
that you're running on a Unix-like operating system, in a bash shell.

## Quick start

First, clone this repository:

    git clone https://github.com/HHS/meshrdf.git
    cd meshrdf

Next, you can either explore this repository using the included sample XML files (in the
*samples* directory, which are
relatively small), or, if you need complete and up-to-date data, you can download the latest
MeSH XML files from the NLM server.  The latter option is described first.

### Getting the MeSH XML files

Since the complete MeSH data files are quite large, we assume that they'll be kept
location on the filesystem that is separate from this GitHub repository.  Set the environment variable
$MESHRDF_HOME to point to that location.  For example,

    export MESHRDF_HOME=/var/data/mesh-rdf

You can run the script *bin/fetch-mesh-xml.sh*, which downloads all the XML and corresponding
DTD files from the NLM FTP server.  It saves them to the *data* subdirectory of $MESHRDF_HOME.

It downloads the following:

* desc2014.dtd
* desc2014.xml
* pa2014.dtd
* pa2014.xml
* qual2014.dtd
* qual2014.xml
* supp2014.dtd
* supp2014.xml


### Getting Saxon

There are a number of different ways to run the XSLT stylesheets to convert the XML data
into RDF.  The XSLTs are written in XSLT 2.0, though, so the `xsltproc` command, which
comes on most Unix systems, will not work.

One easy way is to download and extract the open-source *Saxon Home Edition*, which
is written in Java, and will work on most platforms. You can download
it from [here](http://sourceforge.net/projects/saxon/files/Saxon-HE/).  Navigate to the latest version,
and follow the instructions (which appear after the list of files). As a shortcut, you can
download version 9.5 (which is known to work with these XSLTs) from the command line directly:

    wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.5/SaxonHE9-5-1-5J.zip

Unzip that into the *saxon9he* subdirectory.  For example:

    unzip -d saxon9he SaxonHE9-5-1-5J.zip

Set an environment variable SAXON_JAR to point to the executable Jar file:

    export SAXON_JAR=*repository-dir*/saxon9he/saxon9he.jar

Where *repository-dir* is the base directory of this repository.
If your version of Saxon is in a different location, then, of course, set this environment variable
appropriately.

On Windows:

    set SAXON_JAR=*repository-dir*\saxon\saxon9he.jar


### Converting the complete MeSH data set

There are a few conversion scripts in the repository which you can use to run the
XSLT conversions.

The conversion scripts are:

* mesh-xml2rdf.sh - For unix, this shell script will brute-force convert each of the three
  main MeSH XML files into RDF N-Triples format, and put the results into the *out* directory
* mesh-xml2rdf.bat - This does the same thing, but can be run from Windows.
* mesh-xml2rdf.pl - [To do: fix this to work with the MESHRDF_HOME env. var.]
  This Perl script takes a completely different approach, that is useful
  for doing the conversions on less-powerful machines.  It first chops up each of the
  input XML files into manageable sized chunks, and then runs each chunk through the
  XSLTs separately.  It should run on any machine that has Perl installed.


### Generating and converting the sample files

In the *samples* subdirectory are a number of sample files that can be used for testing.
The XML files here are generated from the full MeSH XML files, but are included in the
repository so that anyone can get up and running, and try things out, very easily.

The *sample-list.txt* file has the list of items from each of the three main XML
files that provide a fairly good coverage of the variation of data found within MeSH.

These three sample files, corresponding to that list and the three main XML files,
are included in the repository:

* desc-samples.xml
* qual-samples.xml
* supp-samples.xml

The Perl script *make-samples.pl* can be used to regenerate these sample files from the
master XML files, extracting just those items that are listed in the *sample-list.txt*
file, if any of those changes.  So, keep in mind that these samples in the repository are
used for testing/demo purposes, and are not necessarily up-to-date with the latest MeSH
release.

Finally, either of the scripts *convert-samples.sh* (for Unix) or *convert-samples.bat*
(for Windows) can be used to convert the sample XML files into RDF, the final output
being *samples.nt*.


## Project directory structure

These are the subdirectories of this project -- either part of the repository, or created:

* *bin* - Scripts for fetching the XML and running the conversions
* *meta* - Schema for the RDF, and other documentation
* *rnc* - Relax NG Compact version of the MeSH XML file schema (experimental, not normative)
* *samples* - XML data files for testing and demo purposes, which each contain a small subset
  of the items from the real XML data files, as described above.
* *xslt* - The main XSLT processor files that convert the XML into RDF.

These are the subdirectories of the $MESHRDF_HOME directory, which typically (but not necessarily)
is set to some separate location:

* *data* - Source MeSH XML and DTD files. These files are quite large, and change often,
  so they are not part of the repository, but should be downloaded separately, as described above.
* *out* - Product RDF files, in n-triples format.  The conversion scripts write these product
  files here.


## Virtuoso setup

Here are some notes for downloading and building OpenLink's Virtuoso software, which can be
used for querying the resulting RDF.  These notes are here for reference only, in case they
are helpful.  If these don't work for you, please direct questions to the OpenLink group.

Dependencies: gcc, gmake, autoconf, automake, libtool, flex, bison, gperf, gawk, m4, make, openssl-devel, readline-devel, wget.

Decide on a directory where you will install virtuoso, and set the $VIRTUOSO_HOME environment variable to point to that.

Checkout source from github:

    git clone git://github.com/openlink/virtuoso-opensource.git
    cd virtuoso-opensource
    git checkout develop/7   # should say already on develop/7

Build:

    ./autogen.sh
    CFLAGS="-O2 -m64"
    export CFLAGS
    ./configure --prefix=$VIRTUOSO_HOME
    make
    make install

Start up of server:

    cd $VIRTUOSO_HOME/virtuoso/var/lib/virtuoso/db
    $VIRTUOSO_HOME/bin/virtuoso-t

Shutdown of server (see [the Virtuoso
documentation](http://data-gov.tw.rpi.edu/wiki/How_to_install_virtuoso_sparql_endpoint#Manual_Shutdown)):

    $VIRTUOSO_HOME/bin/isql 1111 dba <password>
    SQL> shutdown();

## Technical documentation on GitHub pages

The gh-pages branch of this repository is used to generate the technical documentation
viewable from [http://hhs.github.io/meshrdf](http://hhs.github.io/meshrdf).  Please see the
[README file in that branch](../gh-pages/README.md) for more information.

