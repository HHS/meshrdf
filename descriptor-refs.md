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
{: class="inline-header"}
The RDF is depicted in the following graph:

![Descriptor References RDF Graph Diagram](images/DescriptorRefs.png){: class="rdf-graph"}



## XML
{: class="inline-header"}

{: class="sample-code"}
```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D009369</DescriptorUI>
  <DescriptorName>
    <String>Neoplasms</String>
  </DescriptorName>
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


In turtle:

{: class="sample-code"}
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

mesh:D015242  meshv:pharmacologicalAction mesh:D059005 ,
                                          mesh:D000900 ,
                                          mesh:D000892 .
```


## Generating the RDF
{: class="inline-header"}
The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

{: class="sample-code"}
```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D009369 meshv:runningHead ?rh .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
from <http://chrismaloney.org/mesh>
where {
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D009369 meshv:runningHead ?rh .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
```

At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?default-graph-uri=&query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0A%0Aconstruct%20%7B%0A%20%20%20%20mesh%3AD009369%20meshv%3AseeAlso%20%3Fsa%20.%0A%20%20%20%20mesh%3AD009369%20meshv%3AconsiderAlso%20%3Fca%20.%0A%20%20%20%20mesh%3AD009369%20meshv%3ArunningHead%20%3Frh%20.%0A%20%20%20%20mesh%3AD015242%20meshv%3ApharmacologicalAction%20%3Fpa%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Awhere%20%7B%0A%20%20%20%20mesh%3AD009369%20meshv%3AseeAlso%20%3Fsa%20.%0A%20%20%20%20mesh%3AD009369%20meshv%3AconsiderAlso%20%3Fca%20.%0A%20%20%20%20mesh%3AD009369%20meshv%3ArunningHead%20%3Frh%20.%0A%20%20%20%20mesh%3AD015242%20meshv%3ApharmacologicalAction%20%3Fpa%20.%0A%7D&format=text%2Frdf%2Bn3&timeout=0&debug=on).