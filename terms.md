---
title: Terms
layout: page
resource: true
categories:
- Data Model
---

* Also need an example for Term/Abbreviation; Term/SortVersion, and Term/EntryVersion - use T060555, which is a descendent of the *qualifier* Q000008, administration and dosage. (We'll add a drawing for this under Qualifiers)

{: .jump}
&#91; jump to [term properties](#properties) or [term relations](#relations) &#93;

### <a name = "properties"/>RDF Graph Model - Term Properties

![](images/TermModel.png){: class="rdf-graph"}


### SPARQL - Term Properties

The following <span class='invoke-sparql'>SPARQL query</span> produces the graphs depicted in the
figures above:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:M0353609 rdfs:label ?con1Label .
    mesh:M0353609 a ?con1Class .

    mesh:M0353609 meshv:preferredTerm ?con1PrefTerm .
    ?con1PrefTerm a ?con1PrefTermClass .
    ?con1PrefTerm ?con1PrefTerm_p ?con1PrefTerm_o .

    mesh:M0353609 meshv:term ?con1Term .
    ?con1Term a ?con1TermClass .
    ?con1Term ?con1Term_p ?con1Term_o .

    mesh:M0030212 rdfs:label ?con2Label .
    mesh:M0030212 a ?con2Class .
    mesh:M0030212 meshv:preferredTerm ?con2PrefTerm .
    ?con2PrefTerm a ?con2PrefTermClass .
    ?con2PrefTerm ?con2PrefTerm_p ?con2PrefTerm_o .
}
FROM <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:M0353609 rdfs:label ?con1Label .
    mesh:M0353609 a ?con1Class .

    mesh:M0353609 meshv:preferredTerm ?con1PrefTerm .
    ?con1PrefTerm a ?con1PrefTermClass .
    ?con1PrefTerm ?con1PrefTerm_p ?con1PrefTerm_o .

    mesh:M0353609 meshv:term ?con1Term .
    ?con1Term a ?con1TermClass .
    ?con1Term ?con1Term_p ?con1Term_o .

    mesh:M0030212 rdfs:label ?con2Label .
    mesh:M0030212 a ?con2Class .
    mesh:M0030212 meshv:preferredTerm ?con2PrefTerm .
    ?con2PrefTerm a ?con2PrefTermClass .
    ?con2PrefTerm ?con2PrefTerm_p ?con2PrefTerm_o .
}
```

### MeSH RDF - Term Properties

```
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .
@prefix skos: <http://www.w3.org/2004/02/skos/core#> .

mesh:M0353609 rdf:type  meshv:Concept ;
              rdfs:label  "A-23187" ;
              meshv:term  mesh:T000003 ,
                          mesh:T000004 ;
              meshv:preferredTerm mesh:T000001 .
mesh:T000001  rdf:type  meshv:Term ;
              meshv:lexicalTag  "LAB" ;
              rdfs:label  "A-23187" ;
              meshv:prefLabel  "A-23187" ;
              meshv:altLabel "A 23187" .
              dcterms:identifier  "T000001" ;
              meshv:dateCreated "1990-03-08"^^xsd:date ;
              meshv:thesaurusID "NLM (1991)" ;
              meshv:printFlag "N" ;
mesh:T000003  rdf:type  meshv:Term ;
              meshv:lexicalTag  "NON" ;
              rdfs:label  "Antibiotic A23187" ;
              meshv:prefLabel  "Antibiotic A23187" ;
              meshv:altLabel "A23187, Antibiotic" .
              dcterms:identifier  "T000003" ;
              ...
...
mesh:M0030212 rdf:type  meshv:Concept ;
              rdfs:label  "administration & dosage" ;
              meshv:preferredTerm mesh:T060555 .
mesh:T060555  rdf:type  meshv:Term ;
              rdfs:label  "administration & dosage" ;
              meshv:abbreviation  "AD" ;
              meshv:sortVersion "ADMINISTRATION A" ;
              meshv:entryVersion  "ADMIN" ;
              ...
