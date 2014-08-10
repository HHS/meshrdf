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