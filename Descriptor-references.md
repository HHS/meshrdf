This page documents a couple of the ways that Descriptors reference other items, and how those references are
translated into RDF.


## XML

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D005123</DescriptorUI>
  <DescriptorName>
    <String>Eye</String>
  </DescriptorName> 
  ... 
  <SeeRelatedList>
    <SeeRelatedDescriptor>
      <DescriptorReferredTo>
        <DescriptorUI>D005132</DescriptorUI>
        <DescriptorName>
          <String>Eye Manifestations</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </SeeRelatedDescriptor> 
    ... 
    <SeeRelatedDescriptor>
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

The RDF is depicted in the following graph:

![](https://github.com/HHS/mesh-rdf/blob/master/doc/DescriptorRefs.png)

(This drawing was done in [LucidChart](https://www.lucidchart.com), and is on Google drive [here](https://drive.google.com/file/d/0B8n-nWqCI5WmRnVMX0N0V1Vyajg/edit?usp=sharing).)



## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D005123 meshv:seeAlso ?sa .
    mesh:D005123 meshv:considerAlso ?ca .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
from <http://chrismaloney.org/mesh>
where {
    mesh:D005123 meshv:seeAlso ?sa .
    mesh:D005123 meshv:considerAlso ?ca .
    mesh:D015242 meshv:pharmacologicalAction ?pa .
}
```

At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?default-graph-uri=&query=PREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0A%0D%0Aconstruct+%7B%0D%0A++++mesh%3AD005123+meshv%3AseeAlso+%3Fsa+.%0D%0A++++mesh%3AD005123+meshv%3AconsiderAlso+%3Fca+.%0D%0A++++mesh%3AD015242+meshv%3ApharmacologicalAction+%3Fpa+.%0D%0A%7D%0D%0Afrom+%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0D%0Awhere+%7B%0D%0A++++mesh%3AD005123+meshv%3AseeAlso+%3Fsa+.%0D%0A++++mesh%3AD005123+meshv%3AconsiderAlso+%3Fca+.%0D%0A++++mesh%3AD015242+meshv%3ApharmacologicalAction+%3Fpa+.%0D%0A%7D%0D%0A&format=text%2Frdf%2Bn3&timeout=0&debug=on).