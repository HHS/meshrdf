# MeSH® RDF

This directory contains two modules for MeSH in RDF:

* A set of XSLT files that transform MeSH XML into RDF
* A Java-based user interface, based on EBI's Lodestar.

The GitHub repository also contains the content for the technical documentation pages, deployed as a set of GitHub pages, at [http://hhs.github.io/meshrdf](http://hhs.github.io/meshrdf).

Please see that technical documentation for details about the data model, and how this new
RDF version of MeSH relates to the XML from which it derives.

The rest of this README describes:
* How to set up a development environment and perform the transformations yourself, if you are interested in doing that.
* How to build the Java UI as a front-end for OpenLink Virtuoso, if you are interested in doing that.

All the instructions assume that you're running on a Unix-like operating system, in a bash shell. If you have a Windows machine, we recommend that you install [cygwin](https://www.cygwin.com/) or [Git for Windows](https://git-scm.com/download) Please let us know (by opening a GitHub issue) if you have problems.

## RDF Download

The RDF files in N-Triples format can be downloaded from

    ftp://ftp.nlm.nih.gov/online/mesh/rdf/

You will find there two main files:

* mesh.nt - N-Triples files for the current MeSH year
* mesh.nt.gz - Gzip compresesd files
* SHA-1 checksums for both of these

Sub-directories contain N-Triples files where the subject URIs are prefixed with the year.

## Quick start

Follow these steps convert MeSH XML to RDF yourself.

First, clone this repository.

    git clone https://github.com/HHS/meshrdf.git
    cd meshrdf

Next, you can either explore this repository using the included sample XML files (in the
*samples* directory, which are
relatively small), or, if you need complete and up-to-date data, you can download the latest
MeSH XML files from the NLM server.  The latter option is described first.


### Getting the MeSH XML files

Since the complete MeSH data files are quite large, we assume that they'll be kept
location on the filesystem that is separate from this GitHub repository.  Set the environment variable
`$MESHRDF_HOME` to point to that location.  For example,

    export MESHRDF_HOME=/var/data/mesh-rdf

You can run the script `bin/fetch-mesh-xml.sh`, which downloads all the XML and corresponding
DTD files from the NLM FTP server.

    bin/fetch-mesh-xml.sh

This saves the XML files to the `data` subdirectory of `$MESHRDF_HOME`.

By default, it downloads the following:

* `desc2017.xml`
* `qual2017.xml`
* `supp2017.xml`

If you want to download a different year's data, use the `-y` argument when executing the script.
For example:

    bin/fetch-mesh-xml.sh -y 2016

When downloading a year less than or equal to 2015, `bin/fetch-mesh-xml.sh` will also download the DTDs.
For example:

* `desc2015.xml` and `desc2015.dtd`
* `qual2015.xml` and `qual2015.dtd`
* `supp2015.xml` and `supp2015.dtd`


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

Unzip that into the `saxon9he` subdirectory.  For example:

    unzip -d saxon9he SaxonHE9-5-1-5J.zip

Set an environment variable `SAXON_JAR` to point to the executable Jar file:

    export SAXON_JAR=*repository-dir*/saxon9he/saxon9he.jar

Where *repository-dir* is the base directory of this repository.
If your version of Saxon is in a different location, then, of course, set this environment variable
appropriately.


### Converting the complete MeSH data set

The conversion script is `bin/mesh-xml2rdf.sh`. This shell script will run the XSLTs to convert each of
the three main MeSH XML files into RDF N-Triples format, and put the results into the
`$MESHRDF_HOME/out` directory.

By default, it looks for 2017 data files, and will produce `mesh.nt`, which is the
RDF in N-triples format, and `mesh.nt.gz`, a gzipped version. Also by default, these
data files will have RDF URIs that do not include the year. For example, the descriptor for
Ofloxacin would have the URI `http://id.nlm.nih.gov/mesh/D015242`.

As with the fetch script, described above, you can use the `-y` argument to
specify that it convert a different set of data files. For example:

    bin/mesh-xml2rdf.sh -y 2016

This uses the 2016 data files to produce the "current" RDF output files `out/mesh.nt`
and `out/mesh.nt.gz`.

To produce RDF data that has URIs with the year, you should also use the `-u` argument.
For example, the following generates RDF URIs that include the year:

    bin/mesh-xml2rdf.sh -y 2016 -u

In this case, the output data files will be written to `out/2016/mesh2016.nt` and
`out/2015/mesh2016.nt.gz`.

### URI preservation and versioning

The vocabulary, `meta/vocabulary.ttl`, includes data proprerties used to indicate
which entities are still present in MeSH XmL, and which are no longer present.
However, these scripts produce N-triples files that are inputs to the data
processing that preserves URIs and adds these properties.

You can get N-triples files preserving URIs from
[mesh.nt.gz](ftp://ftp.nlm.nih.gov/online/mesh/rdf/mesh.nt.gz) and
[mesh.nt](ftp://ftp.nlm.nih.gov/online/mesh/rdf/mesh.nt) online.

There are also SHA-1 checksums on the FTP server.

### Generating and converting the sample files

In the `samples` subdirectory are a number of sample files that can be used for testing.
The XML files here are generated from the full MeSH XML files, but are included in the
repository so that anyone can get up and running, and try things out, very easily.

The `sample-list.txt` file has the list of items from each of the three main XML
files that provide a fairly good coverage of the variation of data found within MeSH.

These three sample files, corresponding to that list and the three main XML files,
are included in the repository:

* desc-samples.xml
* qual-samples.xml
* supp-samples.xml

The Perl script `make-samples.pl` can be used to regenerate these sample files from the
master XML files, extracting just those items that are listed in the `sample-list.txt`
file, if any of those changes.  So, keep in mind that these samples in the repository are
used for testing/demo purposes, and are not necessarily up-to-date with the latest MeSH
release.

Finally, the script `convert-samples.sh` can be used to convert the sample XML files into
RDF, the final output being `samples.nt`.

***Note that the generated RDF will be missing a lot of meshv:parentTreeNumber
relationships, because those are generated from the tree node identifiers to link between
various records. Since the sample files contain only a subset of the records, most of
these cannot be generated.***

## Project directory structure

These are the subdirectories of this project -- either part of the repository, or created:

* *bin* - Scripts for fetching the XML and running the conversions
* *meta* - Schema for the RDF, and other documentation
* *rnc* - Relax NG Compact version of the MeSH XML file schema (experimental, not normative)
* *samples* - XML data files and scripts for testing and demo purposes, which each contain a small subset
  of the items from the real XML data files, as described above.
* *xslt* - The main XSLT processor files that convert the XML into RDF.
* *data* - an NTriples files containing rdfs:label for Central Nervous System diseases in 14 languages.  This is included as an example.
* *webui* - Java overlay for lodestar (https://github.com/EBISPOT/lodestar)


These are the subdirectories of the `$MESHRDF_HOME` directory, which typically (but not necessarily)
is set to some separate location:

* *data* - Source MeSH XML files. These files are moderately large, and change often,
  so they are not part of the repository, but should be downloaded separately, as described above.
* *out* - Product RDF files, in n-triples format.  The conversion scripts write these product
  files here.  Copies of the data files may also appear here.

## Virtuoso setup

Here are some notes for downloading and building OpenLink's Virtuoso software, which can be
used for querying the resulting RDF.  These notes are here for reference only, in case they
are helpful.  If these don't work for you, please direct questions to the OpenLink group.

Dependencies: gcc, gmake, autoconf, automake, libtool, flex, bison, gperf, gawk, m4, make, openssl-devel, readline-devel, wget.

Decide on a directory where you will install virtuoso, and set the $VIRTUOSO_HOME environment variable to point to that.

Checkout source from github:

    git clone https://github.com/openlink/virtuoso-opensource.git
    cd virtuoso-opensource
    git checkout develop/7   # should say already on develop/7

Build:

    ./autogen.sh
    CFLAGS="-O2 -m64"
    export CFLAGS
    ./configure --prefix=$VIRTUOSO_HOME --with-readline
    make
    make install

Start up of server:

    cd $VIRTUOSO_HOME/virtuoso/var/lib/virtuoso/db
    $VIRTUOSO_HOME/bin/virtuoso-t

Shutdown of server (see [the Virtuoso
documentation](http://data-gov.tw.rpi.edu/wiki/How_to_install_virtuoso_sparql_endpoint#Manual_Shutdown)):

    kill -s SIGTERM `cut -d= -f2 $VIRTUOSO_HOME/virtuoso/var/lib/virtuoso/db/virtuoso.lck`

## Building the webui with Maven

The webui depends on a parent pom.xml that contains local properties.  This is
to avoid placing passwords in the clear into git.  If you do a build with
virtuoso running on the localhost, without changing the default dba password,
and you have loaded the MeSH RDF data, the build should work.

However, in a real world scenario, you should edit your local Maven
configuration file, `$HOME/.m2/settings.xml`, to add a profile that overrides
some properties.

* To run unit tests, you may need to override the following properties:
    - `virtuosoServerName`
    - `virtuosoUserName`
    - `virtuosoPassword`
* To deploy artifacts to a Maven repository, you may need to override the following properties:
    - `release.repo.url`
    - `snapshot.repo.url`
    - Make sure the servers mentioned in `webui/pom.xml` appear in your local `settings.xml`

Here's an example command-line with profile `meshrdf`:

    mvn -D meshrdf clean package

## Technical documentation on GitHub pages

The gh-pages branch of this repository is used to generate the technical documentation
viewable from [http://hhs.github.io/meshrdf](http://hhs.github.io/meshrdf).  Please see the
[README file in that branch](../gh-pages/README.md) for more information.

