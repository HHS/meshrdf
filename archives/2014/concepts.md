---
title: Concepts
layout: page
resource: true
archived: true
mesh-year: 2014
categories:
- Data Model
---
A concept is a class in MeSH RDF with the name [meshv:Concept](http://id.nlm.nih.gov/mesh/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23Concept){:target="_blank"}.  MeSH Concepts are all assigned 'M' identifiers.  A MeSH Concept represents a unit of meaning.
Each MeSH record consists of one or more Concepts, and each Concept consists in one or more synonymous terms.
Collections of concepts that may be useful for search and retrieval on a given topic are placed into the same MeSH Descriptor.
A concept is considered 'preferred' if its name is used by the descriptor to which it belongs.
For more information about Concepts, visit the NLM [MeSH Concept Structure page](http://www.nlm.nih.gov/mesh/concept_structure.html){:target="_blank"}.
The diagram below illustrates the relations and properties of meshv:Concept classes.

### RDF Graph Diagram

![Concept RDF Graph Diagram](images/Concepts.png){: class="rdf-graph img-responsive"}

### meshv:Concept - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:Concept properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-long .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:Concept | meshv:broader | meshv:Concept
meshv:Concept | meshv:narrower | meshv:Concept
meshv:Concept | meshv:preferredTerm | meshv:Term
meshv:Concept | meshv:term | meshv:Term
meshv:Concept | meshv:related | meshv:Concept
meshv:Concept | meshv:semanticType | meshv:SemanticType

</div>

{: #tabs-2}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
meshv:CheckTag | meshv:preferredConcept | meshv:Concept
meshv:Concept | meshv:broader | meshv:Concept
meshv:Concept | meshv:narrower | meshv:Concept
meshv:Concept | meshv:related | meshv:Concept
meshv:Descriptor | meshv:concept | meshv:Concept
meshv:Descriptor | meshv:preferredConcept | meshv:Concept
meshv:GeographicalDescriptor | meshv:concept | meshv:Concept
meshv:GeographicalDescriptor | meshv:preferredConcept | meshv:Concept
meshv:PublicationType | meshv:concept | meshv:Concept
meshv:PublicationType | meshv:preferredConcept | meshv:Concept
meshv:Qualifier | meshv:concept | meshv:Concept
meshv:Qualifier | meshv:preferredConcept | meshv:Concept
meshv:SCR_Chemical | meshv:concept | meshv:Concept
meshv:SCR_Chemical | meshv:preferredConcept | meshv:Concept
meshv:SCR_Disease | meshv:concept | meshv:Concept
meshv:SCR_Disease | meshv:preferredConcept | meshv:Concept
meshv:SCR_Protocol | meshv:concept | meshv:Concept
meshv:SCR_Protocol | meshv:preferredConcept | meshv:Concept
meshv:SupplementaryConceptRecord | meshv:concept | meshv:Concept
meshv:SupplementaryConceptRecord | meshv:preferredConcept | meshv:Concept
meshv:TopicalDescriptor | meshv:concept | meshv:Concept
meshv:TopicalDescriptor | meshv:preferredConcept | meshv:Concept

</div>

{: #tabs-3}
<div>
{:.data-table-long .row-border .hover}
Subject | Predicate
------- | ---------
meshv:Concept | meshv:casn1_label
meshv:Concept | meshv:identifier
meshv:Concept | meshv:registryNumber
meshv:Concept | meshv:relatedRegistryNumber
meshv:Concept | meshv:scopeNote
meshv:Concept | rdfs:label

</div>
</div>

### SPARQL

The RDF output above can be generated with the following <span class='invoke-sparql'>SPARQL query</span>:


```sparql
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D000001 meshv:preferredConcept ?prefcon .
    ?prefcon ?p ?o .
    ?prefcon meshv:semanticType $semtype .
    $semtype ?stp $sto .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:D000001 meshv:preferredConcept ?prefcon .
    ?prefcon ?p ?o .
    ?prefcon meshv:semanticType $semtype .
    $semtype ?stp $sto .

}
```

###MeSH RDF Data

```
<http://id.nlm.nih.gov/mesh/T195>
        a       <http://id.nlm.nih.gov/mesh/vocab#SemanticType> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "Antibiotic" ;
        <http://purl.org/dc/terms/identifier>
                "T195" .

<http://id.nlm.nih.gov/mesh/D000001>
        <http://id.nlm.nih.gov/mesh/vocab#preferredConcept>
                <http://id.nlm.nih.gov/mesh/M0000001> .

<http://id.nlm.nih.gov/mesh/T109>
        a       <http://id.nlm.nih.gov/mesh/vocab#SemanticType> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "Organic Chemical" ;
        <http://purl.org/dc/terms/identifier>
                "T109" .

<http://id.nlm.nih.gov/mesh/M0000001>
        a       <http://id.nlm.nih.gov/mesh/vocab#Concept> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "Calcimycin" ;
        <http://id.nlm.nih.gov/mesh/vocab#casn1_label>
                "4-Benzoxazolecarboxylic acid, 5-(methylamino)-2-((3,9,11-trimethyl-8-(1-methyl-2-oxo-2-(1H-pyrrol-2-yl)ethyl)-1,7-dioxaspiro(5.5)undec-2-yl)methyl)-, (6S-(6alpha(2S*,3S*),8beta(R*),9beta,11alpha))-" ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredTerm>
                <http://id.nlm.nih.gov/mesh/T000002> ;
        <http://id.nlm.nih.gov/mesh/vocab#registryNumber>
                "37H9VM9WZL" ;
        <http://id.nlm.nih.gov/mesh/vocab#relatedRegistryNumber>
                "52665-69-7 (Calcimycin)" ;
        <http://id.nlm.nih.gov/mesh/vocab#semanticType>
                <http://id.nlm.nih.gov/mesh/T195> , <http://id.nlm.nih.gov/mesh/T109> ;
        <http://purl.org/dc/terms/identifier>
                "M0000001" ;
        <http://id.nlm.nih.gov/mesh/vocab#narrower>
                <http://id.nlm.nih.gov/mesh/M0353609> ;
        <http://id.nlm.nih.gov/mesh/vocab#scopeNote>
                "An ionophorous, polyether antibiotic from Streptomyces chartreusensis. It binds and transports CALCIUM and other divalent cations across membranes and uncouples oxidative phosphorylation while inhibiting ATPase of rat liver mitochondria. The substance is used mostly as a biochemical tool to study the role of divalent cations in various biological systems."
```

### MeSH XML

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D000001</DescriptorUI>
  <DescriptorName>
    <String>Calcimycin</String>
  </DescriptorName>
  ...
  <ConceptList>
    <Concept PreferredConceptYN="Y">
      <ConceptUI>M0000001</ConceptUI>
      <ConceptName>
        <String>Calcimycin</String>
      </ConceptName>
      <CASN1Name>4-Benzoxazolecarboxylic acid, 5-(methylamino)-2-((3,9,11-trimethyl-8-(1-methyl-2-oxo-2-(1H-pyrrol-2-yl)ethyl)-1,7-dioxaspiro(5.5)undec-2-yl)methyl)-, (6S-(6alpha(2S*,3S*),8beta(R*),9beta,11alpha))-</CASN1Name>
      <RegistryNumber>37H9VM9WZL</RegistryNumber>
      <ScopeNote>An ionophorous, polyether antibiotic from Streptomyces chartreusensis. It binds and transports CALCIUM and other divalent cations across membranes and uncouples oxidative phosphorylation while inhibiting ATPase of rat liver mitochondria. The substance is used mostly as a biochemical tool to study the role of divalent cations in various biological systems.</ScopeNote>
      <SemanticTypeList>
        <SemanticType>
          <SemanticTypeUI>T109</SemanticTypeUI>
          <SemanticTypeName>Organic Chemical</SemanticTypeName>
        </SemanticType>
        <SemanticType>
          <SemanticTypeUI>T195</SemanticTypeUI>
          <SemanticTypeName>Antibiotic</SemanticTypeName>
        </SemanticType>
      </SemanticTypeList>
      <RelatedRegistryNumberList>
        <RelatedRegistryNumber>52665-69-7 (Calcimycin)</RelatedRegistryNumber>
      </RelatedRegistryNumberList>
      <ConceptRelationList>
        <ConceptRelation RelationName="NRW">
          <Concept1UI>M0000001</Concept1UI>
          <Concept2UI>M0353609</Concept2UI>
        </ConceptRelation>
      </ConceptRelationList>
      ...
    </Concept>
    <Concept PreferredConceptYN="N">
      <ConceptUI>M0353609</ConceptUI>
      ...
    </Concept>
  </ConceptList>
</DescriptorRecord>
```

### Notes

* RelationAttributes (see the [MeSH
  documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#RelationAttribute)) are not
  modelled in the RDF.

* \<ConceptRelations> (see the [documentation on the XML
  elements](http://www.nlm.nih.gov/mesh/xml_data_elements.html#ConceptRelation)) are converted into
  simple triples on the basis of the @RelationName attribute:
    * BRD - meshv:broader
    * NRW - meshv:narrower
    * REL - meshv:related
