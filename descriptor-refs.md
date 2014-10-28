---
title: Descriptor References
layout: page
resource: true
categories:
- Data Model
---

This page documents a couple of the ways that Descriptors reference other items, and how those references are
translated into RDF.

### RDF Graph Diagram

The RDF is depicted in the following graph:

![Descriptor References RDF Graph Diagram](images/DescriptorRefs.png){: class="rdf-graph"}

###SPARQL

The RDF output above can be generated with [the following SPARQL
query](http://iddev.nlm.nih.gov/mesh/sparql?query=PREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0A%0D%0Aconstruct+%7B%0D%0A++++mesh%3AD009369+meshv%3AseeAlso+%3Fsa+.%0D%0A++++mesh%3AD009369+meshv%3AconsiderAlso+%3Fca+.%0D%0A++++mesh%3AD009369+meshv%3ArunningHead+%3Frh+.%0D%0A++++mesh%3AD015242+meshv%3ApharmacologicalAction+%3Fpa+.%0D%0A%7D%0D%0Afrom+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh2014%3E%0D%0Awhere+%7B%0D%0A++++mesh%3AD009369+meshv%3AseeAlso+%3Fsa+.%0D%0A++++mesh%3AD009369+meshv%3AconsiderAlso+%3Fca+.%0D%0A++++mesh%3AD009369+meshv%3ArunningHead+%3Frh+.%0D%0A++++mesh%3AD015242+meshv%3ApharmacologicalAction+%3Fpa+.%0D%0A%7D%0D%0A&format=text%2Frdf%2Bn3&timeout=0&debug=on), after substituting the current values for the name of the graph and so forth:


```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D009369 meshv:annotation ?a .
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D009369 meshv:runningHead ?rh .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:D009369 meshv:annotation ?a .
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D009369 meshv:runningHead ?rh .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
```

###MeSH RDF Data

In turtle format:

```
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .

mesh:D009369  meshv:seeAlso mesh:D011230 ,
                            mesh:D000912 ,
                            mesh:D000951 ,
                            mesh:D016588 ,
                            mesh:D004273 ,
                            mesh:D012334 ,
                            mesh:D000970 ,
                            mesh:D016066 ,
                            mesh:D002273 ,
                            mesh:D016147 ,
                            mesh:D009858 ;
              meshv:runningHead  "C4 - DISEASES-NEOPLASMS\n  " ;
              meshv:considerAlso  "consider also terms at CANCER, CARCINO-, ONCO-, and TUMOR\n  " .
              meshv:annotation  "general; prefer ... METASTASIS" ;

mesh:D015242  meshv:pharmacologicalAction mesh:D059005 ,
                                          mesh:D000900 ,
                                          mesh:D000892 .
```


### MeSH XML

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D009369</DescriptorUI>
  <DescriptorName>
    <String>Neoplasms</String>
  </DescriptorName>
  <Annotation>general; prefer specifics; policy: ... NEOPLASM METASTASIS</Annotation>
  <SeeRelatedList>
    <SeeRelatedDescriptor>
      <DescriptorReferredTo>
        <DescriptorUI>D000912</DescriptorUI>
        <DescriptorName>
          <String>Antibodies, Neoplasm</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </SeeRelatedDescriptor>
    ...
    <SeeRelatedDescriptor>
      <DescriptorReferredTo>
        <DescriptorUI>D016588</DescriptorUI>
        <DescriptorName>
          <String>Anticarcinogenic Agents</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </SeeRelatedDescriptor>
  </SeeRelatedList>
  <ConsiderAlso>consider also terms at CANCER, CARCINO-, ONCO-, and TUMOR </ConsiderAlso>
  <RunningHead>C4 - DISEASES-NEOPLASMS </RunningHead>
  ...
</DescriptorRecord>

<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D015242</DescriptorUI>
  <DescriptorName>
    <String>Ofloxacin</String>
  </DescriptorName>
  <PharmacologicalActionList>
    <PharmacologicalAction>
      <DescriptorReferredTo>
        <DescriptorUI>D000892</DescriptorUI>
        <DescriptorName>
          <String>Anti-Infective Agents, Urinary</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </PharmacologicalAction>
    ...
    <PharmacologicalAction>
      <DescriptorReferredTo>
        <DescriptorUI>D059005</DescriptorUI>
        <DescriptorName>
          <String>Topoisomerase II Inhibitors</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </PharmacologicalAction>
  </PharmacologicalActionList>
</DescriptorRecord>
```
