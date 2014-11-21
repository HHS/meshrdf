---
title: Class Definitions
layout: page
resource: true
categories:
- Cheat Sheets
---
The table below is a list of classes in MeSH RDF.

{:.data-table-long .row-border .hover}
Class Name | Parent Class | Definition | Equivalent XML Data Element
---------- | ---------- | ------------ | ---------------------------
meshv:AllowedDescriptorQualifierPair  | meshv:DescriptorQualifierPair | A combined MeSH descriptor and qualifier, where the pairing is allowed by MeSH rules.  These URIs are a mash up of the descriptor and qualifier identifiers  (such as [D000236Q000235](http://id.nlm.nih.gov/mesh/D000236Q000235.html){:target="_blank"}). | ```EntryCombination/ECIN```
meshv:CheckTag | meshv:Descriptor | A special class of descriptor singled out because they are so frequently applied to biomedical literature.  There are only 2 Descriptors that are members of the class meshv:CheckTag - D005260 'Male' and D008297 'Female'.  These two Descriptors do not have tree numbers.  Please see the [MEDLINE Indexing Online Training Course for the complete list](http://www.nlm.nih.gov/bsd/indexing/training/CHK_010.html){:target="_blank"}. |  ```DescriptorRecord @DescriptorClass = "3"```
meshv:Concept | N/A | MeSH concepts are meanings. Many MeSH concepts contain synonymous terms. meshv:Concept identifiers begin with 'M' such as [M0000013 - 'Congenital Abnormalities'](http://id.nlm.nih.gov/mesh/M0000013.html){:target="_blank"}. See the [MeSH concept structure page](http://www.nlm.nih.gov/mesh/concept_structure.html){:target="_blank"} for more information. |  ```Concept```
meshv:Descriptor * | N/A | MeSH Descriptors are a cluster of one or more concepts used to describe what a publication is about.  meshv:Descriptor is the parent class of meshv:TopicalDescriptor, meshv:GeographicDescriptor, meshv:PublicationType, and meshv:CheckTag. | ```DescriptorRecord```
meshv:DescriptorQualifierPair * | N/A | A combined MeSH descriptor and qualifier pair.  Allowed pairs (according to MeSH rules) belong to the class meshv:AllowedDescriptorQualifierPair.  Disallowed pairs belong to the class meshv:DisallowedDescriptorQualifierPair. | ```EntryCombination```
meshv:DisallowedDescriptorQualifierPair | meshv:DescriptorQualifierPair | A combined MeSH descriptor and qualifier where the pairing is not allowed by MeSH rules, such as ['Abdomen/radiography'](http://id.nlm.nih.gov/mesh/D000005Q000530.html){:target="_blank"}. | ```EntryCombination/ECOUT```
meshv:GeographicalDescriptor | meshv:Descriptor | A descriptor that references places or regions of the world, such as [D001061 - 'Appalachian Region'](http://id.nlm.nih.gov/mesh/D001061.html){:target="_blank"}. |  ```DescriptorRecord @DescriptorClass = "4"```
meshv:PublicationType | meshv:Descriptor | [A special class of descriptor](http://www.nlm.nih.gov/mesh/pubtypes.html){:target="_blank"} that describes what type of publication a resource is as opposed to what it is about. All MeSH Publication Types are in the 'V' tree. | ```DescriptorRecord @DescriptorClass = "2"```
meshv:SCR_Protocol | meshv:SupplementaryConceptRecord | MeSH protocols are therapies in the domain of cancer treatment, such as [ABVD Protocol](http://id.nlm.nih.gov/mesh/C104696.html){:target="_blank"}. |  ```SupplementalRecord SCRClass="2"```
meshv:Qualifier | N/A  | Also known as Subheadings, these provide context to the use of a MeSH Heading. See [heart - drug effects](http://id.nlm.nih.gov/mesh/D006321Q000187.html){:target="_blank"} for an example. |  ```QualifierRecord```
meshv:SCR_Disease | meshv:SupplementaryConceptRecord | Rare Diseases were originally brought into MeSH from a list maintained by the Office of Rare Diseases Research. See [Hepatic Fibrosis, Congenital](http://id.nlm.nih.gov/mesh/C562378.html){:target="_blank"} for an example.| ```SupplementalRecord @SCRClass="3"```
meshv:RegularSubstance | meshv:SupplementaryConceptRecord | These are chemicals, drugs, enzymes, vitamins, etc., such as [C011657 - 'Andrenosterone'](http://id.nlm.nih.gov/mesh/C011657.html){:target="_blank"}.  |  ```SupplementalRecord @SCRClass="1"```
meshv:SemanticType | N/A  | A [semantic type](http://www.nlm.nih.gov/research/umls/META3_current_semantic_types.html){:target="_blank"} provides broad categorization for meshv:Concept classes, such as 'Disease or Syndrome', 'Medical Device', etc.  | ```SemanticType```
meshv:SupplementaryConceptRecord* | N/A | Supplementary Concepts are created in MeSH to aid in searching the large volume of mainly chemicals and drugs.  meshv:SupplementaryConceptRecord has three sub-classes: meshv:RegularSubstance, meshv:SCR_Protocol, and meshv:SCR_Disease. | ```SupplementalRecord```
meshv:Term | N/A | MeSH terms provide synonymous names for MeSH concepts.  Terms have 'T' identifiers, and are considered either preferred or lexical variants, such as ['Congenital Abnormalities'](http://id.nlm.nih.gov/mesh/T000029.html){:target="_blank"} as opposed to 'Abnormality, Congenital'. | ```Term```
meshv:TopicalDescriptor | meshv:Descriptor |  Topical Descriptors indicate the subject of an indexed item such as a journal article.  See [D063926 - 'Drug Hypersensitivity Syndrome'](http://id.nlm.nih.gov/mesh/D063926.html){:target="_blank"} for an example. | ```DescriptorRecord @DescriptorClass = "1"```
meshv:TreeNumber | N/A | Tree Numbers are used to organize MeSH Descriptors in a broader-than/narrower-than manner. For example, every Descriptor treed under [C04 - 'Neoplasms'](http://id.nlm.nih.gov/mesh/C04.html){:target="_blank"} would be about something more specific than 'Neoplasms'. | ```TreeNumber```


&#42; Indicates this is a super class. Use RDF inferencing when querying these to retrieve sub-classes.
