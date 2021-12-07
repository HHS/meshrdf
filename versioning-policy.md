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
* http://id.nlm.nih.gov/mesh/2022/D015242 (2022, versioned)
* http://id.nlm.nih.gov/mesh/2021/D015242 (2021, versioned)
* http://id.nlm.nih.gov/mesh/2020/D015242 (2020, versioned)

The non-versioned URI reflects the current state of MeSH at any given time. Requesting data from versioned URIs will return the most recent snapshot of the data from that year. For the current year, versioned data will mirror non-versioned data until NLM archives the versioned data in November. At that point, the versioned data will become static. NLM plans to retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015 MeSH. 

#### Vocabulary URIs

MeSH RDF vocabulary URIs are versionless. All predicate and class URIs will have the following prefix, regardless of MeSH year or schema version: 

http://id.nlm.nih.gov/mesh/vocab#

Predicate names are expressed in camel case. Class names have initial letters capitalized.

* Predicate example: http://id.nlm.nih.gov/mesh/vocab#pharmacologicalAction
* Class example: http://id.nlm.nih.gov/mesh/vocab#TopicalDescriptor

#### Deprecated URIs

NLM occasionally deletes or revises MeSH content. NLM uses the Boolean-typed meshv:active predicate to indicate whether content is active or not. A "1" value indicates that content is active. A "0" value indicates that content is obsolete. For obsolete content, the string "[OBSOLETE]" will be prepended to the rdfs:label, but the URI will remain active in most cases. The predicate meshv:lastActiveYear will indicate the most recent year in which the content was active. 

Requests for deprecated URIs will still return an HTTP 200 status code, but no data will be available. Additionally, some non-existing URIs will return HTTP 200 status codes, even if they are not valid URIs. Keep this in mind when making requests based on URI patterns. 

### Graphs

#### Data Graphs

MeSH RDF data is represented in a current, versionless graph and versioned graphs:

* http://id.nlm.nih.gov/mesh (current)
* http://id.nlm.nih.gov/mesh/2022 (2022)
* http://id.nlm.nih.gov/mesh/2021 (2021)
* http://id.nlm.nih.gov/mesh/2020 (2020)

Use these graphs to run SPARQL queries on MeSH RDF data. NLM plans to retain no more than three years of versioned graphs, and NLM will not produce versioned graphs for data prior to 2015 MeSH. 

### FTP Download Files

NLM makes available MeSH RDF files for download:

* https://nlmpubs.nlm.nih.gov/projects/mesh/rdf/

#### Data Files

Current MeSH RDF data is available for download in .nt (N-Triples format). 

* Filename: mesh.nt 
* Location: https://nlmpubs.nlm.nih.gov/projects/mesh/rdf/

#### Schema File

The MeSH vocabulary schema is expressed in a .ttl (TURTLE) file on the FTP site. 

* Filename: vocabulary_X.X.X.ttl 
* Location: https://nlmpubs.nlm.nih.gov/projects/mesh/rdf/
