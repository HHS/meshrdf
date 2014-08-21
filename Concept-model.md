Here are how Concepts, which are defined in the desc2014.xml file, are modelled in RDF

Note that this page does not describe Terms, which are subordinate to Concepts, but most other things 
directly related to Concepts are here.

See issue #15 before this can be fully implemented.

## XML

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
      <CASN1Name>4-Benzoxazolecarboxylic acid,  ...</CASN1Name>
      <RegistryNumber>37H9VM9WZL</RegistryNumber>
      <ScopeNote>An ionophorous, ... </ScopeNote>
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

## RDF

![](https://github.com/HHS/mesh-rdf/blob/master/doc/Concepts.png)

(This drawing was done in [LucidChart](https://www.lucidchart.com), and is on Google drive [here](https://drive.google.com/file/d/0B8n-nWqCI5WmNXE2b2VTX0Vjb0E/edit?usp=sharing).)

In turtle format:

```
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

mesh:D000001  meshv:concept mesh:M0000001 .

mesh:M0000001 rdf:type  meshv:Concept ;
    rdfs:label "Calcimycin" ;
    dcterms:identifier "M0000001" ;
    skos:scopeNote "An ionophorous, ... systems.\n    " ;
    meshv:isPreferredConcept  "Y" ;
    meshv:CASN1_label "4-Benzoxazolecarboxylic ...eta,11alpha))-" ;
    meshv:registryNumber  "37H9VM9WZL" ;
    meshv:relatedRegistryNumber "52665-69-7 (Calcimycin)" ;
    meshv:conceptRelation _:vb347946 ;
    meshv:term  mesh:T000002 .
    meshv:semanticType  mesh:T109 ,
        mesh:T195 ;

mesh:T109 rdf:type  meshv:SemanticType ;
  rdfs:label  "Organic Chemical" ;
  dcterms:identifier  "T109" .

mesh:T195 rdf:type  meshv:SemanticType ;
  rdfs:label  "Antibiotic" ;
  dcterms:identifier  "T195" .
```

## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D000001 meshv:concept ?prefcon .
    ?prefcon meshv:isPreferredConcept "Y" .
    ?prefcon ?p ?o .
    $semtype ?stp $sto .
}
from <http://chrismaloney.org/mesh>
where {
    mesh:D000001 meshv:concept ?prefcon .
    ?prefcon meshv:isPreferredConcept "Y" .
    ?prefcon ?p ?o .
    ?prefcon meshv:semanticType $semtype .
    $semtype ?stp $sto .

}
```

At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?query=prefix%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0Aprefix%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0A%0Aconstruct%20%7B%0A%20%20%20%20mesh%3AD000001%20meshv%3Aconcept%20%3Fprefcon%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AisPreferredConcept%20%22Y%22%20.%0A%20%20%20%20%3Fprefcon%20%3Fp%20%3Fo%20.%0A%20%20%20%20%24semtype%20%3Fstp%20%24sto%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Awhere%20%7B%0A%20%20%20%20mesh%3AD000001%20meshv%3Aconcept%20%3Fprefcon%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AisPreferredConcept%20%22Y%22%20.%0A%20%20%20%20%3Fprefcon%20%3Fp%20%3Fo%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AsemanticType%20%24semtype%20.%0A%20%20%20%20%24semtype%20%3Fstp%20%24sto%20.%0A%0A%7D&format=TURTLE)