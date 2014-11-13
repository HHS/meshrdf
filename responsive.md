---
title: Responsive
layout: page-responsive
resource: false
categories:
- Data Model
---

A Qualifier (also known as a Subheading) is a class in MeSH RDF with the name [meshv:Qualifier](http://id.nlm.nih.gov/mesh/vocab#Qualifier){: target="_blank"}.
Qualifiers are used to give additional context to a Descriptor.  MeSH has rules governing which Qualifiers can be used with a given Descriptor, as well as
which Qualifers cannot be used with a given Descriptor.  MeSH RDF has minted Descriptor-Qualifier Pair URIs for both Allowed and Disallowed [Descriptor-Qualifier Pairs](http://hhs.github.io/meshrdf/descriptor-qualifier-pairs.html).
Qualifiers each have tree numbers and are [hierarchically arranged](http://www.nlm.nih.gov/mesh/subhierarchy.html){: target="_blank"}.

### RDF Graph Diagram

![Qualifier RDF Graph Diagram](images/Qualifiers.png){: class="rdf-graph"}

### meshv:Qualifier - Relations and Properties

{::options parse_block_html="true" /}

{: #tabs}
<div>

*  [Relations to other classes (as subject)](#tabs-1)
*  [Relations to other classes (as object)](#tabs-2)
*  [meshv:Qualifier properties](#tabs-3)

{: #tabs-1}
<div>

{:.data-table-standard .row-border .hover }
Subject | Predicate | Object
------- | --------- | -------
meshv:Qualifier | rdf:type | rdfs:Class
meshv:Qualifier | meshv:allowedTreeNode | meshv:TreeNumber
meshv:Qualifier | meshv:concept | meshv:Concept
meshv:Qualifier | meshv:preferredConcept | meshv:Concept
meshv:Qualifier | meshv:recordPreferredTerm | meshv:Term
meshv:Qualifier | meshv:treeNumber | meshv:TreeNumber
meshv:Qualifier | skos:broader | meshv:Qualifier

</div>

{: #tabs-2}
<div>

{:.data-table-standard .row-border .hover}
Subject | Predicate | Object
------- | --------- | -------
meshv:TopicalDescriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:Descriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:GeographicalDescriptor | meshv:allowableQualifier | meshv:Qualifier
meshv:AllowedDescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier
meshv:DescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier
meshv:DisallowedDescriptorQualifierPair | meshv:hasQualifier | meshv:Qualifier

</div>

{: #tabs-3}
<div>
{:.data-table-standard .row-border .hover}
Subject | Predicate
------- | ---------
meshv:Qualifier | rdfs:label
meshv:Qualifier | dcterms:identifier
meshv:Qualifier | meshv:activeMeSHYear
meshv:Qualifier | meshv:annotation
meshv:Qualifier | meshv:dateCreated
meshv:Qualifier | meshv:dateEstablished
meshv:Qualifier | meshv:dateRevised
meshv:Qualifier | meshv:historyNote
meshv:Qualifier | meshv:onlineNote
meshv:Qualifier | meshv:recordAuthorizer
meshv:Qualifier | meshv:recordMaintainer
meshv:Qualifier | meshv:recordOriginator

</div>
</div>

### SPARQL

The RDF output above can be generated with the following
<span class='invoke-sparql'>SPARQL query</span>:


```sparql
prefix mesh: <http://id.nlm.nih.gov/mesh/>
prefix meshv: <http://id.nlm.nih.gov/mesh/vocab#>
construct {
    mesh:Q000008 ?p ?o .
    mesh:Q000008 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:Q000008 meshv:recordPreferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .
}
from <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:Q000008 ?p ?o .
    mesh:Q000008 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConType .
    mesh:Q000008 meshv:recordPreferredTerm ?prefTerm .
    ?prefTerm a ?prefTermType .
    ?prefCon ?pct ?prefTerm .
}
```

###MeSH RDF Data

```
<http://id.nlm.nih.gov/mesh/T060555>
        a       <http://id.nlm.nih.gov/mesh/vocab#Term> .

<http://id.nlm.nih.gov/mesh/M0030212>
        a       <http://id.nlm.nih.gov/mesh/vocab#Concept> ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredTerm>
                <http://id.nlm.nih.gov/mesh/T060555> .

<http://id.nlm.nih.gov/mesh/Q000008>
        a       <http://id.nlm.nih.gov/mesh/vocab#Qualifier> ;
        <http://www.w3.org/2000/01/rdf-schema#label>
                "administration & dosage" ;
        <http://id.nlm.nih.gov/mesh/vocab#activeMeSHYear>
               "2004-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ,
               ...
               "2014-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#allowedTreeNode>
                <http://id.nlm.nih.gov/mesh/D01>
                ...
                <http://id.nlm.nih.gov/mesh/D27> 
        <http://id.nlm.nih.gov/mesh/vocab#annotation>
                "subhead only; ... /admin or /AD" ;
        <http://id.nlm.nih.gov/mesh/vocab#dateCreated>
                "1973-12-27"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#dateEstablished>
                "1966-01-01"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#dateRevised>
                "2003-07-22"^^<http://www.w3.org/2001/XMLSchema#date> ;
        <http://id.nlm.nih.gov/mesh/vocab#historyNote>
                "66; used with Category D 1966-90 forward" ;
        <http://id.nlm.nih.gov/mesh/vocab#onlineNote>
                "search policy: ... or SUBS APPLY AD" ;
        <http://id.nlm.nih.gov/mesh/vocab#preferredConcept>
                <http://id.nlm.nih.gov/mesh/M0030212> ;
        <http://id.nlm.nih.gov/mesh/vocab#recordAuthorizer>
                "nelsons" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordMaintainer>
                "schulmaj" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordOriginator>
                "nlm" ;
        <http://id.nlm.nih.gov/mesh/vocab#recordPreferredTerm>
                <http://id.nlm.nih.gov/mesh/T060555> ;
        <http://id.nlm.nih.gov/mesh/vocab#treeNumber>
                <http://id.nlm.nih.gov/mesh/Y07.010> , 
                <http://id.nlm.nih.gov/mesh/Y10.010> ;
        <http://purl.org/dc/terms/identifier>
                "Q000008" ;
        <http://www.w3.org/2004/02/skos/core#broader>
                <http://id.nlm.nih.gov/mesh/> .
```

### MeSH XML

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

```xml
<QualifierRecord QualifierType="1">
  <QualifierUI>Q000008</QualifierUI>
  <QualifierName>
    <String>administration &amp; dosage</String>
  </QualifierName>
  <DateCreated>
    <Year>1973</Year>
    <Month>12</Month>
    <Day>27</Day>
  </DateCreated>
  <DateRevised>
    <Year>2003</Year>
    <Month>07</Month>
    <Day>22</Day>
  </DateRevised>
  <DateEstablished>
    <Year>1966</Year>
    <Month>01</Month>
    <Day>01</Day>
  </DateEstablished>
  <ActiveMeSHYearList>
    <Year>2004</Year>
    ...
    <Year>2014</Year>
  </ActiveMeSHYearList>
  <Annotation>subhead only; for routes of administration, timing, amounts of doses; not for "dosage"
    in Romance languages ( = /analysis) ; see MeSH scope note in Introduction; indexing policy:
    Manual 19.8.2; DF: /admin or /AD </Annotation>
  <HistoryNote>66; used with Category D 1966-90 forward </HistoryNote>
  <OnlineNote>search policy: Online Manual; use: main heading/AD or AD (SH) or SUBS APPLY AD </OnlineNote>
  <TreeNumberList>
    <TreeNumber>Y07.010</TreeNumber>
    <TreeNumber>Y10.010</TreeNumber>
  </TreeNumberList>
  <TreeNodeAllowedList>
    <TreeNodeAllowed>D01</TreeNodeAllowed>
    ...
    <TreeNodeAllowed>D27</TreeNodeAllowed>
  </TreeNodeAllowedList>
  <RecordOriginatorsList>
    <RecordOriginator>nlm</RecordOriginator>
    <RecordMaintainer>schulmaj</RecordMaintainer>
    <RecordAuthorizer>nelsons</RecordAuthorizer>
  </RecordOriginatorsList>
  <ConceptList>
    <Concept PreferredConceptYN="Y">
      <ConceptUI>M0030212</ConceptUI>
      ...
      <TermList>
        <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="Y"
          RecordPreferredTermYN="Y">
          <TermUI>T060555</TermUI>
          <String>administration &amp; dosage</String>
          ...
        </Term>
      </TermList>
    </Concept>
  </ConceptList>
</QualifierRecord>
```