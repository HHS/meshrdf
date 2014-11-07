---
title: Supplementary Concepts
layout: page
resource: true
categories:
- Data Model
---



### RDF Graph Diagram

![Qualifier RDF Graph Diagram](images/SCRs.png){: class="rdf-graph"}


### SPARQL

The RDF output above can be generated with the following
<span class='invoke-sparql'>SPARQL query</span>:


```sparql
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>
construct {
    mesh:C025735 ?p ?o .
    mesh:C025735 a ?scrClass .
    ?scrClass rdfs:subClassOf $scrSuperClass .
    mesh:C025735 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:C025735 meshv:recordPreferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .

    mesh:C012211 meshv:indexerConsiderAlso ?ica .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:C025735 ?p ?o .
    mesh:C025735 a ?scrClass .
    ?scrClass rdfs:subClassOf $scrSuperClass .
    mesh:C025735 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:C025735 meshv:recordPreferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .

    mesh:C012211 meshv:indexerConsiderAlso ?ica .
}
```

###MeSH RDF Data

```
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .

mesh:C025735  rdf:type  meshv:SCR_Chemical .
meshv:SCR_Chemical  rdfs:subClassOf meshv:SupplementaryConceptRecord .
mesh:C025735  rdfs:label  "Aeron" ;
              dcterms:identifier  "C025735" ;
              meshv:dateCreated "1980-10-03"^^xsd:date ;
              meshv:dateRevised "1986-04-03"^^xsd:date ;
              meshv:activeMeSHYear  "1989"^^xsd:date ,
                                    . . .
                                    "2014"^^xsd:date ;
              meshv:note  "contains scopolamine ... camphorate" ;
              meshv:frequency "4"^^xsd:int ;
              meshv:previousIndexing  "ATROPINE/*analogs (81-86)" ;
              meshv:preferredMappedTo mesh:D001286 ,
                                      mesh:D002164Q000031 ,
                                      mesh:D012602 ;
              meshv:mappedTo  mesh:D004338 ;
              meshv:source  "Vrach Delo 1980;(7):55" ;
              meshv:recordOriginator  "nbm" ;
              meshv:recordMaintainer  "standardr" ;
              meshv:recordAuthorizer  "nlm" ;
              meshv:preferredConcept  mesh:M0085468 ;
              meshv:recordPreferredTerm mesh:T115471 .
mesh:M0085468 rdf:type  meshv:Concept ;
              meshv:preferredTerm mesh:T115471 .
mesh:T115471  rdf:type  meshv:Term .

mesh:C012211  meshv:indexerConsiderAlso mesh:D000626Q000037 .
```

### MeSH XML

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

```xml
<SupplementalRecord SCRClass="1">
  <SupplementalRecordUI>C025735</SupplementalRecordUI>
  <SupplementalRecordName>
    <String>Aeron</String>
  </SupplementalRecordName>
  <DateCreated>
    <Year>1980</Year>
    <Month>10</Month>
    <Day>03</Day>
  </DateCreated>
  <DateRevised>
    <Year>1986</Year>
    <Month>04</Month>
    <Day>03</Day>
  </DateRevised>
  <ActiveMeSHYearList>
    <Year>1989</Year>
    ...
    <Year>2014</Year>
  </ActiveMeSHYearList>
  <Note>contains scopolamine camphorate mixture with (-)-atropine camphorate </Note>
  <Frequency>4</Frequency>
  <PreviousIndexingList>
    <PreviousIndexing>ATROPINE/*analogs (81-86)</PreviousIndexing>
  </PreviousIndexingList>
  <HeadingMappedToList>
    <HeadingMappedTo>
      <DescriptorReferredTo>
        <DescriptorUI>*D001286</DescriptorUI>
        <DescriptorName>
          <String>Atropine Derivatives</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </HeadingMappedTo>
    <HeadingMappedTo>
      <DescriptorReferredTo>
        <DescriptorUI>D002164</DescriptorUI>
        <DescriptorName>
          <String>Camphor</String>
        </DescriptorName>
      </DescriptorReferredTo>
      <QualifierReferredTo>
        <QualifierUI>*Q000031</QualifierUI>
        <QualifierName>
          <String>analogs &amp; derivatives</String>
        </QualifierName>
      </QualifierReferredTo>
    </HeadingMappedTo>
    <HeadingMappedTo>
      <DescriptorReferredTo>
        <DescriptorUI>D004338</DescriptorUI>
        <DescriptorName>
          <String>Drug Combinations</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </HeadingMappedTo>
    <HeadingMappedTo>
      <DescriptorReferredTo>
        <DescriptorUI>*D012602</DescriptorUI>
        <DescriptorName>
          <String>Scopolamine Derivatives</String>
        </DescriptorName>
      </DescriptorReferredTo>
    </HeadingMappedTo>
  </HeadingMappedToList>
  <SourceList>
    <Source>Vrach Delo 1980;(7):55</Source>
  </SourceList>
  <RecordOriginatorsList>
    <RecordOriginator>nbm</RecordOriginator>
    <RecordMaintainer>standardr</RecordMaintainer>
    <RecordAuthorizer>nlm</RecordAuthorizer>
  </RecordOriginatorsList>
  <ConceptList>
    <Concept PreferredConceptYN="Y">
      <ConceptUI>M0085468</ConceptUI>
      <ConceptName>
        <String>Aeron</String>
      </ConceptName>
      <RegistryNumber>72539-79-8</RegistryNumber>
      <TermList>
        <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="Y"
          RecordPreferredTermYN="Y">
          <TermUI>T115471</TermUI>
          <String>Aeron</String>
          <ThesaurusIDlist>
            <ThesaurusID>NLM (1980)</ThesaurusID>
          </ThesaurusIDlist>
        </Term>
      </TermList>
    </Concept>
  </ConceptList>
</SupplementalRecord>
...
<SupplementalRecord SCRClass="1">
  <SupplementalRecordUI>C012211</SupplementalRecordUI>
  <SupplementalRecordName>
    <String>ubenimex</String>
  </SupplementalRecordName>
  ...
  <IndexingInformationList>
    <IndexingInformation>
      <DescriptorReferredTo>
        <DescriptorUI>D000626</DescriptorUI>
        <DescriptorName>
          <String>Aminopeptidases</String>
        </DescriptorName>
      </DescriptorReferredTo>
      <QualifierReferredTo>
        <QualifierUI>Q000037</QualifierUI>
        <QualifierName>
          <String>antagonists &amp; inhibitors</String>
        </QualifierName>
      </QualifierReferredTo>
    </IndexingInformation>
  </IndexingInformationList>
  ...
</SupplementalRecord>
```

###Notes

There are three possible values for the *SCRClass* attribute (see the [XML
documentation](http://www.nlm.nih.gov/mesh/xml_data_elements.html#SCRClass), which result in three
rdfs:Classes:

* 1 - meshv:SCR_Chemical
* 2 - meshv:SCR_Protocol
* 3 - meshv:SCR_Disease

Each of these is an rdfs:subClassOf meshv:SupplementaryConceptRecord.

