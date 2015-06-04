---
title: Release Notes
layout: page
resource: true
categories:
- Cheat Sheets
---

### MeSH 2015 (beta) Release Notes    
<p/>

#### Graph Changes:

MeSH RDF will follow established versioning practices, but MeSH RDF will be expressed in versioned and non-versioned URIs. For example, the Descriptor for Ofloxacin will have the following URIs:

* http://id.nlm.nih.gov/mesh/D015242 (current)
* http://id.nlm.nih.gov/mesh/2015/D015242 (2015)

The non-versioned URI reflects the current state of MeSH at any given time. The versioned URI for the current year will mirror the non-versioned URI until the next year's MeSH data is released in the Fall. At some point, the next year's versioned URI will mirror the non-versioned URI, and the current year's URI will become static and archived. NLM will retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015. 


#### New Classes

none

#### New Predicates

{:.data-table-standard .row-border .hover}
Name | Domain | Range | Description
------- | ----------- | ----- | --------
meshv:broaderConcept | meshv:Concept | meshv:Concept | Connects two instances of meshv:Concept, one of which is broader than the other.
meshv:broaderDescriptor | meshv:Descriptor | meshv:Descriptor | Connects two instances of meshv:Descriptor, one of which is broader than the other.
meshv:broaderQualifier | meshv:Qualifier | meshv:Qualifier | Connects two instances of meshv:Qualifier, one of which is broader than the other.
meshv:parentTreeNumber | meshv:TreeNumber | meshv:TreeNumber | A transitive predicate that connects a tree number to its parent.
meshv:preferredTerm | meshv:Descriptor<br/>meshv:Concept<br/>meshv:SupplementaryConceptRecord | meshv:Term | Reveals the preferred term for an instance of a meshv:Descriptor, meshv:SupplementaryConceptRecord, or a meshv:Qualifier.
meshv:relatedConcept | meshv:Concept | meshv:Concept | Connects two instances of mesh:Concept classes.

#### Removals

{:.data-table-standard .row-border .hover}
Data Type | Data Element | Change Type | Additonal Information
------ | ------ | ----------- | -----------
predicate | meshv:activeMeSHYear | Removed | 
predicate | meshv:allowedTreeNode | Removed |
predicate | meshv:broader | Removed | Replaced by meshv:broaderConcept, meshv:broaderDescriptor, or meshv:broaderQualifier
predicate | meshv:broaderTransitive | Removed | Replaced by meshv:parentTreeNumber 
predicate | meshv:narrower | Removed | Replaced by meshv:narrowerConcept
predicate | meshv:printFlag | Removed | 
predicate | meshv:recordAuthorizer | Removed |
predicate | meshv:recordMaintainer | Removed |
predicate | meshv:recordOriginator | Removed |
predicate | meshv:recordPreferredTerm | Removed | Replaced by meshv:preferredTerm
predicate | meshv:related | Removed | Replaced by meshv:relatedConcept
predicate | meshv:runningHead | Removed |
class | meshv:SemanticType | Removed |
predicate | meshv:semanticType | Removed |






