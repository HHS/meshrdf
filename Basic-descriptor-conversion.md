Below is an example of how the XML record for D015242, Ofloxacin, is converted into XML.  Both the XML and the RDF are elided in the same way.

## XML

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
      ...
    </QualifierReferredTo>
    <Abbreviation>AD</Abbreviation>
   </AllowableQualifier>
    ...
   <AllowableQualifier>
    <QualifierReferredTo>
     <QualifierUI>Q000819</QualifierUI>
      ...
    </QualifierReferredTo>
    <Abbreviation>AG</Abbreviation>
   </AllowableQualifier>
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
        ...
      </DescriptorReferredTo>
     </PharmacologicalAction>
     <PharmacologicalAction>
      <DescriptorReferredTo>
       <DescriptorUI>D059005</DescriptorUI>
        ...
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
     ...
   </Concept>
   <Concept PreferredConceptYN="N">
    <ConceptUI>M0329515</ConceptUI>
     ...
   </Concept>
  </ConceptList>
 </DescriptorRecord>
```

## RDF (turtle format)

@prefix rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix mesh:    <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:   <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdfs:    <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms: <http://purl.org/dc/terms/> .

mesh:D015242 a  meshv:Descriptor .
  rdfs:label  "Ofloxacin" .
  dcterms:identifier  "D015242" ;
  meshv:descriptorClass "1" ;
  meshv:dateCreated "2014-06-26" ;
  meshv:dateRevised "2013-07-08" ;
  meshv:dateEstablished "1989-01-01" ;
  meshv:activeMeSHYear  "2014" ;
  meshv:allowableQualifier  mesh:Q000008 ,
    ...
    mesh:Q000819 ;
  meshv:historyNote "89\n  " ;
  meshv:publicMeSHNote  "89\n  " ;
  meshv:previousIndexing  "Anti-Infective Agents, Urinary (1981-1988)" ,
    ...
    "Oxazines (1981-1988)" .
  meshv:pharmacologicalAction mesh:D000892 ,
    ...
    mesh:D059005 ;
  meshv:treeNumber  "D03.438.810.835.322.500" ;
  meshv:recordOriginator  "standardr" ;
  meshv:recordMaintainer  "pashj" ;
  meshv:recordAuthorizer  "chodan" ;
  meshv:concept mesh:M0023430 ,
    ...
    mesh:M0329515 ;

## Generating the RDF

The RDF output above can be generated with the following SPARQL query, after substituting the current values for the name of the graph and so forth:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

CONSTRUCT { mesh:D015242 ?p ?o . }
from <http://chrismaloney.org/mesh>
where {
     mesh:D015242 ?p ?o .
}
```

At the time of this writing, you can see the results dynamically from [this
url](http://jatspan.org:8890/sparql?query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0A%0ACONSTRUCT%20%7B%20mesh%3AD015242%20%3Fp%20%3Fo%20.%20%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Awhere%20%7B%0A%20%20%20%20%20mesh%3AD015242%20%3Fp%20%3Fo%20.%0A%7D%0A&format=TURTLE)