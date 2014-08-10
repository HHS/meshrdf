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



At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?query=prefix%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0Aprefix%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0A%0Aconstruct%20%7B%0A%20%20%20%20mesh%3AD000001%20meshv%3Aconcept%20%3Fprefcon%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AisPreferredConcept%20%22Y%22%20.%0A%20%20%20%20%3Fprefcon%20%3Fp%20%3Fo%20.%0A%20%20%20%20%24semtype%20%3Fstp%20%24sto%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Awhere%20%7B%0A%20%20%20%20mesh%3AD000001%20meshv%3Aconcept%20%3Fprefcon%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AisPreferredConcept%20%22Y%22%20.%0A%20%20%20%20%3Fprefcon%20%3Fp%20%3Fo%20.%0A%20%20%20%20%3Fprefcon%20meshv%3AsemanticType%20%24semtype%20.%0A%20%20%20%20%24semtype%20%3Fstp%20%24sto%20.%0A%0A%7D&format=TURTLE)