```


### MeSH XML - Term Properties

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

```xml
<DescriptorRecord DescriptorClass = "1">
  <DescriptorUI>D000001</DescriptorUI>
  ...
  <Concept PreferredConceptYN="N">
    <ConceptUI>M0353609</ConceptUI>
    <ConceptName>
      <String>A-23187</String>
    </ConceptName>
    ...
    <TermList>
      <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="LAB" PrintFlagYN="N"
        RecordPreferredTermYN="N">
        <TermUI>T000001</TermUI>
        <String>A-23187</String>
        <DateCreated>
          <Year>1990</Year>
          <Month>03</Month>
          <Day>08</Day>
        </DateCreated>
        <ThesaurusIDlist>
          <ThesaurusID>NLM (1991)</ThesaurusID>
        </ThesaurusIDlist>
      </Term>
      <Term ConceptPreferredTermYN="N" IsPermutedTermYN="Y" LexicalTag="LAB" PrintFlagYN="N"
        RecordPreferredTermYN="N">
        <TermUI>T000001</TermUI>
        <String>A 23187</String>
      </Term>
      <Term ConceptPreferredTermYN="N" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="N"
        RecordPreferredTermYN="N">
        <TermUI>T000003</TermUI>
        <String>Antibiotic A23187</String>
        ...
      </Term>
      <Term ConceptPreferredTermYN="N" IsPermutedTermYN="Y" LexicalTag="NON" PrintFlagYN="N"
        RecordPreferredTermYN="N">
        <TermUI>T000003</TermUI>
        <String>A23187, Antibiotic</String>
      </Term>
      ...
    </TermList>
  </Concept>
</DescriptorRecord>
...
<QualifierRecord QualifierType = "1">
  <QualifierUI>Q000008</QualifierUI>
  ...
  <Concept PreferredConceptYN="Y">
    <ConceptUI>M0030212</ConceptUI>
    <ConceptName>
      <String>administration &amp; dosage</String>
    </ConceptName>
    ...
    <TermList>
      <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="Y"
        RecordPreferredTermYN="Y">
        <TermUI>T060555</TermUI>
        <String>administration &amp; dosage</String>
        <Abbreviation>AD</Abbreviation>
        <SortVersion>ADMINISTRATION A</SortVersion>
        <EntryVersion>ADMIN</EntryVersion>
      </Term>
    </TermList>
  </Concept>
</QualifierRecord>
```

###<a name = "relations"/>RDF Graph Model - Term Relations

Depicted in these graphs:

![](images/TermModel-2.png){: class="rdf-graph"}

### SPARQL - Term Relations

[Note that the following should be possible using the short `CONSTRUCT WHERE` form,
as described in [the SPARQL specification](http://www.w3.org/TR/2013/REC-sparql11-query-20130321/#constructWhere),
but it seems that Virtuoso doesn't support it.]

The following <span class='invoke-sparql'>SPARQL query</span> produces the graphs depicted in the
figures above:

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

construct {
    mesh:D000001 a ?descClass .
    ?descClass rdfs:subClassOf ?superClass .

    mesh:D000001 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConClass .

    mesh:D000001 meshv:recordPreferredTerm ?prefTerm .
    ?prefCon meshv:preferredTerm ?prefTerm .
    ?prefTerm a ?prefTermClass .

    mesh:D000001 meshv:concept ?con .
    ?con a ?conClass .
    ?con meshv:preferredTerm ?conPrefTerm .
    ?conPrefTerm a ?conPrefTermClass .

    ?con meshv:term ?conTerm .
    ?conTerm a ?conTermClass .
}
FROM <http://id.nlm.nih.gov/mesh2014>
where {
    mesh:D000001 a ?descClass .
    ?descClass rdfs:subClassOf ?superClass .

    mesh:D000001 meshv:preferredConcept ?prefCon .
    ?prefCon a ?prefConClass .

    mesh:D000001 meshv:recordPreferredTerm ?prefTerm .
    ?prefCon meshv:preferredTerm ?prefTerm .
    ?prefTerm a ?prefTermClass .

    mesh:D000001 meshv:concept ?con .
    ?con a ?conClass .
    ?con meshv:preferredTerm ?conPrefTerm .
    ?conPrefTerm a ?conPrefTermClass .

    ?con meshv:term ?conTerm .
    ?conTerm a ?conTermClass .
}
```

