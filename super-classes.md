---
title: Super Classes
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below lists MeSH RDF super classes and their subclasses (via the rdfs:subClassOf predicate).  Inference is required when querying these superclasses.

{:.data-table-standard .row-border .hover}
Super Class | Predicate | Child Class
------- | --------- | -------
meshv:AllowedDescriptorQualifierPair | rdfs:subClassOf | meshv:DescriptorQualifierPair
meshv:DisallowedDescriptorQualifierPair | rdfs:subClassOf | meshv:DescriptorQualifierPair
meshv:GeographicalDescriptor | rdfs:subClassOf | meshv:Descriptor
meshv:TopicalDescriptor | rdfs:subClassOf | meshv:Descriptor
meshv:PublicationType | rdfs:subClassOf | meshv:Descriptor
meshv:CheckTag | rdfs:subClassOf | meshv:Descriptor
meshv:SCR_Chemical | rdfs:subClassOf | meshv:SupplementaryConceptRecord
meshv:SCR_Disease | rdfs:subClassOf | meshv:SupplementaryConceptRecord
meshv:SCR_Protocol | rdfs:subClassOf | meshv:SupplementaryConceptRecord


An example where inference is required would be to query all meshv:Descriptor classes (Topical, Geographic, etc) that were created for 2014 MeSH.

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT DISTINCT ?d ?name
FROM <http://id.nlm.nih.gov/mesh2014>

WHERE {

?d a meshv:Descriptor .
?d rdfs:label ?name .
?d meshv:dateEstablished ?dateEstablished
FILTER(?dateEstablished = xsd::date("2014-01-01"))

}

ORDER BY ?name
```