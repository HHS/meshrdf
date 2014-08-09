Discussion on issue [#10](https://github.com/HHS/mesh-rdf/issues/22).

See this image:

![](https://github.com/HHS/mesh-rdf/blob/master/doc/EntryCombinations.png)


## Generating the RDF

```sparql
PREFIX mesh: <http://id.nlm.nih.gov/mesh/>
PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>

CONSTRUCT { 
  ?ecin ?p ?o .
  ?ecin rdf:type ?eclass .
  ?eclass rdfs:subClassOf $superclass .
}
from <http://chrismaloney.org/mesh>
from <http://chrismaloney.org/meshv>
where {
  ?ecin meshv:hasDescriptor mesh:D000005 .
  ?ecin meshv:hasQualifier ?ecinq .
  ?ecin meshv:useInstead ?ecout .
  ?ecin ?p ?o .
  ?ecin rdf:type ?eclass .
  ?eclass rdfs:subClassOf $superclass .
}
```

At the time of this writing, you can see the results dynamically from [this url](http://jatspan.org:8890/sparql?query=PREFIX%20mesh%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0APREFIX%20meshv%3A%20%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0A%0ACONSTRUCT%20%7B%20%0A%20%20%3Fecin%20%3Fp%20%3Fo%20.%0A%20%20%3Fecin%20rdf%3Atype%20%3Feclass%20.%0A%20%20%3Feclass%20rdfs%3AsubClassOf%20%24superclass%20.%0A%7D%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmesh%3E%0Afrom%20%3Chttp%3A%2F%2Fchrismaloney.org%2Fmeshv%3E%0Awhere%20%7B%0A%20%20%3Fecin%20meshv%3AhasDescriptor%20mesh%3AD000005%20.%0A%20%20%3Fecin%20meshv%3AhasQualifier%20%3Fecinq%20.%0A%20%20%3Fecin%20meshv%3AuseInstead%20%3Fecout%20.%0A%20%20%3Fecin%20%3Fp%20%3Fo%20.%0A%20%20%3Fecin%20rdf%3Atype%20%3Feclass%20.%0A%20%20%3Feclass%20rdfs%3AsubClassOf%20%24superclass%20.%0A%7D&format=TURTLE)
