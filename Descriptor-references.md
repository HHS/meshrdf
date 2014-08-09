This page documents a couple of the ways that Descriptors reference out to other items, and how they are
translated into RDF.


## XML

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D005123</DescriptorUI>
  <DescriptorName>
    <String>Eye</String>
  </DescriptorName> ... <SeeRelatedList>
    <SeeRelatedDescriptor>
      <DescriptorReferredTo>
        <DescriptorUI>D005132</DescriptorUI>
        <DescriptorName>
          <String>Eye Manifestations</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </SeeRelatedDescriptor> ... <SeeRelatedDescriptor>
      <DescriptorReferredTo>
        <DescriptorUI>D014785</DescriptorUI>
        <DescriptorName>
          <String>Vision, Ocular</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </SeeRelatedDescriptor>
  </SeeRelatedList>
  <ConsiderAlso>consider also terms at OCUL-, OPHTHALM-, OPT-, and VIS- </ConsiderAlso>
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

## RDF

![](https://github.com/HHS/mesh-rdf/blob/master/doc/DesriptorRefs.png)


## Generating the RDF

