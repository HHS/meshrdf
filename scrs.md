---
title: Supplementary Concepts
layout: page
resource: true
categories:
- Data Model
---



### RDF Graph Diagram

![Qualifier RDF Graph Diagram](images/SCRs.png){: class="rdf-graph"}

### meshv:SupplementaryConcept - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:SupplementaryConcept properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-standard .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:SupplementaryConcept | rdf:type | meshv:Protocol
meshv:SupplementaryConcept | rdf:type | meshv:SupplementaryConcept
meshv:SupplementaryConcept | rdf:type | meshv:RareDisease
meshv:SupplementaryConcept | rdf:type | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:concept | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:concept | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:concept | meshv:Protocol
meshv:SupplementaryConcept | meshv:concept | meshv:RareDisease
meshv:SupplementaryConcept | meshv:preferredConcept | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:preferredConcept | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:preferredConcept | meshv:Protocol
meshv:SupplementaryConcept | meshv:preferredConcept | meshv:RareDisease
meshv:SupplementaryConcept | meshv:recordPreferredTerm | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:recordPreferredTerm | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:recordPreferredTerm | meshv:Protocol
meshv:SupplementaryConcept | meshv:recordPreferredTerm | meshv:RareDisease
meshv:SupplementaryConcept | meshv:pharmacologicalAction | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:pharmacologicalAction | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:pharmacologicalAction | meshv:Protocol
meshv:SupplementaryConcept | meshv:indexerConsiderAlso | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:indexerConsiderAlso | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:indexerConsiderAlso | meshv:Protocol
meshv:SupplementaryConcept | meshv:indexerConsiderAlso | meshv:RareDisease
meshv:SupplementaryConcept | meshv:mappedTo | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:mappedTo | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:mappedTo | meshv:Protocol
meshv:SupplementaryConcept | meshv:mappedTo | meshv:RareDisease
meshv:SupplementaryConcept | meshv:preferredMappedTo | meshv:RegularSubstance
meshv:SupplementaryConcept | meshv:preferredMappedTo | meshv:SupplementaryConcept
meshv:SupplementaryConcept | meshv:preferredMappedTo | meshv:RareDisease
meshv:SupplementaryConcept | meshv:preferredMappedTo | meshv:Protocol

</div>

{: #tabs-2}
<div>

{:.data-table-standard .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
N/A | N/A | N/A

</div>

{: #tabs-3}
<div>
{:.data-table-standard .row-border .hover}
Subject | Predicate
------- | ---------
meshv:SupplementaryConcept | rdfs:label
meshv:SupplementaryConcept | dcterms:identifier
meshv:SupplementaryConcept | meshv:activeMeSHYear
meshv:SupplementaryConcept | meshv:dateCreated
meshv:SupplementaryConcept | meshv:dateRevised
meshv:SupplementaryConcept | meshv:recordAuthorizer
meshv:SupplementaryConcept | meshv:recordMaintainer
meshv:SupplementaryConcept | meshv:recordOriginator
meshv:SupplementaryConcept | meshv:previousIndexing
meshv:SupplementaryConcept | meshv:frequency
meshv:SupplementaryConcept | meshv:note
meshv:SupplementaryConcept | meshv:source

</div>
</div>

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
<http://id.nlm.nih.gov/mesh/C012211>
        <http://id.nlm.nih.gov/mesh/vocab#indexerConsiderAlso>
                <http://id.nlm.nih.gov/mesh/D000626Q000037> .

<http://id.nlm.nih.gov/mesh/C025735>
        a       <http://id.nlm.nih.gov/mesh/vocab#RegularSubstance> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "Aeron" ;
        <http://id.nlm.nih.gov/mesh/vocab#activeMeSHYear>
                "1989-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ,
                ...
                "2014-01-01"^^<http://www.w3.org/2001/XMLSchema#date>;
        <http://id.nlm.nih.gov/mesh/vocab#dateCreated>
                "1980-10-03"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#dateRevised>
                "1986-04-03"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#frequency>
                "4"^^<http://www.w3.org/2001/XMLSchema#int> ;
        <http://id.nlm.nih.gov/mesh/vocab#mappedTo>
                <http://id.nlm.nih.gov/mesh/D004338> ;
        <http://id.nlm.nih.gov/mesh/vocab#note>
                "contains scopolamine camphorate mixture with (-)-atropine camphorate" ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredConcept>
                <http://id.nlm.nih.gov/mesh/M0085468> ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredMappedTo>
                <http://id.nlm.nih.gov/mesh/D012602> , 
                <http://id.nlm.nih.gov/mesh/D002164Q000031> , 
                <http://id.nlm.nih.gov/mesh/D001286> ;
        <http://id.nlm.nih.gov/mesh/vocab#previousIndexing>
                "ATROPINE/*analogs (81-86)" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordAuthorizer>
                "nlm" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordMaintainer>
                "standardr" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordOriginator>
                "nbm" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordPreferredTerm>
                <http://id.nlm.nih.gov/mesh/T115471> ;
        <http://id.nlm.nih.gov/mesh/vocab#source>
                "Vrach Delo 1980;(7):55" ;
        <http://purl.org/dc/terms/identifier>
                "C025735" .

<http://id.nlm.nih.gov/mesh/M0085468>
        a       <http://id.nlm.nih.gov/mesh/vocab#Concept> ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredTerm>
                <http://id.nlm.nih.gov/mesh/T115471> .

<http://id.nlm.nih.gov/mesh/vocab#RegularSubstance>
        <http://www.w3.org/2000/01/rdf-schema#subClassOf>
                <http://id.nlm.nih.gov/mesh/vocab#SupplementaryConcept> .

<http://id.nlm.nih.gov/mesh/T115471>
        a       <http://id.nlm.nih.gov/mesh/vocab#Term> .
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

