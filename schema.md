---
title: Schema
layout: page
resource: true
categories:
- Data Model
---

The current MeSH RDF schema is expressed in OWL format on our [FTP site](ftp://ftp.nlm.nih.gov/online/mesh/vocabulary.owl). The schema expresses the following things about MeSH RDF:

* MeSH RDF class names
* MeSH RDF property names used for predicates
* Subclass relationships between classes
* Disjoint relationships between classes
* Subproperty relationships between properties
* Disjoint relationships between properties
* Inverse relationships between properties
* Which properties are transitive properties
* Definitions of classes and properties

A schema graph is queryable via our SPARQL endpoint. The graph name is <http://id.nlm.nih.gov/mesh/schema> See the above links to query the schema graph. 

There is also a <http://id.nlm.nih.gov/mesh/void> graph with metadata about MeSH RDF. 
