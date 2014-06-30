MeSH RDF version
Current MeSH version in use: 2014

These are a set of XSLT files that transform MeSH XML into RDF.

Please read the MeSH® Memorandum of Understanding before use.
http://www.nlm.nih.gov/mesh/2014/download/termscon.html

To run these, you will first need to download the MeSH XML.  Next, you can use Saxon
Home edition to run the transformations.  We'll assume that you have downloaded the
MeSH XML into the same directory as the XSLTs, and Saxon HE into the $SAXON_HOME directory.

You can then run the transforms as follows:

```
java -jar $SAXON_HOME/saxon9he.jar -s:desc2014.xml \
  -xsl:transformMeSHDescriptors.xsl >desc2014.n3
```


# Content of the directory

```
bin/    - executables needed for generation of nt files
data/   - original MeSH data: XML and DTD files
doc/    - documentation
nt/     - generated .nt files
sql/    - SPARQL query for generation of the hierarchy
xslt/   - XSLT scripts for transformation of the XML files into RDF
README
```


# Generation of NT files

Generated using XSLTProc encapsulated in a Java class. From xslt/ (contains dtd files):

```
java -jar ../bin/XSLTProc.jar ../data/qual2014.xml transformMeSHQualifierRecords.xsl > ../nt/qual2014.nt &
java -jar ../bin/XSLTProc.jar ../data/desc2014.xml transformMeSHDescriptors.xsl > ../nt/desc2014.nt &
java -jar ../bin/XSLTProc.jar ../data/supp2014.xml supplConceptRecord.xsl > ../nt/supp2014.nt &
```


# Generation of the hierarchy

In an RDF database, script creatMeSHHierarchy.sql create a relation
child mesh:upperDescriptor parent based on tree numbers


# Technical comments

XSLT script history
-------------------

- supplConceptRecord.xsl was modified on 2013-01-11
  * to correct the representation of Terms in Supplementary concept records (adding a blank node for termData)
  * to handle asterisked DescriptorUIs (added a isDescriptorStarred annotation, and removed the asterisk from the identifier)
  * removed redundancy for type, identifier and label of descriptor mapped via the isMappedToDescriptor relations (type, identifier and label are already present in the descriptors)

MeSH NT files generation
------------------------

***2014-03-27, By Rainer***

Changed the procedure for creating descriptor hierarchy sql/createMeSHHierarchy.sql:

- in mesh2014 graph added "?child skos:broader ?parent" triples for direct child/parent relations
 - replacing mesh:upperDescriptor with skos:broader
 - replacing regular expression in insert script with substring filter (performace increase)
sql/createMeSHTC.sql:
- in mesh_tc_2014 added tc for ALL descriptors based on skos:broader relations for direct child/parent relations

***2013-11-25, By Rainer***

- Applied xslt on MeSH 2014 files
- Downloaded MeSH 2014 files


***2013-01-11, By Bastien***

- Modified xslt for the transformation of supplementary concepts
- Applied modified xslt on MeSH 2013 files

***2012-10-17, By Bastien***

- Applied historical xslt on MeSH 2013 files
- Downloaded MeSH 2013 files

