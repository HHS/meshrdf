---
title: Entry Combinations
layout: page
resource: true
categories:
- Data Model
---

The following shows how EntryCombinations (see the [MeSH documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#EntryCombination)) are modeled.

###RDF Graph Diagram

Depicted in this graph:

![Entry Combinations RDF Graph Diagram](images/EntryCombinations.png){: class="rdf-graph"}

###SPARQL

The following [SPARQL
query](http://jatspan.org:8890/sparql?query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0A%0ACONSTRUCT%20%7B%20%0A%20%20%3Fecin%20%3Fp%20%3Fo%20.%0A%20%20%3Fecin%20rdf%3Atype%20%3Feclass%20.%0A%20%20%3Feclass%20rdfs%3AsubClassOf%20%24superclass%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmeshv%3E%0Awhere%20%7B%0A%20%20%3Fecin%20meshv%3AhasDescriptor%20mesh%3AD000005%20.%0A%20%20%3Fecin%20meshv%3AhasQualifier%20%3Fecinq%20.%0A%20%20%3Fecin%20meshv%3AuseInstead%20%3Fecout%20.%0A%20%20%3Fecin%20%3Fp%20%3Fo%20.%0A%20%20%3Fecin%20rdf%3Atype%20%3Feclass%20.%0A%20%20%3Feclass%20rdfs%3AsubClassOf%20%24superclass%20.%0A%7D&format=TURTLE)


```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

CONSTRUCT {
  ?ecin ?p ?o .
  ?ecin rdf:type ?eclass .
  ?eclass rdfs:subClassOf $superclass .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
  ?ecin meshv:hasDescriptor mesh:D000005 .
  ?ecin meshv:hasQualifier ?ecinq .
  ?ecin meshv:useInstead ?ecout .
  ?ecin ?p ?o .
  ?ecin rdf:type ?eclass .
  ?eclass rdfs:subClassOf $superclass .
}
```



### MeSH RDF Data

```
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

mesh:D000005Q000293  rdf:type  meshv:DisallowedDescriptorQualifierPair ;
  meshv:hasDescriptor  mesh:D000005 ;
  meshv:hasQualifier   mesh:Q000293 ;
  meshv:useInstead     mesh:D000007 .
meshv:DisallowedDescriptorQualifierPair rdfs:subClassOf meshv:DescriptorQualifierPair .
```

Notes:

* For *most* entry combinations, the ECOUT is just a stand-alone Descriptor, but occasionally
  it is a DescriptorQualifierPair.  The *object* of the `meshv:useInstead` property would simply be a
  DescriptorQualifierPair instance, rather than, as is depicted in the drawing above, a Descriptor.

* The DQ pair formed by the ECIN of the entry combination is never
  not one of the "allowed" ones.




### MeSH XML
Here is a typical example of and EntryCombination represented in XML.


```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D000005</DescriptorUI>
  <DescriptorName>
    <String>Abdomen</String>
  </DescriptorName>
  ...
  <EntryCombinationList>
    <EntryCombination>
      <ECIN>
        <DescriptorReferredTo>
          <DescriptorUI>D000005</DescriptorUI>
          <DescriptorName>
            <String>Abdomen</String>
          </DescriptorName>
        </DescriptorReferredTo>
        <QualifierReferredTo>
          <QualifierUI>Q000293</QualifierUI>
          <QualifierName>
            <String>injuries</String>
          </QualifierName>
        </QualifierReferredTo>
      </ECIN>
      <ECOUT>
        <DescriptorReferredTo>
          <DescriptorUI>D000007</DescriptorUI>
          <DescriptorName>
            <String>Abdominal Injuries</String>
          </DescriptorName>
        </DescriptorReferredTo>
      </ECOUT>
    </EntryCombination>
  </EntryCombinationList>
  ...
</DescriptorRecord>
```


