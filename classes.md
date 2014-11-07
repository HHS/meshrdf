---
title: Classes
layout: page
resource: true
categories:
- Cheat Sheets
---
The table below is a list of classes in MeSH RDF.

{:.data-table-standard .row-border .hover}
Class Name | Parent Class | Definition | Equivalent XML Data Element
---------- | ---------- | ------------ | ---------------------------
meshv:AllowedDescriptorQualifierPair  | meshv:DescriptorQualifierPair | MeSH RDF creates URIs based on allowable descriptor-qualifier pairs (such as [D000236Q000235](http://id.nlm.nih.gov/mesh/D000236Q000235.html){:target="_blank"}). | ```<EntryCombination>/<ECIN>```
meshv:CheckTag | meshv:Descriptor | There are only 2 Descriptors that are members of the class meshv:CheckTag - D005260 'Male' and D008297 'Female'.  These two Descriptors do not have tree numbers.  Please see the [MEDLINE Indexing Online Training Course for the complete list](http://www.nlm.nih.gov/bsd/indexing/training/CHK_010.html){:target="_blank"}. |  ```<DescriptorRecord DescriptorClass = "3">```
meshv:Concept | N/A | MeSH concepts contain terms that have the same meaning. meshv:Concept identifiers begin with 'M' such as [M0000013 - 'Congenital Abnormalities'](http://id.nlm.nih.gov/mesh/M0000013.html){:target="_blank"}. |  ```<Concept>```
meshv:DisallowedDescriptorQualifierPair | meshv:DescriptorQualifierPair | A reference to a specific Qualifier that is not to be used with the Descriptor in indexing, such as ['Abdomen/radiography'](http://id.nlm.nih.gov/mesh/D000005Q000530.html){:target="_blank"}. | ```<EntryCombination>/<ECOUT>```
meshv:GeographicalDescriptor | meshv:Descriptor | meshv:GeographicalDescriptors are places or regions of the world, such as [D001061 - 'Appalachian Region'](http://id.nlm.nih.gov/mesh/D001061.html){:target="_blank"}. |  ```<DescriptorRecord DescriptorClass = "4">```
meshv:PublicationType | meshv:Descriptor | [Publication Types](http://www.nlm.nih.gov/mesh/pubtypes.html){:target="_blank"} (PTs) describe what an item being indexed is as opposed to what it is about. All MeSH PTs are in the 'V' tree. | ```<DescriptorRecord DescriptorClass = "2">```
meshv:Protocol | meshv:SupplementaryConcept | MeSH protocols are therapies in the domain of cancer treatment, such as [ABVD Protocol](http://id.nlm.nih.gov/mesh/C104696.html){:target="_blank"}. |  ```<SupplementalRecord SCRClass="2">```
meshv:Qualifier | N/A  | Also known as Subheadings, these provide context to the use of a MeSH Heading. See [drug effects](http://id.nlm.nih.gov/mesh/Q000187.html){:target="_blank"} for an example. |  ```<QualifierRecord>```
meshv:RareDisease | meshv:SupplementaryConcept | Rare Diseases were originally brought into MeSH from a list maintained by the Office of Rare Diseases Research. See [Hepatic Fibrosis, Congenital](http://iddev.nlm.nih.gov/mesh/C562378.html){:target="_blank"} for an example.| ```<SupplementalRecord SCRClass="3">```
meshv:RegularSubstance | meshv:SupplementaryConcept | These are chemicals, drugs, enzymes, vitamins, etc. See [C011657 - 'Andrenosterone'](http://id.nlm.nih.gov/mesh/C011657.html){:target="_blank"} for an example.  |  ```<SupplementalRecord SCRClass="1">```
meshv:SemanticType | N/A  | A semantic type provides broad categorization for instances meshv:Concept classes.  See [T017 - 'Anatomical Structure'](http://id.nlm.nih.gov/mesh/T017.html){:target="_blank"} for an example. | ```<SemanticType>```
meshv:Term | N/A | MeSH terms provide names for MeSH concepts.  Terms have 'T' identifiers, and are considered either preferred or lexical variants, such as ['Congenital Abnormailities'](http://id.nlm.nih.gov/mesh/T000029.html){:target="_blank"}. | ```<Term>```
meshv:TopicalDescriptor | meshv:Descriptor |  Topical Descriptors indicate the subject of an indexed item such as a journal article.  See [D063926 - 'Drug Hypersensitivity Syndrome'](http://id.nlm.nih.gov/mesh/D063926.html){:target="_blank"} for an example. | ```<DescriptorRecord DescriptorClass = "1">```
meshv:TreeNumber | N/A | Tree Numbers are used to organize MeSH Descriptors in a subsumptive manner. For example, every Descriptor treed under [C04 - 'Neoplasms'](http://id.nlm.nih.gov/mesh/C04.html){:target="_blank"} would be about something more specific than 'Neoplasms'. | ```<TreeNumber>```