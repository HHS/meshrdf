See the discussion on issue [#22](https://github.com/HHS/mesh-rdf/issues/22).

The following diagram illustrates the problem of tree numbers, that impose multiple overlapping hierarchical
relationships between descriptors. In the diagram, every arrow indicates a skos:broader relationship.

In this particular example, "Eye" belongs to two overlapping trees -- one that is depicted in green and 
one in purple.

According to the green tree, "Eyebrow" has broader concept "Eye", which has broader concept "Face".
According to the purple tree, "Oculomotor Muscles" has broader concept "Eye", which has broader concept
"Sense Organ".

![](https://cloud.githubusercontent.com/assets/77226/3799017/0cfd2b52-1bea-11e4-8786-01e144579e85.png)

Leaving aside the question of whether or not these particular relationships make sense, this is the
way the tree numbers currently exist in MeSH.

The problem comes when you try to use these relations to "walk up the tree".  If these properties
were transitive, then one could conclude that "Eyebrows" has broader concept "Sense Organ", or that 
"Oculomotor Muscles" has broader concept "Face", but neither of those is true according to the MeSH trees.

The way that this is modeled in MeSH RDF is illustrated in the following graph.  Each tree number
is reified as a first-class resource.  `skos:broader` relations (which are not transitive) are asserted
between the `Descriptor`s, and `skos:broaderTransitive` relations (which, obviously, are) are asserted
between the `TreeNumber`s.

![](https://cloud.githubusercontent.com/assets/77226/3817027/e4b8db10-1cd3-11e4-9065-d980c79b9e1d.png)

With this model, if a user wanted to find all the "broader" ancestors of Eyebrows (D005138) then he or
she could do so, using the SPARQL transitivity operator ("+"), with the following query:

```sparql
select ?ancestor
where {
    mesh:D005138 mesh:hasTreeNode ?treeNode .
    ?treeNode skos:broaderTransitive+ ?ancestorTreeNode .
    ?ancestor mesh:hasTreeNode ?ancestorTreeNode
}
```

# XML

```xml
<DescriptorRecordSet LanguageCode="eng">
  
  <DescriptorRecord DescriptorClass="1">
    <DescriptorUI>D005123</DescriptorUI>
    <DescriptorName>
      <String>Eye</String>
    </DescriptorName>
    ...
    <TreeNumberList>
      <TreeNumber>A01.456.505.420</TreeNumber>
      <TreeNumber>A09.371</TreeNumber>
    </TreeNumberList>
    ...
  </DescriptorRecord>

  <DescriptorRecord DescriptorClass="1">
    <DescriptorUI>D005145</DescriptorUI>
    <DescriptorName>
      <String>Face</String>
    </DescriptorName>
    ...
    <TreeNumberList>
      <TreeNumber>A01.456.505</TreeNumber>
    </TreeNumberList>
    ...
  </DescriptorRecord>
  
  <DescriptorRecord DescriptorClass="1">
    <DescriptorUI>D005138</DescriptorUI>
    <DescriptorName>
      <String>Eyebrows</String>
    </DescriptorName>
    ...
    <TreeNumberList>
      <TreeNumber>A01.456.505.420.338</TreeNumber>
      <TreeNumber>A17.360.296</TreeNumber>
    </TreeNumberList>
    ...
  </DescriptorRecord>
  
  <DescriptorRecord DescriptorClass="1">
    <DescriptorUI>D009801</DescriptorUI>
    <DescriptorName>
      <String>Oculomotor Muscles</String>
    </DescriptorName>
    ...
    <TreeNumberList>
      <TreeNumber>A02.633.567.700</TreeNumber>
      <TreeNumber>A09.371.613</TreeNumber>
    </TreeNumberList>
    ...
  </DescriptorRecord>
  
  <DescriptorRecord DescriptorClass="1">
    <DescriptorUI>D012679</DescriptorUI>
    <DescriptorName>
      <String>Sense Organs</String>
    </DescriptorName>
    ...
    <TreeNumberList>
      <TreeNumber>A09</TreeNumber>
    </TreeNumberList>
    ...
  </DescriptorRecord>

</DescriptorRecordSet>
```

# RDF

# Generating the RDF

The following SPARQL query creates a table that shows the relationships between "Eye"
and each of the immediate broader and narrower concepts for each of its tree numbers:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

SELECT *
from <http://chrismaloney.org/mesh>
where {
  mesh:D005123 meshv:treeNumber ?tree_number .

  {
    select ?tree_number 
           ?broader_tree_number ?broader_descriptor 
           ?narrower_tree_number ?narrower_descriptor
    where {
      ?tree_number skos:broaderTransitive ?broader_tree_number .
      ?broader_descriptor meshv:treeNumber ?broader_tree_number .
      mesh:D005123 skos:broader ?broader_descriptor .

      ?narrower_tree_number skos:broaderTransitive ?tree_number .
      ?narrower_descriptor meshv:treeNumber ?narrower_tree_number .
      ?narrower_descriptor skos:broader mesh:D005123 .
    }
  }
}
```