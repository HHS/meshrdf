---
title: Predicates
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below is a list of predicates in MeSH RDF.  

{:.data-table}
Predicate Name | Definition | Equivalent XML Data Element
-------------- | ---------- | ---------------------------
rdf:type | rdf:type is used to state that a resource is an instance of a class. For example, Ofloxacin (mesh:D015242) has an rdf:type of meshv:TopicalDescriptor. | N/A
rdfs:label | rdfs:label is used to provide a human-readable version of a resource's name. For instance, the rdfs:label for mesh:D015242 is Ofloxacin. | ```<String>```
skos:narrower | Explain Me | Where Do I Come From?
dcterms:identifier | Explain Me | Where Do I Come From?
meshv:abbreviation | Two-letter, uppercase abbreviation for a Qualifier term. QUI Q000235 example: GE |```<Abbreviation>```
meshv:activeMeSHYear | Explain Me | Where Do I Come From?
meshv:allowedTreeNode | Explain Me | Where Do I Come From?
meshv:annotation | Free-text information for indexers and catalogers concerning the use of the descriptor or qualifier. DUI: D005858 example: for Germany before 23 May 1949 & after 3 Oct 1990; for historical articles before & after 1949: Manual 36.11; BERLIN is also available| ```<Annotation>```
meshv:concept | Explain Me | Where Do I Come From?
meshv:dateCreated | Date when first entered in tHe MeSH data entry system. This time-stamp may be a year behind the dateEstablished. Upon conversion to a new MeSH maintenance system in 1999, a default value of 19990101 was supplied. DUI D022125 example:  20000622 |```<DateCreated>```
meshv:dateEstablished | Date when effective for use; set to YYYY0101 where YYYY = year of introduction to MeSH. DUI D023482 example: 20010101 |```<DateEstablished>```
meshv:dateRevised | Date when information in the record was last changed. DUI FILL ME IN . . . |```<DateRevised>```
meshv:entryVersion | Custom sort form used by indexers and catalogers. DUI D003880 example: DERMATOL |```<EntryVersion>```
meshv:historyNote | Free-text information that traces the concept in MeSH and is deemed helpful for the online searcher. Headings and entry terms are entered in upper case. Initial characters refer to the year in which the record was created in MeSH in its current form (i.e., with the same preferred term). A date in parentheses indicates the oldest creation date of terms, provisional headings (before 1975), or minor headings (before 1991), which are reflected in citations indexed to the record. Entries without a year date are early records, dating between 1963 and 1966. DUI D012441 example: 73(72) DUI D016239 example: 1991; use MEDLARS 1978-1990; for INDEX MEDICUS use MEDLINE 1979-2004|```<HistoryNote>```
meshv:isQualifierType | Explain Me | Where Do I Come From?
meshv:lexicalTag | Explain Me | Where Do I Come From?
meshv:onlineNote | Explain Me | Where Do I Come From?
meshv:preferredConcept | Explain Me | Where Do I Come From?
meshv:preferredTerm | Explain Me | Where Do I Come From?
meshv:printFlag | For NLM internal processing only. |```PrintFlagYN attribute on <Term>```
meshv:recordAuthorizer | Used for internal NLM processing only. |```<RecordAuthorizer>```
meshv:recordMaintainer | Used for internal NLM processing only. |```<RecordMaintainer>```
meshv:recordOriginator | Used for internal NLM processing only. |```<RecordOriginator>```
meshv:recordPreferredTerm | Explain Me | Where Do I Come From?
meshv:semanticType | Explain Me | Where Do I Come From?
meshv:sortVersion | Custom version of a term used to sort properly in a print product; format is all uppercase. DUI D002880 example:  FILL ME IN . . .  |```<Sort Version>```
meshv:term | Explain Me | Where Do I Come From?
meshv:treeNumber | Alpha-numeric string referring to location within a Descriptor or Qualifier hierarchy. Used for browsing the MeSH vocabulary and for inclusive searches by retrieval systems using MeSH. (Note that the Trees hierarchy is not represented using subelements. The hierarchy is represented by the Tree Number itself.) DUI D000163 example showing one of four 2014 MeSH tree locations: C02.839.040 |```<TreeNumber>```
skos:broader | Explain Me | Where Do I Come From?
skos:broaderTransitive | Explain Me | Where Do I Come From?
skos:prefLabel | Explain Me | Where Do I Come From?
skos:related | Explain Me | Where Do I Come From?
skos:scopeNote | Free-text narrative giving the scope and meaning (definition) of a concept. DUI D019644 example: Replacement of the hip joint. |```<ScopeNote>```
meshv:CASN1_label | Explain Me | Where Do I Come From?
meshv:allowableQualifier | Explain Me | Where Do I Come From?
meshv:hasDescriptor | Explain Me | Where Do I Come From?
meshv:hasQualifier | Explain Me | Where Do I Come From?
meshv:pharmacologicalAction | Explain Me | Where Do I Come From?
meshv:previousIndexing | Explain Me | Where Do I Come From?
meshv:publicMeSHNote | Explain Me | Where Do I Come From?
meshv:registryNumber | Explain Me | Where Do I Come From?
meshv:relatedRegistryNumber | Explain Me | Where Do I Come From?
meshv:runningHead | For internal NLM processing only (archaic). |```<RunningHead>```
meshv:seeAlso | Explain Me | Where Do I Come From?
meshv:thesaurusID | Explain Me | Where Do I Come From?
meshv:useInstead | Explain Me | Where Do I Come From?
skos:altLabel | Explain Me | Where Do I Come From?
meshv:SCRClass | Explain Me | Where Do I Come From?
meshv:frequency | Explain Me | Where Do I Come From?
meshv:indexingData | Explain Me | Where Do I Come From?
meshv:indexingDescriptor | Explain Me | Where Do I Come From?
meshv:indexingQualifier | Explain Me | Where Do I Come From?
meshv:isDescriptorStarred | Explain Me | Where Do I Come From?
meshv:isMappedToDescriptor | Explain Me | Where Do I Come From?
meshv:isMappedToQualifier | Explain Me | Where Do I Come From?
meshv:isQualifierStarred | Explain Me | Where Do I Come From?
meshv:mappedData | Explain Me | Where Do I Come From?
meshv:note | Explain Me | Where Do I Come From?
meshv:source | Explain Me | Where Do I Come From?
meshv:considerAlso | Explain Me | Where Do I Come From?
