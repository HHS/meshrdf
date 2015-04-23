---
title: Semantic Types
layout: page
resource: true
categories:
- Data Model
---

*Deprecation Notice: meshv:SemanticType (the class) and meshv:semanticType (the predicate) are deprecated.*{: style="color: red; font-weight:bold"}  These data will be removed in late May/early June when 2015 MeSH RDF is released.

[Semantic Types](http://www.nlm.nih.gov/research/umls/META3_current_semantic_types.html){: target="_blank"} are assigned to MeSH concepts, and provide a hierarchical framework for
broad levels of categorization.  Examples of semantic types are 'Organ or Tissue Function', 'Gene or Genome', etc.  In MeSH RDF, Semantic types are members of the class [meshv:SemanticType](http://id.nlm.nih.gov/mesh/describe?uri=http%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23SemanticType){:target="_blank"}.


### meshv:SemanticType - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:SemanticType properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-long .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
N/A | N/A | N/A 

</div>

{: #tabs-2}
<div>

{:.data-table-long .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
meshv:Concept | <s>meshv:semanticType</s> | <s>meshv:SemanticType</s>

</div>

{: #tabs-3}
<div>
{:.data-table-long .row-border .hover}
Subject | Predicate
------- | ---------
<s>meshv:SemanticType</s> | rdfs:label
<s>meshv:SemanticType</s> | meshv:identifier

</div>
</div>