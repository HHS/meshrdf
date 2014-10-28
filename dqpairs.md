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

The following <span class='invoke-sparql'>SPARQL query</span> will produce the the data
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

Here is the truncated output of the above query in [N3 format](http://iddev.nlm.nih.gov/mesh/servlet/query?query=PREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0A%0D%0Aconstruct%20%7B%0D%0A%20%20%20%20%3Fdqpair%20meshv%3AhasDescriptor%20mesh%3AD015242%20.%0D%0A%20%20%20%20%3Fdqpair%20meshv%3AhasQualifier%20mesh%3AQ000008%20.%0D%0A%20%20%20%20mesh%3AD015242%20meshv%3AallowableQualifier%20mesh%3AQ000008%20.%0D%0A%20%20%20%20%3Fdqpair%20rdf%3Atype%20%3Fdqclass%20.%0D%0A%20%20%20%20%3Fdqclass%20rdfs%3AsubClassOf%20%3Fsuperclass%20.%0D%0A%7D%0D%0Afrom%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh2014%3E%0D%0Awhere%20%7B%0D%0A%20%20%20%20%3Fdqpair%20meshv%3AhasDescriptor%20mesh%3AD015242%20.%0D%0A%20%20%20%20%3Fdqpair%20meshv%3AhasQualifier%20mesh%3AQ000008%20.%0D%0A%20%20%20%20mesh%3AD015242%20meshv%3AallowableQualifier%20mesh%3AQ000008%20.%0D%0A%20%20%20%20%3Fdqpair%20rdf%3Atype%20%3Fdqclass%20.%0D%0A%20%20%20%20%3Fdqclass%20rdfs%3AsubClassOf%20%3Fsuperclass%20.%0D%0A%7D&format=N3){:target="_blank"}. The same data is illustrated in the RDF graph diagram above.

```
<http://id.nlm.nih.gov/mesh/D015242>
        <http://id.nlm.nih.gov/mesh/vocab#allowableQualifier>
                <http://id.nlm.nih.gov/mesh/Q000008> .

<http://id.nlm.nih.gov/mesh/D015242Q000008>
        a       <http://id.nlm.nih.gov/mesh/vocab#AllowedDescriptorQualifierPair> ;
        <http://id.nlm.nih.gov/mesh/vocab#hasDescriptor>
                <http://id.nlm.nih.gov/mesh/D015242> ;
        <http://id.nlm.nih.gov/mesh/vocab#hasQualifier>
                <http://id.nlm.nih.gov/mesh/Q000008> .
                
<http://id.nlm.nih.gov/mesh/vocab#AllowedDescriptorQualifierPair>
        <http://www.w3.org/1999/02/22-rdf-syntax-ns#subClassOf>
                <http://id.nlm.nih.gov/mesh/vocab#DescriptorQualifierPair> .
```

### MeSH XML

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the N3 data above to the truncated MeSH XML.

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
