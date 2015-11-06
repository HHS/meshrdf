---
title: Descriptors
layout: page
resource: true
categories:
- Data Model
---

A Descriptor is a class in MeSH RDF with the name [meshv:Descriptor](http://id.nlm.nih.gov/mesh/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23Descriptor){:target="_blank"}.
Also known as Main Headings or MeSH Headings, Descriptors are used to index citations in the NLM MEDLINE database and to describe the subjects for NLM Catalog records.
Descriptors are searchable in PubMed and NLM Catalog with the search tag [MH]. Most Descriptors indicate the subject of a resource (including geographic terms).
Some indicate publication types (what a resource is rather than what it is about; for example: Randomized Controlled Trial or Letter).
For more information about Descriptors, visit the NLM [MeSH Record Types page](http://www.nlm.nih.gov/mesh/intro_record_types.html).

{: .jump}
&#91; jump to [descriptor properties](#properties) or [descriptor relations](#relations) &#93;


### Class Information

In MeSH RDF, the subclasses of meshv:Descriptor are:

*  meshv:TopicalDescriptor
*  meshv:PublicationType
*  meshv:CheckTag
*  meshv:GeographicalDescriptor


The chart below displays the properties of the meshv:TopicalDescriptor D015242, 'Ofloxacin'.

### <a name = "properties"/>RDF Graph Diagram - Descriptor Properties

The following RDF graph diagram shows a fairly typical Topical Descriptor (D015242, Ofloxacin) and its literals. For reference, see [Ofloxacin in the MeSH browser](https://www.nlm.nih.gov/cgi/mesh/2014/MB_cgi?term=ofloxacin). The data elements featured here have literal strings as objects, not identifiers.

![Descriptor RDF Graph Diagram](images/BasicConversionLiterals.png){: class="rdf-graph img-responsive"}

### SPARQL - Descriptor Properties

The following <span class='invoke-sparql'>SPARQL query</span> will produce the predicates and objects of Ofloxacin.


```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
CONSTRUCT { mesh:D015242 ?p ?o . }
FROM <http://id.nlm.nih.gov/mesh>
WHERE {
  mesh:D015242 ?p ?o .
}
```

### meshv:Descriptor - Relations and Properties
This table includes all the sub-classes of the meshv:Descriptor class as either the subject or object of an RDF triple, as well properties of the class.

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:Descriptor properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | --------
meshv:CheckTag | meshv:preferredConcept | meshv:Concept
meshv:CheckTag | meshv:preferredTerm | meshv:Term
meshv:Descriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:Descriptor | meshv:broaderDescriptor | meshv:Descriptor
meshv:Descriptor | meshv:broaderdescriptor | meshv:GeographicalDescriptor
meshv:Descriptor | meshv:broaderdescriptor | meshv:PublicationType
meshv:Descriptor | meshv:broaderdescriptor | meshv:TopicalDescriptor
meshv:Descriptor | meshv:concept | meshv:Concept
meshv:Descriptor | meshv:pharmacologicalAction | meshv:Descriptor
meshv:Descriptor | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:Descriptor | meshv:preferredConcept | meshv:Concept
meshv:Descriptor | meshv:preferredTerm | meshv:Term
meshv:Descriptor | meshv:seeAlso | meshv:Descriptor
meshv:Descriptor | meshv:seeAlso | meshv:PublicationType
meshv:Descriptor | meshv:seeAlso | meshv:TopicalDescriptor
meshv:Descriptor | meshv:treeNumber | meshv:TreeNumber
meshv:GeographicalDescriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:GeographicalDescriptor | meshv:broaderdescriptor | meshv:Descriptor
meshv:GeographicalDescriptor | meshv:broaderdescriptor | meshv:GeographicalDescriptor
meshv:GeographicalDescriptor | meshv:broaderdescriptor | meshv:TopicalDescriptor
meshv:GeographicalDescriptor | meshv:concept | meshv:Concept
meshv:GeographicalDescriptor | meshv:preferredConcept | meshv:Concept
meshv:GeographicalDescriptor | meshv:preferredTerm | meshv:Term
meshv:GeographicalDescriptor | meshv:treeNumber | meshv:TreeNumber
meshv:PublicationType | meshv:broaderdescriptor | meshv:Descriptor
meshv:PublicationType | meshv:broaderdescriptor | meshv:PublicationType
meshv:PublicationType | meshv:concept | meshv:Concept
meshv:PublicationType | meshv:preferredConcept | meshv:Concept
meshv:PublicationType | meshv:preferredTerm | meshv:Term
meshv:PublicationType | meshv:seeAlso | meshv:Descriptor
meshv:PublicationType | meshv:seeAlso | meshv:PublicationType
meshv:PublicationType | meshv:treeNumber | meshv:TreeNumber
meshv:TopicalDescriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:TopicalDescriptor | meshv:broaderDescriptor | meshv:Descriptor
meshv:TopicalDescriptor | meshv:broaderDescriptor | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:concept | meshv:Concept
meshv:TopicalDescriptor | meshv:pharmacologicalAction | meshv:Descriptor
meshv:TopicalDescriptor | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:preferredConcept | meshv:Concept
meshv:TopicalDescriptor | meshv:preferredTerm | meshv:Term
meshv:TopicalDescriptor | meshv:seeAlso | meshv:Descriptor
meshv:TopicalDescriptor | meshv:seeAlso | meshv:PublicationType
meshv:TopicalDescriptor | meshv:seeAlso | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:treeNumber | meshv:TreeNumber

</div>

{: #tabs-2}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | --------
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:GeographicalDescriptor
meshv:AllowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:Descriptor | meshv:broaderDescriptor | meshv:Descriptor
meshv:Descriptor | meshv:broaderDescriptor | meshv:GeographicalDescriptor
meshv:Descriptor | meshv:broaderDescriptor | meshv:PublicationType
meshv:Descriptor | meshv:broaderDescriptor | meshv:TopicalDescriptor
meshv:Descriptor | meshv:pharmacologicalAction | meshv:Descriptor
meshv:Descriptor | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:Descriptor | meshv:seeAlso | meshv:Descriptor
meshv:Descriptor | meshv:seeAlso | meshv:PublicationType
meshv:Descriptor | meshv:seeAlso | meshv:TopicalDescriptor
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:GeographicalDescriptor
meshv:DescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:Descriptor
meshv:DescriptorQualifierPair | meshv:useInstead | meshv:TopicalDescriptor
meshv:DisallowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:Descriptor
meshv:DisallowedDescriptorQualifierPair | meshv:hasDescriptor | meshv:TopicalDescriptor
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:Descriptor
meshv:DisallowedDescriptorQualifierPair | meshv:useInstead | meshv:TopicalDescriptor
meshv:GeographicalDescriptor | meshv:broaderDescriptor | meshv:Descriptor
meshv:GeographicalDescriptor | meshv:broaderDescriptor | meshv:GeographicalDescriptor
meshv:GeographicalDescriptor | meshv:broaderDescriptor | meshv:TopicalDescriptor
meshv:PublicationType | meshv:broaderDescriptor | meshv:Descriptor
meshv:PublicationType | meshv:broaderDescriptor | meshv:PublicationType
meshv:PublicationType | meshv:seeAlso | meshv:Descriptor
meshv:PublicationType | meshv:seeAlso | meshv:PublicationType
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Chemical | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Chemical | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SCR_Chemical | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Chemical | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Disease | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Disease | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Disease | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SCR_Protocol | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:mappedTo | meshv:Descriptor
meshv:SCR_Protocol | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SCR_Protocol | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:Descriptor
meshv:SCR_Protocol | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:indexerConsiderAlso | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:mappedTo | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:pharmacologicalAction | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:Descriptor
meshv:SupplementaryConceptRecord | meshv:preferredMappedTo | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:broaderDescriptor | meshv:Descriptor
meshv:TopicalDescriptor | meshv:broaderDescriptor | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:pharmacologicalAction | meshv:Descriptor
meshv:TopicalDescriptor | meshv:pharmacologicalAction | meshv:TopicalDescriptor
meshv:TopicalDescriptor | meshv:seeAlso | meshv:Descriptor
meshv:TopicalDescriptor | meshv:seeAlso | meshv:PublicationType
meshv:TopicalDescriptor | meshv:seeAlso | meshv:TopicalDescriptor

</div>

{: #tabs-3}
<div>
{:.data-table-long .row-border .hover}
Subject | Predicate
------- | ---------
meshv:CheckTag | meshv:active
meshv:CheckTag | meshv:annotation
meshv:CheckTag | meshv:dateCreated
meshv:CheckTag | meshv:dateRevised
meshv:CheckTag | meshv:historyNote
meshv:CheckTag | meshv:identifier
meshv:CheckTag | rdfs:label
meshv:CheckTag | meshv:lastActiveYear
meshv:Descriptor | meshv:active
meshv:Descriptor | meshv:annotation
meshv:Descriptor | meshv:considerAlso
meshv:Descriptor | meshv:dateCreated
meshv:Descriptor | meshv:dateEstablished
meshv:Descriptor | meshv:dateRevised
meshv:Descriptor | meshv:historyNote
meshv:Descriptor | meshv:identifier
meshv:Descriptor | meshv:lastActiveYear
meshv:Descriptor | meshv:onlineNote
meshv:Descriptor | meshv:previousIndexing
meshv:Descriptor | meshv:publicMeSHNote
meshv:Descriptor | rdfs:label
meshv:AllowedDescriptorQualifierPair | meshv:active
meshv:GeographicalDescriptor | meshv:annotation
meshv:GeographicalDescriptor | meshv:dateCreated
meshv:GeographicalDescriptor | meshv:dateEstablished
meshv:GeographicalDescriptor | meshv:dateRevised
meshv:GeographicalDescriptor | meshv:historyNote
meshv:GeographicalDescriptor | meshv:identifier
meshv:GeographicalDescriptor | meshv:lastActiveYear
meshv:GeographicalDescriptor | meshv:onlineNote
meshv:GeographicalDescriptor | meshv:previousIndexing
meshv:GeographicalDescriptor | rdfs:label
meshv:GeographicalDescriptor | meshv:active
meshv:PublicationType | meshv:annotation
meshv:PublicationType | meshv:dateCreated
meshv:PublicationType | meshv:dateEstablished
meshv:PublicationType | meshv:dateRevised
meshv:PublicationType | meshv:historyNote
meshv:PublicationType | meshv:identifier
meshv:PublicationType | meshv:lastActiveYear
meshv:PublicationType | meshv:previousIndexing
meshv:PublicationType | rdfs:label
meshv:TopicalDescriptor | meshv:active
meshv:TopicalDescriptor | meshv:annotation
meshv:TopicalDescriptor | meshv:considerAlso
meshv:TopicalDescriptor | meshv:dateCreated
meshv:TopicalDescriptor | meshv:dateEstablished
meshv:TopicalDescriptor | meshv:dateRevised
meshv:TopicalDescriptor | meshv:historyNote
meshv:TopicalDescriptor | meshv:identifier
meshv:TopicalDescriptor | meshv:lastActiveYear
meshv:TopicalDescriptor | meshv:onlineNote
meshv:TopicalDescriptor | meshv:previousIndexing
meshv:TopicalDescriptor | meshv:publicMeSHNote
meshv:TopicalDescriptor | rdfs:label

</div>
</div>


### <a name = "relations"/>RDF Graph Diagram - Descriptor Relations

The graph below depicts the relations of Ofloxacin to other classes.

![Descriptor References RDF Graph Diagram](images/DescriptorRefs.png){: class="rdf-graph img-responsive"}

### SPARQL - Descriptor Relations

The RDF output shown in the diagram above can be generated with the following <span class='invoke-sparql'>SPARQL query</span>.


```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D009369 meshv:annotation ?a .
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
from <http://id.nlm.nih.gov/mesh>
where {
    mesh:D009369 meshv:annotation ?a .
    mesh:D009369 meshv:seeAlso ?sa .
    mesh:D009369 meshv:considerAlso ?ca .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
```
