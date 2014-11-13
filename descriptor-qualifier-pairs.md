---
title: Descriptor-Qualifier Pairs
layout: page
resource: true
categories:
- Data Model
---

When indexing or cataloging resources using MeSH, NLM pairs Descriptors (main headings) and Qualifiers (sub-headings). Qualifiers comprise a set of 83 terms used to add more specificity to descriptors. Each Descriptor has a set of Allowable Qualifiers. In RDF, Descriptors and Qualifiers may be treated as separate classes, but we have also chosen to create a class of Descriptor-Qualifier pairs, each with its own URI. For example, the pairing of a Descriptor (D015242, Ofloxacin) and one of its Allowable Qualifiers (Q000008, administration &amp; dosage) has the following URI:
[http://id.nlm.nih.gov/mesh/D015242Q000008](http://id.nlm.nih.gov/mesh/D015242Q000008){: target="_blank"}

{: .jump}
&#91; jump to [entry combinations](#entry-combinations) &#93;

### Class Information

In MeSH RDF, the subclasses of meshv:DescriptorQualifierPairs are:

*  meshv:AllowedDescriptorQualifierPair
*  meshv:DisallowedDescriptorQualifierPair

### RDF Graph Diagram

The following RDF graph diagram shows how descriptor-qualifier pairs are modeled. Note that the pairing (D015242Q000008, Ofloxacin/administration &amp; dosage) is an instance of the class, meshv:AllowedDescriptorQualifierPair. Relationships between the descriptor-qualifier pair and its respective descriptor and qualifier are explicitly defined.

![Descriptor Qualifier Pair RDF Graph Diagram](images/DQPair.png){: class="rdf-graph"}


### meshv:DescriptorQualifierPairs - Relations and Properties
This table includes all the sub-classes of the meshv:DescriptorQualifierPairs class as either the subject or object of an RDF triple.

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)

{: #tabs-1}
<div>

{:.data-table-standard .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:GeographicalDescriptor
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:AllowedDescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:GeographicalDescriptor
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:DescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:AllowedDescriptorQualifierPair
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:Descriptor
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:DescriptorQualifierPair
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:TopicalDescriptor
meshv:DisallowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:DisallowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:DisallowedDescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:AllowedDescriptorQualifierPair
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:Descriptor
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:DescriptorQualifierPair
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:TopicalDescriptor

</div>

{: #tabs-2}
<div>

{:.data-table-standard .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:AllowedDescriptorQualifierPair
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:DescriptorQualifierPair
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:AllowedDescriptorQualifierPair
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:DescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:DescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:DisallowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Disease | meshv:mappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Disease | meshv:mappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:DisallowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:DescriptorQualifierPair

</div>
</div>

### SPARQL

The following <span class='invoke-sparql'>SPARQL query</span> will produce the the data shown in the RDF graph diagram above.


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

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

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
The following shows how EntryCombinations (see the [MeSH documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#EntryCombination)) are modeled.

###<a name = "entry-combinations"/>RDF Graph Diagram

Depicted in this graph:

![Entry Combinations RDF Graph Diagram](images/EntryCombinations.png){: class="rdf-graph"}

###SPARQL

The following <span class='invoke-sparql'>SPARQL query</span> produces the RDF corresponding
to the above graph:

```sparql
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
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
Here is the truncated output of the above query in N3 format. The same data is illustrated in the RDF graph diagram above.

```
<http://id.nlm.nih.gov/mesh/D000005Q000293>
        a       <http://id.nlm.nih.gov/mesh/vocab#DisallowedDescriptorQualifierPair> ;
        <http://id.nlm.nih.gov/mesh/vocab#hasDescriptor>
                <http://id.nlm.nih.gov/mesh/D000005> ;
        <http://id.nlm.nih.gov/mesh/vocab#hasQualifier>
                <http://id.nlm.nih.gov/mesh/Q000293> ;
        <http://id.nlm.nih.gov/mesh/vocab#useInstead>
                <http://id.nlm.nih.gov/mesh/D000007> .

<http://id.nlm.nih.gov/mesh/vocab#DisallowedDescriptorQualifierPair>
        <http://www.w3.org/2000/01/rdf-schema#subClassOf>
                <http://id.nlm.nih.gov/mesh/vocab#DescriptorQualifierPair> .
```

Notes:

* For *most* entry combinations, the ECOUT is just a stand-alone Descriptor, but occasionally
  it is a DescriptorQualifierPair.  The *object* of the `meshv:useInstead` property would simply be a
  DescriptorQualifierPair instance, rather than, as is depicted in the drawing above, a Descriptor.

* The DQ pair formed by the ECIN of the entry combination is never
  not one of the "allowed" ones.


### MeSH XML

The MeSH RDF was derived from non-RDF MeSH XML. Here is a typical example of an EntryCombination represented in MeSH XML.

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