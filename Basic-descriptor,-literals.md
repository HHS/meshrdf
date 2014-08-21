The following is an example of how a fairly typical XML record for a descriptor (D015242, Ofloxacin) is converted from XML into RDF. For reference, see [Oxaflaxin in the MeSH 
browser](https://www.nlm.nih.gov/cgi/mesh/2014/MB_cgi?term=ofloxacin).

For the most part, this page just shows the portions of the XML and RDF that correspond to the literal values that are attached to the descriptor object. Both the XML and the RDF are elided in the same way. 

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
  ...
  <HistoryNote>89
  </HistoryNote>
  <PublicMeSHNote>89
  </PublicMeSHNote>
  <PreviousIndexingList>
   <PreviousIndexing>Anti-Infective Agents (1981-1988)</PreviousIndexing>
   <PreviousIndexing>Anti-Infective Agents, Urinary (1981-1988)</PreviousIndexing>
   <PreviousIndexing>Oxazines (1981-1988)</PreviousIndexing>
  </PreviousIndexingList>
  <TreeNumberList>
   <TreeNumber>D03.438.810.835.322.500</TreeNumber>
  </TreeNumberList>
  <RecordOriginatorsList>
   <RecordOriginator>standardr</RecordOriginator>
   <RecordMaintainer>pashj</RecordMaintainer>
   <RecordAuthorizer>chodan</RecordAuthorizer>
  </RecordOriginatorsList>
  ...
 </DescriptorRecord>
```

## RDF

This RDF is depicted in the following graph:

![](https://github.com/HHS/mesh-rdf/blob/master/doc/BasicConversionLiterals.png)

(This drawing was done in [LucidChart](https://www.lucidchart.com), and is on Google drive [here](https://drive.google.com/file/d/0B8n-nWqCI5WmZEVjMmhzaDhKOGc/edit?usp=sharing).)

In turtle format:

```
@prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix mesh: <http://id.nlm.nih.gov/mesh/> .
@prefix meshv:  <http://id.nlm.nih.gov/mesh/vocab#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dcterms:  <http://purl.org/dc/terms/> .
@prefix xsd:  <http://www.w3.org/2001/XMLSchema#> .

mesh:D015242  rdf:type  meshv:TopicalDescriptor ;
  rdfs:label  "Ofloxacin" ;
  dcterms:identifier  "D015242" ;
  meshv:dateCreated "2014-06-26"^^xsd:date ;
  meshv:dateRevised "2013-07-08"^^xsd:date ;
  meshv:dateEstablished "1989-01-01"^^xsd:date ;
  meshv:activeMeSHYear  "2014-01-01"^^xsd:date ;
  ...
  meshv:historyNote "89\n  " ;
  meshv:publicMeSHNote  "89\n  " ;
  ...
  meshv:treeNumber  "D03.438.810.835.322.500" ;
  meshv:recordOriginator  "standardr" ;
  meshv:recordMaintainer  "pashj" ;
  meshv:recordAuthorizer  "chodan" ;
  ...
  meshv:previousIndexing  "Anti-Infective Agents (1981-1988)" ,
    "Anti-Infective Agents, Urinary (1981-1988)" ,
    "Oxazines (1981-1988)" .
```

Note:

* The [DescriptorClass attribute](http://www.nlm.nih.gov/mesh/xml_data_elements.html#DC) value (in this case, "1") is represented in RDF as an rdfs:class (meshv:TopicalDescriptor) (see GitHub issue #28).  Possible values are:
    * 1 - meshv:TopicalDescriptor
    * 2 - meshv:PublicationType
    * 3 - meshv:CheckTag
    * 4 - meshv:GeographicalDescriptor

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