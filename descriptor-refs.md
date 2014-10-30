---
title: Descriptor References
layout: page
resource: true
categories:
- Data Model
---

This page documents a couple of the ways that Descriptors reference other Descriptors, and how those references are
translated into RDF.

### RDF Graph Diagram

The RDF is depicted in the following graph:

![Descriptor References RDF Graph Diagram](images/DescriptorRefs.png){: class="rdf-graph"}

###SPARQL

The RDF output above can be generated with the following <span class='invoke-sparql'>SPARQL query</span>, after substituting the current values for the name of the graph and so forth:


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

In [N3 format](http://iddev.nlm.nih.gov/mesh/servlet/query?query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0A%0D%0Aconstruct%20%7B%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3Aannotation%20%3Fa%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3AseeAlso%20%3Fsa%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3AconsiderAlso%20%3Fca%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3ArunningHead%20%3Frh%20.%0D%0A%20%20%20%20mesh%3AD015242%20meshv%3ApharmacologicalAction%20%3Fpa%20.%0D%0A%7D%0D%0Afrom%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh2014%3E%0D%0Awhere%20%7B%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3Aannotation%20%3Fa%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3AseeAlso%20%3Fsa%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3AconsiderAlso%20%3Fca%20.%0D%0A%20%20%20%20mesh%3AD009369%20meshv%3ArunningHead%20%3Frh%20.%0D%0A%20%20%20%20mesh%3AD015242%20meshv%3ApharmacologicalAction%20%3Fpa%20.%0D%0A%7D&format=N3){:target="_blank"}:

```
<http://id.nlm.nih.gov/mesh/D015242>
        <http://id.nlm.nih.gov/mesh/vocab#pharmacologicalAction>
                <http://id.nlm.nih.gov/mesh/D000892> , 
                ...
                <http://id.nlm.nih.gov/mesh/D059005> .

<http://id.nlm.nih.gov/mesh/D009369>
        <http://id.nlm.nih.gov/mesh/vocab#annotation>
                "general; prefer specifics; policy: Manual section 24; qualifier / nurs = the patient, ONCOLOGY NURSING = ...";
        <http://id.nlm.nih.gov/mesh/vocab#considerAlso>
                "consider also terms at CANCER, CARCINO-, ONCO-, and TUMOR" ;
        <http://id.nlm.nih.gov/mesh/vocab#runningHead>
                "C4 - DISEASES-NEOPLASMS" ;
        <http://id.nlm.nih.gov/mesh/vocab#seeAlso>
                ...
                <http://id.nlm.nih.gov/mesh/D016147> ,
                ...
                <http://id.nlm.nih.gov/mesh/D002273> .
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
