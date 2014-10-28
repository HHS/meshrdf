---
title: Descriptor-Qualifier Pairs
layout: page
resource: true
categories:
- Data Model
---

When indexing or cataloging resources using MeSH, NLM pairs Descriptors (main headings) and Qualifiers (sub-headings). Qualifiers comprise a set of 83 terms used to add more specificity to descriptors. Each Descriptor has a set of Allowable Qualifiers. In RDF, Descriptors and Qualifiers may be treated as separate classes, but we have also chosen to create a class of Descriptor-Qualifier pairs, each with its own URI. For example, the pairing of a Descriptor (D015242, Ofloxacin) and one of its Allowable Qualifiers (Q000008, administration &amp; dosage) has the following URI:

http://id.nlm.nih.gov/mesh/D015242Q000008

### RDF Graph Diagram

The following RDF graph diagram shows how descriptor-qualifier pairs are modeled. Note that the pairing (D015242Q000008, Ofloxacin/administration &amp; dosage) is an instance of the class, meshv:AllowedDescriptorQualifierPair. Relationships between the descriptor-qualifier pair and its respective descriptor and qualifier are explicitly defined.

![Descriptor Qualifier Pair RDF Graph Diagram](images/DQPair.png){: class="rdf-graph"}

### SPARQL

The following <span class='invoke-sparql'>SPARQL query</span>{:target="_blank"} will produce the the data
shown in the RDF graph diagram above.


```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    ?dqpair meshv:hasDescriptor mesh:D015242 .
    ?dqpair meshv:hasQualifier mesh:Q000008 .
    mesh:D015242 meshv:allowableQualifier mesh:Q000008 .
    ?dqpair rdf:type ?dqclass .
    ?dqclass rdfs:subClassOf ?superclass .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
    ?dqpair meshv:hasDescriptor mesh:D015242 .
    ?dqpair meshv:hasQualifier mesh:Q000008 .
    mesh:D015242 meshv:allowableQualifier mesh:Q000008 .
    ?dqpair rdf:type ?dqclass .
    ?dqclass rdfs:subClassOf ?superclass .
}
```

### MeSH RDF Data

```
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

mesh:D015242  meshv:allowableQualifier  mesh:Q000008 .
mesh:D015242Q000008  rdf:type  meshv:AllowedDescriptorQualifierPair ;
    meshv:hasDescriptor  mesh:D015242 ;
    meshv:hasQualifier   mesh:Q000008 .
meshv:AllowedDescriptorQualifierPair  rdfs:subClassOf  meshv:DescriptorQualifierPair .
```
The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the turtle data above to the truncated MeSH XML.

### MeSH XML

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D015242</DescriptorUI>
  <DescriptorName>
    <String>Ofloxacin</String>
  </DescriptorName>
  ...
  <AllowableQualifiersList>
    <AllowableQualifier>
      <QualifierReferredTo>
        <QualifierUI>Q000008</QualifierUI>
        <QualifierName>
          <String>administration &amp; dosage</String>
        </QualifierName>
      </QualifierReferredTo>
      <Abbreviation>AD</Abbreviation>
    </AllowableQualifier>
    ...
  </AllowableQualifiersList>
   ...
</DescriptorRecord>
```
