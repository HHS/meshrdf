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

The RDF output above can be generated with the following <span class='invoke-sparql'>SPARQL query</span>{:target="_blank"}, after substituting the current values for the name of the graph and so forth:


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
