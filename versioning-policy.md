---
title: Versioning Policy
layout: page
resource: true
categories:
- Policy
---

MeSH is versioned on a yearly basis. NLM releases provisional MeSH data for the following year each September. Changes to MeSH are implemented in PubMed the following December. Most changes made in September of each year involve the addition of new Descriptors and changes to existing Descriptors. Supplementary Concept Records are added throughout the year, and those changes are reflected in daily updates to MeSH. MeSH is updated annually, and users are encouraged to obtain the new year's data. 

MeSH RDF will use the following conventions for URIs, graphs and filenames:

### URIs

#### Data URIs

MeSH RDF will follow established MeSH versioning practices, but MeSH RDF will be expressed in non-versioned and versioned URIs. Unless there is a specific use case for using the versioned data, NLM recommends using the current, non-versioned URIs and graph. For example, the Descriptor for Ofloxacin will have the following URIs:

* http://id.nlm.nih.gov/mesh/D015242 (current, non-versioned)
* http://id.nlm.nih.gov/mesh/2016/D015242 (2016, versioned)
* http://id.nlm.nih.gov/mesh/2015/D015242 (2015, versioned)

The non-versioned URI reflects the current state of MeSH at any given time. Requesting data from versioned URIs will return the most recent snapshot of the data from that year. For the current year, versioned data will mirror non-versioned data until NLM archives the versioned data in November. At that point, the versioned data will become static. NLM plans to retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015 MeSH. 

#### Vocabulary URIs

MeSH RDF vocabulary URIs will be versionless, though they will be derived from versioned schema files (see below). All predicate and class URIs will have the following prefix, regardless of MeSH year or schema version: 

http://id.nlm.nih.gov/mesh/vocab#

Predicate names are expressed in camel case. Class names have initial letters capitalized.

* Predicate example: http://id.nlm.nih.gov/mesh/vocab#pharmacologicalAction
* Class example: http://id.nlm.nih.gov/mesh/vocab#TopicalDescriptor

#### Deprecated URIs

NLM occasionally deletes or revises MeSH content. NLM uses the Boolean-typed meshv:active predicate to indicate whether content is active or not. A "1" value indicates that content is active. A "0" value indicates that content is obsolete. For obsolete content, the word "OBSOLETE" will be prepended to the rdfs:label, but the URI will remain active in most cases. The predicate meshv:lastActiveYear will indicate the most recent year in which the content was active. 

Requests for deprecated URIs will still return an HTTP 200 status code, but no data will be available. We intend to address this in a future release. Additionally, some non-existing URIs will return HTTP 200 status codes, even if they are not valid URIs. Keep this in mind when making requests based on URI patterns. 

### Graphs

#### Data Graphs

MeSH RDF data are expressed in a current, versionless graph and versioned graphs:

* http://id.nlm.nih.gov/mesh (current)
* http://id.nlm.nih.gov/mesh/2016 (2016)
* http://id.nlm.nih.gov/mesh/2015 (2015)

Use these graphs to run SPARQL queries on MeSH RDF data. NLM plans to retain no more than three years of versioned graphs, and NLM will not produce versioned graphs for data prior to 2015 MeSH. 

#### Vocabulary Graph

The MeSH RDF vocabulary is expressed in a versionless graph:

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

Versioned MeSH data are available in subdirectories labeled by year. MeSH XML and DTDs are also available without restriction. Note that MeSH RDF data are expressed in a single file (for example, mesh2016.nt), while the XML data are grouped into files for Descriptors, Qualifiers and Supplementary Concept Records. For example:

* 2016 MeSH RDF Filename: mesh2016.nt 
* 2016 XML Data Filenames: desc2016.xml, qual2016.xml, supp2016.xml
* 2016 XML DTD Filenames: 
   * [nlmdescriptorrecordset_20160101.dtd](https://www.nlm.nih.gov/databases/dtd/nlmdescriptorrecordset_20160101.dtd)
   * [nlmqualifierrecordset_20160101.dtd](https://www.nlm.nih.gov/databases/dtd/nlmqualifierrecordset_20160101.dtd)
   * [nlmsupplementalrecordset_20160101.dtd](https://www.nlm.nih.gov/databases/dtd/nlmsupplementalrecordset_20160101.dtd)
* 2016 Data Location: ftp://ftp.nlm.nih.gov/online/mesh/2016/

#### Vocabulary Files

The MeSH vocabulary schema is expressed in a .ttl (TURTLE) file on the FTP site. This file has a version number that will increment upon changes to the vocabulary schema. 

* Filename: vocabulary_X.X.ttl 
* Location: ftp://ftp.nlm.nih.gov/online/mesh/
