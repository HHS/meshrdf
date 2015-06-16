---
title: MeSH RDF 2015 (beta) Release Notes
layout: page
resource: false
---


{:#archived-content}

The 2015 version of MeSH RDF will go live the afternoon of June 18th, 2015. The previous graph of http://id.nlm.nih.gov/mesh2014 will no longer be available after June 18th, 2015. Users must update their SPARQL queries to use http://id.nlm.nih.gov/mesh.
{: style="color: red"}

### Graph Changes

MeSH RDF will follow established versioning practices, but MeSH RDF will be expressed in non-versioned and versioned URIs. For example, the Descriptor for Ofloxacin will have the following URIs:

* http://id.nlm.nih.gov/mesh/D015242 (current)
* http://id.nlm.nih.gov/mesh/2015/D015242 (2015)

The non-versioned URI reflects the current state of MeSH at any given time. The versioned URI for the current year will mirror the non-versioned URI until NLM releases the next year's MeSH data. Once NLM begins using the next year's MeSH data, the next year's versioned URI will mirror the non-versioned URI, and the current year's data will become static and archived. Current year MeSH is dynamic until archived. NLM will retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015 MeSH.

### Daily Updates
Starting June 18, 2015, MeSH RDF data will update on a daily basis in sync with MeSH XML.
Supplementary Concept Records (SCRs) are added throughout the year on a daily basis.
Changes to MeSH Descriptors and Qualifiers are typically done only on an annual basis at the end of the year,
but may occasionally occur at other times.
NLM will load daily SCR data so that users have the benefit of new SCR URIs, but we will not protect against deleted URIs at this time.
However, these deleted URIs **will not** return an HTTP status 404 code.  This will be remedied in future updates.

### Language Tags
Users now must specify the language tag '@en' when searching rdfs:label.
One preferred MeSH Heading, Central Nervous System which is D002493, has non-English strings as a proof-of-concept example.  This sample will remain in the beta version but may not be included in the production MeSH RDF version.

### New Classes

none

### New Predicates

{:.data-table-standard .row-border .hover}
Name | Domain | Range | Description
------- | ----------- | ----- | --------
meshv:broaderConcept | meshv:Concept | meshv:Concept | Relates one Concept to another. A semantic relationship between two Concepts, usually between the preferred concept and subordinate concept(s) where one is broader in meaning. Example: M0024816 is broader than M0024811.
meshv:broaderDescriptor | meshv:Descriptor | meshv:Descriptor | Relates one Descriptor to another. The immediate parent Descriptor(s) of a given Descriptor based on the TreeNumber hierarchy. Example: both DUI D007254 (Information Science) and DUI D008491 (Medical Informatics Applications) are parents of DUI D016247 (Information Storage and Retrieval).
meshv:broaderQualifier | meshv:Qualifier | meshv:Qualifier | Relates one Qualifier to another. The immediate parent Qualifier(s) of a given Qualifier based on the TreeNumber hierarchy. Example: QUI Q000458 (organization & administration) is a parent of QUI Q000592 (standards).
meshv:parentTreeNumber | meshv:TreeNumber | meshv:TreeNumber | Relates one TreeNumber to another. Immediate 'parent' TreeNumber, meaning one level higher in the TreeNumber hierarchy. Example: D03.438.221 is a parent of D03.438.221.173.
meshv:preferredTerm | meshv:Concept<br/>meshv:Descriptor<br/>meshv:Qualifier<br/>meshv:SupplementaryConceptRecord | meshv:Term | Relates Concepts, Descriptors, Qualifiers or SupplementaryConceptRecords to Terms. Indicates that the Term is the preferred term for a Concept, Descriptor, Qualifier, or SupplementaryConceptRecord.
meshv:relatedConcept | meshv:Concept | meshv:Concept | Relates one Concept to another. A semantic relationship between two Concepts, usually between the preferred Concept and subordinate Concept(s) where one is neither broader nor narrower in meaning. Example: M0000562 is related to M0000561

### Removals

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






