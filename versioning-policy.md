---
title: Versioning Policy
layout: page
resource: true
categories:
- Policy
---

MeSH is versioned on a yearly basis. NLM releases provisional MeSH data for the following year each September, and changes to MeSH are implemented in PubMed the following December. NLM released 2015 MeSH data in XML format in September 2014. Most changes made in September of each year involve the addition of new Descriptors and changes to existing Descriptors. Supplementary Concept Records are also added throughout the year, and those changes are reflected in daily updates to MeSH XML. Starting June 15, 2015, MeSH RDF data will update on a daily basis in sync with MeSH XML. Supplementary Concept Records are added throughout the year on a daily basis.  

MeSH RDF will use the following conventions for URIs, graphs and filenames:

### URIs

#### Data URIs

MeSH RDF will follow established versioning practices, but MeSH RDF will be expressed in non-versioned and versioned URIs. For example, the Descriptor for Ofloxacin will have the following URIs:

* http://id.nlm.nih.gov/mesh/D015242 (current)
* http://id.nlm.nih.gov/mesh/2015/D015242 (2015)

The non-versioned URI reflects the current state of MeSH at any given time. The versioned URI for the current year will mirror the non-versioned URI until NLM releases the next year's MeSH data. Once NLM begins using the next year's MeSH data, the next year's versioned URI will mirror the non-versioned URI, and the current year's data will become static and archived. Current year MeSH is dynamic until archived. NLM will retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015 MeSH. 

#### Vocabulary URIs

MeSH RDF vocabulary URIs will be versionless, though they will be derived from versioned schema files (see below). All predicate and class URIs will have the following prefix, regardless of MeSH year or schema version: 

http://id.nlm.nih.gov/mesh/vocab#

Predicate names are expressed in camel case. Class names have initial letters capitalized.

* Predicate example: http://id.nlm.nih.gov/mesh/vocab#pharmacologicalAction
* Class example: http://id.nlm.nih.gov/mesh/vocab#TopicalDescriptor

#### Deprecated URIs

Currently, we do not have a mechanism for handling deprecated URIs. On occasion, Supplementary Concept Records may be removed from MeSH data. When that happens, that Supplementary Concept Record's triples will disappear from the graph, and the data will no longer be available for that URI. Requests for deprecated URIs will still return an HTTP 200 status code, but no data will be available. We intend to address this in a future release. Additionally, some non-existing URIs will return HTTP 200 status codes. Any URI that fits a pattern expressed in our [URL rewrite document](https://github.com/HHS/lodestar/blob/meshrdf/web-ui/src/main/webapp/WEB-INF/urlrewrite.xml) will return an HTTP 200 status code, whether it is a valid URI or not. Keep this in mind when making requests based on URI patterns. 

### Graphs

#### Data Graphs

MeSH RDF data are expressed in a current, versionless graph and a versioned graph:

* http://id.nlm.nih.gov/mesh (current)
* http://id.nlm.nih.gov/mesh/2015 (2015)

Use these graphs to run SPARQL queries on MeSH RDF data. NLM will retain no more than three years of versioned graphs, and NLM will not produced versioned graphs for data prior to 2015 MeSH. 

#### Vocabulary Graph

MeSH RDF's vocabulary is expressed in a versionless graph:

* http://id.nlm.nih.gov/mesh/vocab 

This graph expresses the MeSH vocabulary schema, which describes and relates the various predicates and classes in MeSH RDF. 

* Types of classes and properties (expressed by rdf:type)
* Class and property labels (rdfs:label)
* Subproperty and subclass relationships (rdfs:subClassOf)
* Disjoint relationships between classes or properties (owl:disjointWith, owl:propertyDisjointWith)
* Descriptions of classes and properties (dct:description)

#### VoID Graph

The VoID graph is versionless and contains metadata about MeSH RDF:

* http://id.nlm.nih.gov/mesh/void

### FTP Download Files

NLM makes available MeSH RDF files for download:

* ftp://ftp.nlm.nih.gov/online/mesh/

#### Data Files

Current MeSH RDF data are available for download in .nt (N-Triples format). 

* Filename: mesh.nt 
* Location: ftp://ftp.nlm.nih.gov/online/mesh/

Versioned MeSH data are available in subdirectories labeled by year. MeSH XML and DTDs are also available without restriction. Note that MeSH RDF data are expressed in a single file (for example, mesh2015.nt), while the XML data are grouped into files for Descriptors, Qualifiers and Supplementary Concept Records.

* 2015 MeSH RDF Filename: mesh2015.nt 
* 2015 XML Data Filenames: desc2015.xml, qual2015.xml, supp2015.xml
* 2015 XML DTD Filenames: desc2015.dtd, qual2015.dtd, supp2015.dtd
* 2015 Data Location: ftp://ftp.nlm.nih.gov/online/mesh/2015/

#### Vocabulary Files

The MeSH vocabulary schema is expressed in a .ttl (TURTLE) file on the FTP site. This file has a version number that will increment upon changes to the vocabulary schema. 

* Filename: vocabulary_0.9.ttl 
* Location: ftp://ftp.nlm.nih.gov/online/mesh/
