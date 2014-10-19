---
title: Concepts
layout: page
resource: true
categories:
- Data Model
---

Here are how Concepts are modelled in RDF. 

Note that this page does not describe Terms, which are subordinate to Concepts, but most other things directly related to Concepts are here.

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
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

mesh:D000001  meshv:preferredConcept  mesh:M0000001 .
mesh:M0000001 rdf:type  meshv:Concept ;
              rdfs:label  "Calcimycin" ;
              dcterms:identifier  "M0000001" ;
              meshv:CASN1_label "4-Benzoxazolecarboxylic acid, ..." ;
              meshv:registryNumber  "37H9VM9WZL" ;
              meshv:relatedRegistryNumber "52665-69-7 (Calcimycin)" ;
              skos:scopeNote  "An ionophorous, polyether ... " ;
              meshv:term  mesh:T000002 .
              meshv:semanticType  mesh:T109 ,
                                  mesh:T195 ;
              skos:narrower mesh:M0353609 ;

mesh:T109 rdf:type  meshv:SemanticType ;
          rdfs:label  "Organic Chemical" ;
          dcterms:identifier  "T109" .

mesh:T195 rdf:type  meshv:SemanticType ;
          rdfs:label  "Antibiotic" ;
          dcterms:identifier  "T195" .
```

Note:

* RelationAttributes (not depicted in this example; see the [MeSH documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#RelationAttribute) and [GitHub issue #15](https://github.com/HHS/mesh-rdf/issues/15#issuecomment-50952078)) are currently modeled with their own property URIs.  So, for example, the XML

    ```
    <ConceptRelation RelationName="REL">
      <Concept1UI>M0000205</Concept1UI>
      <Concept2UI>M0567458</Concept2UI>
      <RelationAttribute>187600</RelationAttribute>
    </ConceptRelation>
    ```

  would produce two triples:

    ```
    mesh:M0000205 skos:related mesh:M0567458 .
    mesh:M0000205 mesh:rela/187600 mesh:M0567458 .
    ```



## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D000001 meshv:preferredConcept ?prefcon .
    ?prefcon ?p ?o .
    ?prefcon meshv:semanticType $semtype .
    $semtype ?stp $sto .
}
from <http://chrismaloney.org/mesh>
where {
    mesh:D000001 meshv:preferredConcept ?prefcon .
    ?prefcon ?p ?o .
    ?prefcon meshv:semanticType $semtype .
    $semtype ?stp $sto .

}
```

At the time of this writing, you can see the results dynamically from [this url](http://jatspan.org:8890/sparql?query=prefix+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0Aprefix+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0A%0D%0Aconstruct+%7B%0D%0A++++mesh%3AD000001+meshv%3ApreferredConcept+%3Fprefcon+.%0D%0A++++%3Fprefcon+%3Fp+%3Fo+.%0D%0A++++%3Fprefcon+meshv%3AsemanticType+%24semtype+.%0D%0A++++%24semtype+%3Fstp+%24sto+.%0D%0A%7D%0D%0Afrom+%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0D%0Awhere+%7B%0D%0A++++mesh%3AD000001+meshv%3ApreferredConcept+%3Fprefcon+.%0D%0A++++%3Fprefcon+%3Fp+%3Fo+.%0D%0A++++%3Fprefcon+meshv%3AsemanticType+%24semtype+.%0D%0A++++%24semtype+%3Fstp+%24sto+.%0D%0A%0D%0A%7D&format=TURTLE)