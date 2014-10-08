Here are sample SPARQL queries that explore what can be discovered by combining the MEDLINE and MeSH RDF
graphs.

## Find citations indexed with “Quinolones” (or any descendant)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX ml: <http://mor.nlm.nih.gov/ml/>

select distinct ?pmid ?descriptorname
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
from <http://mor.nlm.nih.gov/medline_fda_201401>
where {
     ?descriptor rdfs:label "Quinolones" .
     ?lowerDescriptor skos:broader ?descriptor .
     ?lowerDescriptor rdfs:label ?descriptorname .

     ?mh ml:Descriptor ?lowerDescriptor .
     ?mhl ml:MeshHeading ?mh .
     ?citation ml:MeshHeadingList ?mhl .
     ?citation ml:PMID ?pmid .
}
```

## Count citations indexed with “Quinolones” (or any descendant)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX ml: <http://mor.nlm.nih.gov/ml/>

select distinct ?descriptorname count(distinct ?pmid) as ?count
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
from <http://mor.nlm.nih.gov/medline_fda_201401>
where {
     ?descriptor rdfs:label "Quinolones" .
     ?lowerDescriptor skos:broader ?descriptor .
     ?lowerDescriptor rdfs:label ?descriptorname .

     ?mh ml:Descriptor ?lowerDescriptor .
     ?mhl ml:MeshHeading ?mh .
     ?citation ml:MeshHeadingList ?mhl .
     ?citation ml:PMID ?pmid .
}
ORDER BY ?count
```

## Find citations and their titles indexed with “Quinolones” (or any descendant)

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX ml: <http://mor.nlm.nih.gov/ml/>

select distinct ?descriptorname ?pmid ?title
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
from <http://mor.nlm.nih.gov/medline_fda_201401>
where {
     #All descriptors under Quinolones
     ?descriptor rdfs:label "Quinolones" .
     ?lowerDescriptor skos:broader ?descriptor .
     ?lowerDescriptor rdfs:label ?descriptorname .

     #All MEDLINE citations indexed with any of these descriptors
     ?mh ml:Descriptor ?lowerDescriptor .
     ?mhl ml:MeshHeading ?mh .
     ?citation ml:MeshHeadingList ?mhl .
     ?citation ml:PMID ?pmid .

     #get article titles
     ?citation ml:Article ?article .
     ?article ml:ArticleTitle ?title .
}
ORDER by ?descriptorname
```

## Find citations indexed with “Quinolones” that have the word “child” in their title

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX ml: <http://mor.nlm.nih.gov/ml/>

select distinct ?descriptorname ?pmid ?title
from <http://mor.nlm.nih.gov/mesh2014>
from <http://mor.nlm.nih.gov/mesh_tc_2014>
from <http://mor.nlm.nih.gov/medline_fda_201401>
where {
     #All descriptors under Quinolones
     ?descriptor rdfs:label "Quinolones" .
     ?lowerDescriptor skos:broader ?descriptor .
     ?lowerDescriptor rdfs:label ?descriptorname .

     #All medline citations indexed with any of these descriptors
     ?mh ml:Descriptor ?lowerDescriptor .
     ?mhl ml:MeshHeading ?mh .
     ?citation ml:MeshHeadingList ?mhl .
     ?citation ml:PMID ?pmid .

     #get article titles and look for "child"
     ?citation ml:Article ?article .
     ?article ml:ArticleTitle ?title FILTER (contains(?title, "child")).
}
ORDER by ?descriptorname
```
