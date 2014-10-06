Wrap any of the following in `SPARQL ... ;` if you are entering them through the isql
interface.

## Any MeSH term ('D' or 'M') that has 'infection' as part of its name

```sparql

PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX vocab: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?id rdfs:label ?label;
     <http://purl.org/dc/terms/identifier> ?purl
     FILTER regex(?label, "infection","i")
     FILTER(SUBSTR(?purl,1,1) IN("D") || SUBSTR(?purl,1,1) IN("M"))
     
}


```

## Break down the id types created in a given year ('C', 'D', 'T')

```sparql

PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX vocab: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

select substr(?purl,1,1) AS ?idType,count(?idType) AS ?numberOfIdType
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?id vocab:dateCreated ?dateCreated;
     <http://purl.org/dc/terms/identifier> ?purl;
     rdfs:label ?label
     FILTER(?dateCreated > "2014-01-01"^^xsd:date)
     


}
GROUP BY substr(?purl,1,1)
ORDER BY ?idType

```


## What are all the new MeSH Descriptors in a given year (2014)?

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX vocab: <http://id.nlm.nih.gov/mesh/vocab#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?id vocab:dateCreated ?dateCreated;
     <http://purl.org/dc/terms/identifier> ?purl;
     rdfs:label ?label
     FILTER(?dateCreated > "2014-01-01"^^xsd:date)
     FILTER(SUBSTR(?purl,1,1) = "D")
     
     
}
```

## Which triples have “Ofloxacin” as object?

```sparql
select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?s ?p "Ofloxacin" .
}
```

## All triples with “Ofloxacin” as the subject

See [[Basic descriptor conversion]] for a description of these results.

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     mesh:D015242 ?p ?o .
}
```

## The pharmacological actions of Ofloxacin (mesh:D015242)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     mesh:D015242 mesh:pharmacologicalAction ?c .
}
```

## The pharmacological actions of Ofloxacin, and their triples

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     mesh:D015242 mesh:pharmacologicalAction ?pa .
     ?pa ?p ?o .
}
```


## The pharmacological actions of Ofloxacin, only the labels

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select *
from <http://mor.nlm.nih.gov/mesh2014>
where {
     mesh:D015242 mesh:pharmacologicalAction ?pa .
     ?pa <http://www.w3.org/2000/01/rdf-schema#label> ?label .
}
```

## What are the descriptors/SCRs that have the PA Anti-Bacterial Agents? (direct)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptor
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa <http://www.w3.org/2000/01/rdf-schema#label> ?label
   FILTER (?label = "Anti-Bacterial Agents") .
}
```

## What are the descriptors/SCRs that have the PA Anti-Bacterial Agents? (filter)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptor
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label ?label
     FILTER (?label = "Anti-Bacterial Agents") .
}
```

## What are the descriptors/SCRs and their names that have the PA Anti-Bacterial Agents?

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptor ?descriptorname
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label "Anti-Bacterial Agents" .
     ?descriptor rdfs:label ?descriptorname .
}
ORDER BY ASC(?descriptorname)
```

## Supplementary Concept Records and their links to descriptors (1)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptor ?descriptorname ?SCR
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label "Anti-Bacterial Agents" .
     ?descriptor rdfs:label ?descriptorname .
     ?SCR mesh:isMappedToDescriptor ?descriptor .
}
ORDER BY ASC(?descriptorname)
```

## Supplementary Concept Records and their links to descriptors (2)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptor ?descriptorname ?SCR ?SCRname
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label "Anti-Bacterial Agents" .
     ?descriptor rdfs:label ?descriptorname .
     _:b mesh:isMappedToDescriptor ?descriptor .
     ?SCR mesh:mappedData _:b .
     ?SCR rdfs:label ?SCRname .
}
ORDER BY ASC(?descriptorname)
```

## Count the number of SCRs that have the PA Anti-Bacterial Agents

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select count(distinct ?SCR)
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label "Anti-Bacterial Agents" .
     ?descriptor rdfs:label ?descriptorname .
     _:b mesh:isMappedToDescriptor ?descriptor .
     ?SCR mesh:mappedData _:b .
     ?SCR rdfs:label ?SCRname .
}
```

## Count the number of SCRs per Descriptor

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>

select ?descriptorname count(distinct ?SCR) as ?count
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor mesh:pharmacologicalAction ?pa .
     ?pa rdfs:label "Anti-Bacterial Agents" .
     ?descriptor rdfs:label ?descriptorname .
     _:b mesh:isMappedToDescriptor ?descriptor .
     ?SCR mesh:mappedData _:b .
     ?SCR rdfs:label ?SCRname .
}
ORDER BY DESC(?count)
```

## Transitive Closure: All upper descriptors for “Levofloxacin”

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

select distinct *
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
where {
     ?descriptor rdfs:label "Levofloxacin" .
     ?descriptor skos:broader ?upperDescriptor .
     ?upperDescriptor rdfs:label ?descriptorname .
}
```

## Transitive Closure: All upper descriptors for “Levofloxacin”, with hierarchy

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

select distinct ?upperDescriptor ?descriptorname ?tn
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
where {
     ?descriptor rdfs:label "Levofloxacin" .
     ?descriptor skos:broader ?upperDescriptor .
     ?upperDescriptor rdfs:label ?descriptorname .
     ?upperDescriptor mesh:treeNumber ?tn .
}
ORDER BY ASC(?tn)
```

## All Quinolones (including indirect descendants) using the TC (fast)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

select distinct ?descriptorname ?tn
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
where {
     ?descriptor rdfs:label "Quinolones" .
     ?lowerDescriptor skos:broader ?descriptor .
     ?lowerDescriptor rdfs:label ?descriptorname .
     ?lowerDescriptor mesh:treeNumber ?tn .
}
ORDER BY ASC(?tn)
```

## All Quinolones (including indirect descendants) not using the TC (slow)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>

select distinct ?descriptorname ?tn
from <http://mor.nlm.nih.gov/mesh2014>
where {
     ?descriptor rdfs:label "Quinolones" .
     ?descriptor mesh:treeNumber ?quinolonesTn .

     ?lowerDescriptor rdfs:label ?descriptorname .
     ?lowerDescriptor mesh:treeNumber ?tn
     FILTER (contains(?tn, ?quinolonesTn)).
}
ORDER BY ASC(?tn)
```
