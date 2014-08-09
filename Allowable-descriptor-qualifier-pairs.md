This example shows the graph derived from one descriptor (D015242, Ofloxacin) and one of it's allowable qualifiers (Q000008, administration &amp; dosage).

## XML

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D015242</DescriptorUI>
  <DescriptorName>
    <String>Ofloxacin</String>
  </DescriptorName>
  ...
  <AllowableQualifiersList>
    <AllowableQualifier>
      <QualifierReferredTo>
        <QualifierUI>Q000008</QualifierUI>
        <QualifierName>
          <String>administration &amp; dosage</String>
        </QualifierName>
      </QualifierReferredTo>
      <Abbreviation>AD</Abbreviation>
    </AllowableQualifier>
    ...
  </AllowableQualifiersList>
   ...
</DescriptorRecord>
```

## RDF (turtle format)

```
TBD
```

This RDF is depicted in the following graph:

![](https://github.com/HHS/mesh-rdf/blob/master/doc/DQPair.png)

## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
TBD
}
```

At the time of this writing, you can see the results dynamically from [this
url]()