---
title: Supplementary Concept Records
layout: page
resource: true
archived: true
mesh-year: 2015
categories:
- Data Model
---

Supplementary Concept Records are created in MeSH to account for the large volume of chemical names that are found in biomedical literature. In MeSH RDF, these are represented by the super class meshv:SupplementaryConceptRecord, which has three sub-classes:

*  meshv:SCR_Chemical
*  meshv:SCR_Disease
*  meshv:SCR_Protocol



### RDF Graph Diagram

![Qualifier RDF Graph Diagram](images/SCRs.png){: class="rdf-graph img-responsive"}

### meshv:SupplementaryConceptRecord - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:SupplementaryConceptRecord properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-long .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:SCR_Chemical | meshv:concept | meshv:Concept
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:DescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:DisallowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Chemical | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SCR_Chemical | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:preferredConcept | meshv:Concept
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:preferredTerm | meshv:Term
meshv:SCR_Disease | meshv:concept | meshv:Concept
meshv:SCR_Disease | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Disease | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:mappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Disease | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Disease | meshv:mappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Disease | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:preferredConcept | meshv:Concept
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:preferredTerm | meshv:Term
meshv:SCR_Protocol | meshv:concept | meshv:Concept
meshv:SCR_Protocol | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Protocol | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Protocol | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SCR_Protocol | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:preferredConcept | meshv:Concept
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:preferredTerm | meshv:Term
meshv:SupplementaryConceptRecord | meshv:concept | meshv:Concept
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:DisallowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:preferredConcept | meshv:Concept
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:AllowedDescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:DescriptorQualifierPair
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:preferredTerm | meshv:Term

</div>

{: #tabs-2}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
N/A | N/A | N/A

</div>

{: #tabs-3}
<div>
{:.data-table-long .row-border .hover}
Subject | Predicate
------- | ---------
meshv:SCR_Chemical | meshv:active
meshv:SCR_Chemical | meshv:dateCreated
meshv:SCR_Chemical | meshv:dateRevised
meshv:SCR_Chemical | meshv:frequency
meshv:SCR_Chemical | meshv:identifier
meshv:SCR_Chemical | meshv:lastActiveYear
meshv:SCR_Chemical | meshv:note
meshv:SCR_Chemical | meshv:previousIndexing
meshv:SCR_Chemical | meshv:source
meshv:SCR_Chemical | rdfs:label
meshv:SCR_Disease | meshv:active
meshv:SCR_Disease | meshv:dateCreated
meshv:SCR_Disease | meshv:dateRevised
meshv:SCR_Disease | meshv:frequency
meshv:SCR_Disease | meshv:identifier
meshv:SCR_Disease | meshv:lastActiveYear
meshv:SCR_Disease | meshv:note
meshv:SCR_Disease | meshv:previousIndexing
meshv:SCR_Disease | meshv:source
meshv:SCR_Disease | rdfs:label
meshv:SCR_Protocol | meshv:active
meshv:SCR_Protocol | meshv:dateCreated
meshv:SCR_Protocol | meshv:dateRevised
meshv:SCR_Protocol | meshv:frequency
meshv:SCR_Protocol | meshv:identifier
meshv:SCR_Protocol | meshv:lastActiveYear
meshv:SCR_Protocol | meshv:note
meshv:SCR_Protocol | meshv:previousIndexing
meshv:SCR_Protocol | meshv:source
meshv:SCR_Protocol | rdfs:label
meshv:SupplementaryConceptRecord | meshv:active
meshv:SupplementaryConceptRecord | meshv:dateCreated
meshv:SupplementaryConceptRecord | meshv:dateRevised
meshv:SupplementaryConceptRecord | meshv:frequency
meshv:SupplementaryConceptRecord | meshv:identifier
meshv:SupplementaryConceptRecord | meshv:lastActiveYear
meshv:SupplementaryConceptRecord | meshv:note
meshv:SupplementaryConceptRecord | meshv:previousIndexing
meshv:SupplementaryConceptRecord | meshv:source
meshv:SupplementaryConceptRecord | rdfs:label

</div>
</div>

### SPARQL

The RDF output shown in the diagram above can be generated with the following
<span class='invoke-sparql'>SPARQL query</span>:


```sparql
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>
construct {
    mesh:C025735 ?p ?o .
    mesh:C025735 a ?scrClass .
    ?scrClass rdfs:subClassOf $scrSuperClass .
    mesh:C025735 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:C025735 meshv:preferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .

    mesh:C012211 meshv:indexerConsiderAlso ?ica .
}
from <http://id.nlm.nih.gov/mesh>
from <http://id.nlm.nih.gov/mesh/vocab>

where {
    mesh:C025735 ?p ?o .
    mesh:C025735 a ?scrClass .
    ?scrClass rdfs:subClassOf $scrSuperClass .
    mesh:C025735 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:C025735 meshv:preferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .

    mesh:C012211 meshv:indexerConsiderAlso ?ica .
      }
```

