---
title: MeSH RDF Release Notes
layout: page
resource: false
---


{:#archived-content}

## Latest Release

### September 7, 2017

* MeSH RDF is no longer in beta. 
* MeSH RDF files have been moved to ftp://ftp.nlm.nih.gov/online/mesh/rdf/.

## Prior Releases

### November 21, 2016

* MeSH RDF has been updated to include the 2017 MeSH data. See [MeSH vocabulary changes for 2017](https://www.nlm.nih.gov/mesh/introduction.html#changes).
* NLM has minted a new graph, http://id.nlm.nih.gov/mesh/2017/. This graph will stay in sync with the http://id.nlm.nih.gov/mesh/ graph until 2018 MeSH data is released.
* The graph for 2016 MeSH data, http://id.nlm.nih.gov/mesh/2016/, is now static. 

### December 3, 2015

* NLM has introduced two new predicates to MeSH RDF to handle obsolete content:
  * meshv:active - active content will have a value of 1, while inactive (obsolete) content will have a value of 0. 
  * meshv:lastActiveYear - this will indicate the last year in which MeSH content was active. That year can be used to construct a versioned URI to retrieve data about that content. 
* Labels for inactive content will have the string "[OBSOLETE]" prepended to them. 

### November 19, 2015

* MeSH RDF has been updated to include the 2016 MeSH data. See [MeSH vocabulary changes for 2016](https://www.nlm.nih.gov/mesh/introduction.html#changes).
* NLM has minted a new graph, http://id.nlm.nih.gov/mesh/2016/. This graph will stay in sync with the http://id.nlm.nih.gov/mesh/ graph until 2017 MeSH data is released.
* The graph for 2015 MeSH data, http://id.nlm.nih.gov/mesh/2015/, is now static. 
* NLM has added NLM Classification Numbers to MeSH. A new predicate, meshv:nlmClassificationNumber, relates Descriptors to NLM Classification Numbers. 
* meshv:DescriptorQualifierPairs now have labels. 

### August 10, 2015

#### SPARQL Endpoint Changes

As of August 10, 2015, we have made changes to the base URL used for HTML and non-HTML query requests. To request HTML query results, use our query editor: http://id.nlm.nih.gov/mesh/query/. To request any other format, use our SPARQL endpoint with base URL http://id.nlm.nih.gov/mesh/sparql. Note that the SPARQL endpoint will no longer return HTML, so links to some queries may break. For more information, see our [SPARQL and URI Requests page](sparql-and-uri-requests.html). 

### June 18, 2015

The 2015 version of MeSH RDF is now live.
The previous graph of http://id.nlm.nih.gov/mesh2014 is no longer available.
Users must update their SPARQL queries to use the non-versioned graph (http://id.nlm.nih.gov/mesh) or the versioned graph (http://id.nlm.nih.gov/mesh/2015).

#### Graph Changes

MeSH RDF will follow established versioning practices, but MeSH RDF will be expressed in non-versioned and versioned URIs. For example, the Descriptor for Ofloxacin will have the following URIs:

* http://id.nlm.nih.gov/mesh/D015242 (current)
* http://id.nlm.nih.gov/mesh/2015/D015242 (2015)

The non-versioned URI reflects the current state of MeSH at any given time. The versioned URI for the current year will mirror the non-versioned URI until NLM releases the next year's MeSH data. Once NLM begins using the next year's MeSH data, the next year's versioned URI will mirror the non-versioned URI, and the current year's data will become static and archived. Current year MeSH is dynamic until archived. NLM will retain no more than three years of versioned URIs, and NLM will not produce versioned URIs for data prior to 2015 MeSH.

#### Daily Updates
Starting June 18, 2015, MeSH RDF data will update on a daily basis in sync with MeSH XML.
Supplementary Concept Records (SCRs) are added throughout the year on a daily basis.
Changes to MeSH Descriptors and Qualifiers are typically done only on an annual basis at the end of the year,
but may occasionally occur at other times.
NLM will load daily SCR data so that users have the benefit of new SCR URIs, but we will not protect against deleted URIs at this time.
However, these deleted URIs **will not** return an HTTP status 404 code.  This will be remedied in future updates.

#### Language Tags
Users now must specify the language tag '@en' when searching rdfs:label or any other string literal.  See the [sample queries page](sample-queries.html) (queries #5 and #6) for examples.
One preferred MeSH Heading, Central Nervous System which is D002493, has non-English strings as a proof-of-concept example.  This sample will remain in the beta version but may not be included in the production MeSH RDF version.

#### New Classes

none

#### New Predicates

{:.data-table-standard .row-border .hover}
Name | Domain | Range | Description
------- | ----------- | ----- | --------
meshv:broaderConcept | meshv:Concept | meshv:Concept | Relates one Concept to another. A semantic relationship between two Concepts, usually between the preferred concept and subordinate concept(s) where one is broader in meaning. Example: M0024816 is broader than M0024811.
meshv:broaderDescriptor | meshv:Descriptor | meshv:Descriptor | Relates one Descriptor to another. The immediate parent Descriptor(s) of a given Descriptor based on the TreeNumber hierarchy. Example: both DUI D007254 (Information Science) and DUI D008491 (Medical Informatics Applications) are parents of DUI D016247 (Information Storage and Retrieval).
meshv:broaderQualifier | meshv:Qualifier | meshv:Qualifier | Relates one Qualifier to another. The immediate parent Qualifier(s) of a given Qualifier based on the TreeNumber hierarchy. Example: QUI Q000458 (organization & administration) is a parent of QUI Q000592 (standards).
meshv:narrowerConcept | meshv:Concept | meshv:Concept | Relates one Concept to another. A semantic relationship between the preferred concept and subordinate concept(s) where one is narrower in meaning. Example: M0353609 is narrower with respect to M0000001.
meshv:parentTreeNumber | meshv:TreeNumber | meshv:TreeNumber | Relates one TreeNumber to another. Immediate 'parent' TreeNumber, meaning one level higher in the TreeNumber hierarchy. Example: D03.438.221 is a parent of D03.438.221.173.
meshv:preferredTerm | meshv:Concept<br/>meshv:Descriptor<br/>meshv:Qualifier<br/>meshv:SupplementaryConceptRecord | meshv:Term | Relates Concepts, Descriptors, Qualifiers or SupplementaryConceptRecords to Terms. Indicates that the Term is the preferred term for a Concept, Descriptor, Qualifier, or SupplementaryConceptRecord.
meshv:relatedConcept | meshv:Concept | meshv:Concept | Relates one Concept to another. A semantic relationship between two Concepts, usually between the preferred Concept and subordinate Concept(s) where one is neither broader nor narrower in meaning. Example: M0000562 is related to M0000561

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
