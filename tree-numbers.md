---
title: Tree Numbers
layout: page
resource: true
categories:
- Data Model
---

MeSH descriptors are organized into 16 categories, each of which is further divided into 
sub-categories to assist in more specific classification of a descriptor. These hierarchical 
categories and subcategories are identified by [MeSH tree 
numbers](http://www.nlm.nih.gov/mesh/intro_trees.html).
A given MeSH descriptor often has more than one tree number assigned to it, meaning that it 
fits into the category hierarchies in multiple places.

In MeSH RDF, tree numbers are both classes in their own right (meshv:TreeNumber), as well as 
properties of a meshv:Descriptor, via the meshv:treeNumber predicate. meshv:TreeNumber classes 
are related to each other via the meshv:parentTreeNumber relationship. In order to discover
ancestors or descendants of a meshv:Descriptor according to these hierarchies,
one could use the '+' operator on the meshv:parentTreeNumber property. (See the [Sample 
Queries](http://hhs.github.io/meshrdf/sample-queries.html) page for
examples).

More information about MeSH Tree Numbers is available in the MeSH 
documentation, [MeSH Tree Structures](http://www.nlm.nih.gov/mesh/intro_trees.html).

### RDF Graph Diagram

In this particular example, 'Eye' belongs to both the 'Body Regions' tree (A01) and the 'Sense 
Organs' tree (A09).

![Tree Numbers Produce Overlapping Hierarchies](images/BroaderRelations.png){: class="rdf-graph img-responsive"}

To account for the fact that MeSH Descriptors can belong to multiple trees, MeSH RDF represents 
tree numbers as a proper class called meshv:TreeNumber. As mentioned earlier, users can leverage the 
"meshv:parentTreeNumber+" construct to walk up and down the trees to which MeSH descriptors belong.
For example, <span class = "invoke-sparql">this query</span> retrieves all ancestors of 'Eyebrows'.
Note, in particular, that the results do *not* include D012679, Sense Organs (which a naive query
using the meshv:broaderDescriptor property would.)

![Tree Numbers RDF Graph Model](images/BroaderRelationsWithTreeNodes.png){: class="rdf-graph img-responsive"}


```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?treeNode ?ancestor ?alabel
FROM <http://id.nlm.nih.gov/mesh2014>

WHERE {
  mesh:D005138 meshv:treeNumber ?treeNode .
  ?treeNode meshv:parentTreeNumber+ ?ancestorTreeNode .
  ?ancestor meshv:treeNumber ?ancestorTreeNode .
  ?ancestor rdfs:label ?alabel
}

ORDER BY ?treeNode
```

### meshv:TreeNumber - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:TreeNumber properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-long .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:TreeNumber | meshv:parentTreeNumber | meshv:TreeNumber

</div>

{: #tabs-2}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
meshv:Descriptor | meshv:treeNumber | meshv:TreeNumber
meshv:GeographicalDescriptor | meshv:treeNumber | meshv:TreeNumber
meshv:PublicationType | meshv:treeNumber | meshv:TreeNumber
meshv:Qualifier | meshv:allowedTreeNode | meshv:TreeNumber
meshv:Qualifier | meshv:treeNumber | meshv:TreeNumber
meshv:TopicalDescriptor | meshv:treeNumber | meshv:TreeNumber
meshv:TreeNumber | meshv:parentTreeNumber | meshv:TreeNumber

</div>

{: #tabs-3}
<div>
{:.data-table-long .row-border .hover}
Subject | Predicate
------- | ---------
meshv:TreeNumber | meshv:active
meshv:TreeNumber | meshv:lastActive
meshv:TreeNumber | rdfs:label

</div>
</div>

### SPARQL

Users can also discover immediate narrower/broader meshv:Descriptors via the meshv:parentTreeNumber predicate.
The following <span class='invoke-sparql'>SPARQL query</span> creates a table that shows the relationships between "Eye"
and each of the immediate broader and narrower concepts for each of its tree numbers:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

SELECT *
FROM <http://id.nlm.nih.gov/mesh>
WHERE {
 mesh:D005123 meshv:treeNumber ?tree_number .

  {
    SELECT ?tree_number
           ?broader_tree_number ?broader_descriptor
           ?narrower_tree_number ?narrower_descriptor
    WHERE {
      ?tree_number meshv:parentTreeNumber ?broader_tree_number .
      ?broader_descriptor meshv:treeNumber ?broader_tree_number .
      mesh:D005123 meshv:broaderDescriptor ?broader_descriptor .

      ?narrower_tree_number meshv:parentTreeNumber ?tree_number .
      ?narrower_descriptor meshv:treeNumber ?narrower_tree_number .
      ?narrower_descriptor meshv:broaderDescriptor mesh:D005123 .
    }
  }
}
```

The <span class='invoke-sparql'>SPARQL query</span> below outputs the RDF graph of the 
previous query, using the CONSTRUCT clause.

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

CONSTRUCT {
  mesh:D005123 meshv:treeNumber ?tree_number .
  ?tree_number meshv:parentTreeNumber ?broader_tree_number .
  ?broader_descriptor meshv:treeNumber ?broader_tree_number .
  mesh:D005123 meshv:broaderDescriptor ?broader_descriptor .

  ?narrower_tree_number meshv:parentTreeNumber ?tree_number .
  ?narrower_descriptor meshv:treeNumber ?narrower_tree_number .
  ?narrower_descriptor meshv:broaderDescriptor mesh:D005123 .
}
from <http://id.nlm.nih.gov/mesh>
where {
  mesh:D005123 meshv:treeNumber ?tree_number .

  {
    select ?tree_number
           ?broader_tree_number ?broader_descriptor
           ?narrower_tree_number ?narrower_descriptor
    where {
      ?tree_number meshv:parentTreeNumber ?broader_tree_number .
      ?broader_descriptor meshv:treeNumber ?broader_tree_number .
      mesh:D005123 meshv:broaderDescriptor ?broader_descriptor .

      ?narrower_tree_number meshv:parentTreeNumber ?tree_number .
      ?narrower_descriptor meshv:treeNumber ?narrower_tree_number .
      ?narrower_descriptor meshv:broaderDescriptor mesh:D005123 .
    }
  }
}
```

