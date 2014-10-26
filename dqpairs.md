---
title: Descriptor Qualifier Pairs
layout: page
resource: true
categories:
- Data Model
---

This example shows the graph derived from one descriptor (D015242, Ofloxacin) and one of it's allowable qualifiers (Q000008, administration &amp; dosage).

## RDF

The RDF is depicted in the following graph:

![Descriptor Qualifier Pair RDF Graph Diagram](images/DQPair.png){: class="rdf-graph"}


## XML

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



In turtle format:

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


## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

construct {
    ?dqpair meshv:hasDescriptor mesh:D015242 .
    ?dqpair meshv:hasQualifier mesh:Q000008 .
    mesh:D015242 meshv:allowableQualifier mesh:Q000008 .
    ?dqpair rdf:type ?dqclass .
    ?dqclass rdfs:subClassOf ?superclass .
}
from <http://chrismaloney.org/mesh>
from <http://chrismaloney.org/meshv>
where {
    ?dqpair meshv:hasDescriptor mesh:D015242 .
    ?dqpair meshv:hasQualifier mesh:Q000008 .
    mesh:D015242 meshv:allowableQualifier mesh:Q000008 .
    ?dqpair rdf:type ?dqclass .
    ?dqclass rdfs:subClassOf ?superclass .
}
```

At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0A%0Aconstruct%20%7B%0A%20%20%20%20%3Fdqpair%20meshv%3AhasDescriptor%20mesh%3AD015242%20.%0A%20%20%20%20%3Fdqpair%20meshv%3AhasQualifier%20mesh%3AQ000008%20.%0A%20%20%20%20mesh%3AD015242%20meshv%3AallowableQualifier%20mesh%3AQ000008%20.%0A%20%20%20%20%3Fdqpair%20rdf%3Atype%20%3Fdqclass%20.%0A%20%20%20%20%3Fdqclass%20rdfs%3AsubClassOf%20%3Fsuperclass%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmeshv%3E%0Awhere%20%7B%0A%20%20%20%20%3Fdqpair%20meshv%3AhasDescriptor%20mesh%3AD015242%20.%0A%20%20%20%20%3Fdqpair%20meshv%3AhasQualifier%20mesh%3AQ000008%20.%0A%20%20%20%20mesh%3AD015242%20meshv%3AallowableQualifier%20mesh%3AQ000008%20.%0A%20%20%20%20%3Fdqpair%20rdf%3Atype%20%3Fdqclass%20.%0A%20%20%20%20%3Fdqclass%20rdfs%3AsubClassOf%20%3Fsuperclass%20.%0A%7D%0A&format=TURTLE)