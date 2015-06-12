---
title: Super Classes
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below lists MeSH RDF super classes and their subclasses according to the MeSH RDF schema. Use inference when querying these super classes.

{:.data-table-long .row-border .hover}
Child Class | Predicate | Super Class
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


An example where inference is required would be to <span class='invoke-sparql'>query</span> all instances of subclasses of meshv:Descriptor (meshv:TopicalDescriptor, meshv:GeographicDescriptor, etc).

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT DISTINCT ?d ?label
FROM <http://id.nlm.nih.gov/mesh2014>

WHERE {
?d a meshv:Descriptor .
?d rdfs:label ?label .
}

ORDER BY ?label
```