### MeSH RDF - Term Relations


```
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .

mesh:D000001  rdf:type  meshv:TopicalDescriptor ;
              meshv:preferredConcept  mesh:M0000001 ;
              meshv:recordPreferredTerm mesh:T000002 ;
              meshv:concept mesh:M0353609 .
mesh:M0000001 rdf:type  meshv:Concept ;
              meshv:preferredTerm mesh:T000002 .
mesh:M0353609 rdf:type  meshv:Concept ;
              meshv:term  mesh:T000003 ,
                          mesh:T000004 ;
              meshv:preferredTerm mesh:T000001 .
mesh:T000002  rdf:type  meshv:Term .
mesh:T000001  rdf:type  meshv:Term .
mesh:T000003  rdf:type  meshv:Term .
mesh:T000004  rdf:type  meshv:Term .
meshv:TopicalDescriptor rdfs:subClassOf meshv:Descriptor .
```

Notes:

* The [RecordPreferredTermYN attribute](http://www.nlm.nih.gov/mesh/xml_data_elements.html#RecordPreferredTermYN)
  in the XML is used to directly connect a record (in this
  case, a Descriptor) to its preferred term, using the `meshv:preferredTerm` property, which is an
  `rdfs:subPropertyOf` `meshv:term`.

* The [IsPermutedTermYN
  attribute](http://www.nlm.nih.gov/mesh/xml_data_elements.html#IsPermutedTermYN) is used to determine the
  properties to use for a given label.  If IsPermutedTermYN is "N", then `skos:prefLabel` is used.
  If it is "Y", then `skos:altLabel` is used.  For convenience, the preferred label is also indicated with
  the `rdfs:label` property.


### MeSH XML - Term Relations

The MeSH RDF was derived from non-RDF MeSH XML. Compare the RDF graph diagram and the RDF data above to the truncated MeSH XML below.

```xml
<DescriptorRecord DescriptorClass="1">
  <DescriptorUI>D000001</DescriptorUI>
  <DescriptorName>
    <String>Calcimycin</String>
  </DescriptorName>
  ...
  <ConceptList>
    <Concept PreferredConceptYN="Y">
      <ConceptUI>M0000001</ConceptUI>
      <ConceptName>
        <String>Calcimycin</String>
      </ConceptName>
      ...
      <TermList>
        <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="Y"
          RecordPreferredTermYN="Y">
          <TermUI>T000002</TermUI>
          <String>Calcimycin</String>
          ...
        </Term>
      </TermList>
    </Concept>
    <Concept PreferredConceptYN="N">
      <ConceptUI>M0353609</ConceptUI>
      <ConceptName>
        <String>A-23187</String>
      </ConceptName>
      ...
      <TermList>
        <Term ConceptPreferredTermYN="Y" IsPermutedTermYN="N" LexicalTag="LAB" PrintFlagYN="N"
          RecordPreferredTermYN="N">
          <TermUI>T000001</TermUI>
          <String>A-23187</String>
          <DateCreated>
            <Year>1990</Year>
            <Month>03</Month>
            <Day>08</Day>
          </DateCreated>
          <ThesaurusIDlist>
            <ThesaurusID>NLM (1991)</ThesaurusID>
          </ThesaurusIDlist>
        </Term>
        <Term ConceptPreferredTermYN="N" IsPermutedTermYN="Y" LexicalTag="LAB" PrintFlagYN="N"
          RecordPreferredTermYN="N">
          <TermUI>T000001</TermUI>
          <String>A 23187</String>
        </Term>
        <Term ConceptPreferredTermYN="N" IsPermutedTermYN="N" LexicalTag="NON" PrintFlagYN="N"
          RecordPreferredTermYN="N">
          <TermUI>T000003</TermUI>
          <String>Antibiotic A23187</String>
          ...
        </Term>
        <Term ConceptPreferredTermYN="N" IsPermutedTermYN="Y" LexicalTag="NON" PrintFlagYN="N"
          RecordPreferredTermYN="N">
          <TermUI>T000003</TermUI>
          <String>A23187, Antibiotic</String>
        </Term>
        ...
      </TermList>
    </Concept>
  </ConceptList>
</DescriptorRecord>
```
