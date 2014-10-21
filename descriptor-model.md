---
title: Descriptors
layout: page
resource: true
categories:
- Data Model
---

A Descriptor is a class in MeSH RDF. Also known as Main Headings, Descriptors are used to index citations in NLM's MEDLINE database, for cataloging of publications, and other databases, and are searchable in PubMed as [MH]. Most Descriptors indicate the subject of a resource. Some indicate publication types or geographic subdivisions. For more information about Descriptors, visit NLM's [MeSH Record Types page](http://www.nlm.nih.gov/mesh/intro_record_types.html). 
  
###RDF Graph Diagram
{: class="inline-header"}
The following RDF graph diagram shows a fairly typical topical descriptor (D015242, Ofloxacin) and its relationships. For reference, see [Ofloxacin in the MeSH browser](https://www.nlm.nih.gov/cgi/mesh/2014/MB_cgi?term=ofloxacin). 

![Descriptor RDF Graph Diagram](images/BasicConversionLiterals.png){: style="width: 500px"}
  
###Classes
{: class="inline-header"}
In MeSH RDF, Ofloxacin is an instance of the class, meshv:TopicalDescriptor, one of four subclasses of meshv:Descriptor. The subclasses of meshv:Descriptor are:

*  meshv:TopicalDescriptor
*  meshv:PublicationType
*  meshv:CheckTag
*  meshv:GeographicalDescriptor

###SPARQL
{: class="inline-header"}
The following [SPARQL query](http://iddev.nlm.nih.gov/mesh/sparql?query=PREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0A%0D%0ASELECT+distinct+%3Fp+%3Fo%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh2014%3E%0D%0AWHERE+%7B%0D%0A++mesh%3AD015242+%3Fp+%3Fo%0D%0A%7D&render=HTML&inference=true&limit=50&offset=0#lodestart-sparql-results) will produce the predicates and objects of Ofloxacin. 

{: class="sample-queries"}
```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
CONSTRUCT { mesh:D015242 ?p ?o . }
FROM <http://id.nlm.nih.gov/mesh2014>
WHERE {
  mesh:D015242 ?p ?o .
}
```

###MeSH RDF Data
{: class="inline-header"}
Here is the truncated output of the above query in [N3 format](http://iddev.nlm.nih.gov/mesh/servlet/query?query=PREFIX%20rdf%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX%20rdfs%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX%20owl%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX%20xsd%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX%20dc%3A%20%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Felements%2F1.1%2F%3E%0D%0APREFIX%20dcterms%3A%20%3Chttp%3A%2F%2Fpurl.org%2Fdc%2Fterms%2F%3E%0D%0APREFIX%20dbpedia2%3A%20%3Chttp%3A%2F%2Fdbpedia.org%2Fproperty%2F%3E%0D%0APREFIX%20dbpedia%3A%20%3Chttp%3A%2F%2Fdbpedia.org%2F%3E%0D%0APREFIX%20foaf%3A%20%3Chttp%3A%2F%2Fxmlns.com%2Ffoaf%2F0.1%2F%3E%0D%0APREFIX%20skos%3A%20%3Chttp%3A%2F%2Fwww.w3.org%2F2004%2F02%2Fskos%2Fcore%23%3E%0D%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0A%0D%0ACONSTRUCT%20%7B%20mesh%3AD015242%20%3Fp%20%3Fo%20.%20%7D%0D%0AFROM%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh2014%3E%0D%0AWHERE%20%7B%0D%0A%20%20mesh%3AD015242%20%3Fp%20%3Fo%20.%0D%0A%7D&format=N3):

```
<http://id.nlm.nih.gov/mesh/D015242>
        a       <http://id.nlm.nih.gov/mesh/vocab#TopicalDescriptor> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "Ofloxacin" ;
        <http://id.nlm.nih.gov/mesh/vocab#activeMeSHYear>
                "2014-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#allowableQualifier>
                <http://id.nlm.nih.gov/mesh/Q000008> , 
                <http://id.nlm.nih.gov/mesh/Q000009> , 
                <http://id.nlm.nih.gov/mesh/Q000031> , 
                ...
        <http://id.nlm.nih.gov/mesh/vocab#concept>
                <http://id.nlm.nih.gov/mesh/M0023430> , 
                <http://id.nlm.nih.gov/mesh/M0333651> , 
                <http://id.nlm.nih.gov/mesh/M0023432> ,
                ...
        <http://id.nlm.nih.gov/mesh/vocab#dateCreated>
                "2014-06-26"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#dateEstablished>
                "1989-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#dateRevised>
                "2013-07-08"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#historyNote>
                "89" ;
        <http://id.nlm.nih.gov/mesh/vocab#pharmacologicalAction>
                <http://id.nlm.nih.gov/mesh/D000900> , 
                <http://id.nlm.nih.gov/mesh/D000892> , 
                <http://id.nlm.nih.gov/mesh/D059005> ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredConcept>
                <http://id.nlm.nih.gov/mesh/M0023430> ;
        <http://id.nlm.nih.gov/mesh/vocab#previousIndexing>
                "Anti-Infective Agents, Urinary (1981-1988)" , 
                "Anti-Infective Agents (1981-1988)" , 
                "Oxazines (1981-1988)" ;
        <http://id.nlm.nih.gov/mesh/vocab#publicMeSHNote>
                "89" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordAuthorizer>
                "chodan" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordMaintainer>
                "pashj" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordOriginator>
                "standardr" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordPreferredTerm>
                <http://id.nlm.nih.gov/mesh/T044624> ;
        <http://id.nlm.nih.gov/mesh/vocab#treeNumber>
                <http://id.nlm.nih.gov/mesh/D03.438.810.835.322.500> ;
        <http://purl.org/dc/terms/identifier>
                "D015242" ;
        <http://www.w3.org/2004/02/skos/core#broader>
                <http://id.nlm.nih.gov/mesh/D024841> .
```

###MeSH XML
{: class="inline-header"}
The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF data above to the truncated MeSH XML below. 

```xml
<DescriptorRecord DescriptorClass = "1">
  <DescriptorUI>D015242</DescriptorUI>
  <DescriptorName>
   <String>Ofloxacin</String>
  </DescriptorName>
  <DateCreated>
   <Year>2014</Year>
   <Month>06</Month>
   <Day>26</Day>
  </DateCreated>
  <DateRevised>
   <Year>2013</Year>
   <Month>07</Month>
   <Day>08</Day>
  </DateRevised>
  <DateEstablished>
   <Year>1989</Year>
   <Month>01</Month>
   <Day>01</Day>
  </DateEstablished>
  <ActiveMeSHYearList>
   <Year>2014</Year>
  </ActiveMeSHYearList>
  <AllowableQualifiersList>
   <AllowableQualifier>
    <QualifierReferredTo>
     <QualifierUI>Q000008</QualifierUI>
      <QualifierName>
      <String>administration &amp; dosage</String>
      </QualifierName>
    </QualifierReferredTo>
    <Abbreviation>AD</Abbreviation>
   </AllowableQualifier>
   <AllowableQualifier>
    <QualifierReferredTo>
     <QualifierUI>Q000009</QualifierUI>
      <QualifierName>
      <String>adverse effects</String>
      </QualifierName>
    </QualifierReferredTo>
    <Abbreviation>AE</Abbreviation>
   </AllowableQualifier>
   <AllowableQualifier>
    <QualifierReferredTo>
     <QualifierUI>Q000031</QualifierUI>
      <QualifierName>
      <String>analogs &amp; derivatives</String>
      </QualifierName>
    </QualifierReferredTo>
    <Abbreviation>AA</Abbreviation>
   </AllowableQualifier>
   ...
  </AllowableQualifiersList>
  <HistoryNote>89
  </HistoryNote>
  <PublicMeSHNote>89
  </PublicMeSHNote>
  <PreviousIndexingList>
   <PreviousIndexing>Anti-Infective Agents (1981-1988)</PreviousIndexing>
   <PreviousIndexing>Anti-Infective Agents, Urinary (1981-1988)</PreviousIndexing>
   <PreviousIndexing>Oxazines (1981-1988)</PreviousIndexing>
  </PreviousIndexingList>
    <PharmacologicalActionList>
     <PharmacologicalAction>
      <DescriptorReferredTo>
       <DescriptorUI>D000892</DescriptorUI>
        <DescriptorName>
         <String>Anti-Infective Agents, Urinary</String>
        </DescriptorName>
      </DescriptorReferredTo>
     </PharmacologicalAction>
     <PharmacologicalAction>
      <DescriptorReferredTo>
       <DescriptorUI>D000900</DescriptorUI>
        <DescriptorName>
         <String>Anti-Bacterial Agents</String>
        </DescriptorName>
      </DescriptorReferredTo>
     </PharmacologicalAction>
     <PharmacologicalAction>
      <DescriptorReferredTo>
       <DescriptorUI>D059005</DescriptorUI>
        <DescriptorName>
         <String>Topoisomerase II Inhibitors</String>
        </DescriptorName>
      </DescriptorReferredTo>
     </PharmacologicalAction>
    </PharmacologicalActionList>
  <TreeNumberList>
   <TreeNumber>D03.438.810.835.322.500</TreeNumber>
  </TreeNumberList>
  <RecordOriginatorsList>
   <RecordOriginator>standardr</RecordOriginator>
   <RecordMaintainer>pashj</RecordMaintainer>
   <RecordAuthorizer>chodan</RecordAuthorizer>
  </RecordOriginatorsList>
  <ConceptList>
   <Concept PreferredConceptYN="Y">
    <ConceptUI>M0023430</ConceptUI>
    <ConceptName>
     <String>Ofloxacin</String>
    </ConceptName>
   </Concept>
   ...
   <Concept PreferredConceptYN="N">
    <ConceptUI>M0333651</ConceptUI>
    <ConceptName>
     <String>Hoe-280</String>
    </ConceptName>
   </Concept>
   ...
   <Concept PreferredConceptYN="N">
    <ConceptUI>M0023432</ConceptUI>
    <ConceptName>
     <String>Tarivid</String>
    </ConceptName>
   </Concept>
   ...
  </ConceptList>
 </DescriptorRecord>

```
