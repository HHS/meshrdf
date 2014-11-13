---
title: Predicates
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below is a list of predicates in MeSH RDF.

{:.data-table-long .row-border .hover }
Predicate Name | Definition | Equivalent XML Data Element
-------------- | ---------- | ---------------------------
rdf:type | rdf:type is used to state that a resource is an instance of a class. For example, Ofloxacin (mesh:D015242) has an rdf:type of meshv:TopicalDescriptor. | N/A
rdfs:label | rdfs:label is used to provide a human-readable version of a resource's name. DUI D015242 example: Ofloxacin |```String```
skos:narrower | Explain Me | Where Do I Come From?
meshv:identifier | Explain Me | Where Do I Come From?
meshv:abbreviation | Two-letter, uppercase abbreviation for a Qualifier term. QUI Q000235 example: GE |```Abbreviation```
meshv:activeMeSHYear | MeSH year(s) in which the record was active since it was last modified. For example, a record not modified in the five years it has been in MeSH will have five occurrences. A record modified in the latest MeSH year will have one occurrence. DUI FILL ME IN |```ActiveMeSHYearList/Year```
meshv:allowedTreeNode | Name of a subcategory in the MeSH Trees indicating, that for most Descriptors in that subcategory, the allowed Qualifiers on the Descriptor include the Qualifier. This value does not impact Descriptors permitted with a given Qualifier, but is a statistical summary of Descriptors permitted with the Qualifier. DUI FILL ME IN |```TreeNodeAllowed```
meshv:annotation | Free-text information for indexers and catalogers concerning the use of the descriptor or qualifier. DUI: D005858 example: for Germany before 23 May 1949 & after 3 Oct 1990; for historical articles before & after 1949: Manual 36.11; BERLIN is also available|```Annotation```
meshv:concept | Explain Me | Where Do I Come From?
meshv:dateCreated | Date when first entered in tHe MeSH data entry system. This time-stamp may be a year behind the dateEstablished. Upon conversion to a new MeSH maintenance system in 1999, a default value of 19990101 was supplied. DUI D022125 example:  20000622 |```DateCreated/Year/Month/Day```
meshv:dateEstablished | Date when effective for use; set to YYYY0101 where YYYY = year of introduction to MeSH. DUI D023482 example: 20010101 |```DateEstablished/Year/Month/Day```
meshv:dateRevised | Date when information in the record was last changed. DUI FILL ME IN . . . |```DateRevised/Year/Month/Day```
meshv:entryVersion | Custom sort form used by indexers and catalogers. DUI D003880 example: DERMATOL |```EntryVersion```
meshv:historyNote | Free-text information that traces the concept in MeSH and is deemed helpful for the online searcher. Headings and entry terms are entered in upper case. Initial characters refer to the year in which the record was created in MeSH in its current form (i.e., with the same preferred term). A date in parentheses indicates the oldest creation date of terms, provisional headings (before 1975), or minor headings (before 1991), which are reflected in citations indexed to the record. Entries without a year date are early records, dating between 1963 and 1966. DUI D012441 example: 73(72) DUI D016239 example: 1991; use MEDLARS 1978-1990; for INDEX MEDICUS use MEDLINE 1979-2004|```HistoryNote```
meshv:isQualifierType | Currently all Qualifiers have QualifierType of "1".  |```QualifierRecord@QualifierType```
meshv:lexicalTag | A 3-letter value that indicates the lexical category.  Valid values with their meanings in parentheses are: ABB (Abbreviation); ABX (Embedded abbreviation); ACR (Acronym); ACX (Embedded acronym); EPO (Eponym); LAB (Lab number); NAM (Proper name); NON (None); and TRD (Trade name). Note that a Permuted Term will always have the same Lexical Tag value as the term from which it is generated. DUI FILL ME IN |```Term@LexicalTag```
meshv:onlineNote | Free-text information formerly intended to help the NLM online searcher. Superseded by a more detailed historyNote when onlineNote is not present. |```OnlineNote```
meshv:preferredConcept | The meaning of the term that names the record. The preferred concept is frequently a broader concept that includes narrower sub-concepts, but may also be one among several distinct concepts. In any case, the preferred concept is selected as the primary or most prominent representation among the concepts in the literature to be indexed by the record. DUI FILL ME IN  Not sure I got this right - difference between this XML vs. RecordPreferredTermYN and ConceptPreferredTermYN on <Term>? |```Concept@PreferredConceptYN```
meshv:preferredTerm | see above question of preferredConcept and recordPreferred Term FIX ME | Where Do I Come From?
meshv:printFlag | For NLM internal processing only. |```Term@PrintFlagYN```
meshv:recordAuthorizer | Used for internal NLM processing only. |```RecordAuthorizer```
meshv:recordMaintainer | Used for internal NLM processing only. |```RecordMaintainer```
meshv:recordOriginator | Used for internal NLM processing only. |```RecordOriginator```
meshv:recordPreferredTerm | Indicates that the term is the preferred term for the record. DUI FILL ME IN |```Term@RecordPreferredTermYN```
meshv:semanticType | One of approximately 140 categories in the UMLS Semantic Network that name properties of a concept. An example is Organic Chemical which is Type T109. DUI FILL ME IN. . . are the data the string or the type UI? |```SemanticType/SemanticTypeUI/SemanticTypeName```
meshv:sortVersion | Custom version of a term used to sort properly in a print product; format is all uppercase. DUI D002880 example:  FILL ME IN . . .  |```Sort Version```
meshv:term | Alpha-numeric string that is the basic unit of the MeSH vocabulary. Also functions as the name of a Descriptor and concept. DUI FILL ME IN . . . and where do I put this infor: The term itself is the <String> element. |```Term/TermUI/String```
meshv:treeNumber | Alpha-numeric string referring to location within a Descriptor or Qualifier hierarchy. Used for browsing the MeSH vocabulary and for inclusive searches by retrieval systems using MeSH. (Note that the Trees hierarchy is not represented using subelements. The hierarchy is represented by the Tree Number itself.) DUI D000163 example showing one of four 2014 MeSH tree locations: C02.839.040 |```TreeNumber```
meshv:broader | Explain Me | Where Do I Come From?
meshv:broaderTransitive | Explain Me | Where Do I Come From?
meshv:prefLabel | Explain Me | Where Do I Come From?
meshv:related | Explain Me | Where Do I Come From?
meshv:scopeNote | Free-text narrative giving the scope and meaning (definition) of a concept. DUI D019644 example: Replacement of the hip joint. |```ScopeNote```
meshv:casn1_label | Free-text of the Chemical Abstracts Type N1 Name which is the systematic name used in the Chemical Abstracts Chemical Substance and Formula Indexes. The systematic name is a unique name assigned to a chemical substance to represent its structure. First available for Descriptors in 1995. DUI D000082 example: Acetamide, N-(4-hydroxyphenyl)-|```CASN1Name```
meshv:allowableQualifier | A specific Qualifier allowed in combination with the Descriptor. DUI D000667 example: HOW DO I FILL THIS OUT? This is an XML envelope element; data are in QualifierUI, String, and Abbreviation; think I may have filled other elements out wrongly, too. . .???|```AllowableQualifier/QualiferUI/String/Abbreviation```
meshv:hasDescriptor | Explain Me | Where Do I Come From?
meshv:hasQualifier | Explain Me | Where Do I Come From?
meshv:pharmacologicalAction | Reference to a Descriptor describing observed biological activity of an exogenously administered chemical represented by a Descriptor or SCR. DUI D000667 example: Anti-Bacterial Agents |```PharmacologicalAction/DescriptorUI/String```
meshv:previousIndexing | Free-text information referring to Descriptors or Descriptor/Qualifier combinations that were used to index the concept in MEDLINE before the Descriptor was created. Intended to enable users of new Descriptors to find similar concepts indexed before the Descriptor was created. Includes dates of the format (YYYY) for a single year or (YYYY-YYYY) for a range of years. May include descriptive text referring to a group of Descriptors as "specifics". Data are not maintained when a Descriptor or Qualifier name changes.  DUI FILL ME IN. . . Also used for SCRs to refer to the Heading Mapped-to to which the SCR was previously mapped. CUI FILL ME IN . . .|```PreviousIndexing```
meshv:publicMeSHNote | Free-text information about the history of changes in the record that may be helpful to the user of the printed Index Medicus publication (ceased in 2005). This includes the date the record was created in MeSH, changes in the preferred term, earlier status as an SCR, etc. Unlike the History Note, MeSH terms reflect the MeSH vocabulary printed at that point in time, not as updated for online databases. In Descriptors, applies only to records having DescriptorClass value of 1. MeSH terms are in upper case. DUI FILL ME IN . . .|```PublicMeSHNote```
meshv:registryNumber | A unique identifier from one of these sources: Enzyme Commission (Example: EC 2.4.2.17; Example for Partial enzyme number: EC 1.4.3.-); Chemical Abstracts Service (CAS) (Example: 7004-12-8); FDA Substance Registration System Unique Identifier (UNII) in 10-character format (Example: R16CO5Y76E); or the value of 0 if no match is available from the previous sources. Used for Descriptors in the D Category Drugs and Chemicals and for SCRs. DUI FILL ME IN . . .|```RegistryNumber```
meshv:relatedRegistryNumber | The same type of value as the Registry Number but for concepts taht do not have their own Descriptor or Supplementary Concept Record. For example, these might be salts and/or stereoisomers of the parent compound. Most values correspond to a Registry Number value in a sub-concept in the record. A CAS number may be followed by note in parentheses which specifies the chemical relation between the Related Registry Number entry and the concept compound. Used for Descriptors in the D Category Drugs and Chemicals and for SCRs. DUI FILL ME IN . . . |```RelatedRegistryNumber```
meshv:runningHead | For internal NLM processing only (archaic). |```RunningHead```
meshv:seeAlso | Reference to a specific Descriptor to which a user is referred by a "see related" cross-reference. DUI D000009 example: Abdominal Wall | ```SeeRelatedDescriptor/DescriptorUI/String```
meshv:thesaurusID | Name of a Thesaurus in which the term occurs, including NLM (=MeSH). Includes year. DUI D000009 example: NLM (1966) | ```ThesaurusID```
meshv:useInstead | Explain Me | Where Do I Come From?
meshv:altLabel | Explain Me | Where Do I Come From?
meshv:SCRClass | One of three valid values that indicate the type of SCR record: 1=Chemical; 2=Protocol; or 3=Disease. CUI C017472: Chemical | ```SupplementalRecord@SCRClass```
meshv:frequency | Number of citations indexed with the SCR in MEDLINE/PubMed. Automatically updated monthly. CUI C012211 example: 745 |```Frequency```
meshv:indexConsiderAlso | Explain Me | Where Do I Come From?
meshv:mappedTo | Explain Me | Where Do I Come From?
meshv:indexingQualifier | Explain Me | Where Do I Come From?
meshv:mappedData | Explain Me | Where Do I Come From?
meshv:note | Free-text narrative giving information about the substance particularly its biological properties, but may include other information such as about the registryNumber. "structure" indicates that the structure of the chemical is given in the first Source. CUI C012211 example: growth inhibitor; RN given refers to ((L-Leu)-(S-(R*,S*)))-isomer; structure  |```Note```
meshv:source | Citation reference string in which the SCR concept was first found. Single occurrence if SCR record created since 1980; frequency reports total citations indexed with the term in MEDLINE/PubMed. Possible multiple occurrences if SCR record created prior to 1980; term not found on those citations in MEDLINE/PubMed. Number of multiple Source occurrences need to be added to Frequency count for grand total of citations to articles discussing the SCR. CUI C012211 example: Prog Biochem Pharmacol 11:24;1976 |```Source```
meshv:considerAlso | Free-text information that refers a user from a Descriptor to other terms which have related roots. DUI D006321 example: consider also terms at CARDI- and MYOCARDI- |```ConsiderAlso```
