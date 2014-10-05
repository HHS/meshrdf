This page will be a survey of all of the URLs that will be handled by our deployed application, and what you can expect, from each.

| URL Pattern                          | Accept header |            Result                        | 
|--------------------------------------|---------------|------------------------------------------|
| http://id.nlm.nih.gov/               |  *any*        | A picture of a cute kitten???            |
| http://id.nlm.nih.gov/mesh           |  *any*        | Metadata about our schema (ontology/vocabulary) |
| http://id.nlm.nih.gov/mesh/{id}      | text/html(rdf-xml?)     | 303 Redirect to {$1}.html  (rdfxml?)              |
| http://id.nlm.nih.gov/mesh/{id}.rdf  |  *any*        | rdf-xml format output                  |
| http://id.nlm.nih.gov/mesh/{id}.rdf-abbrev |  *any*   |  rdf-xml-abbreviated format output    |
| http://id.nlm.nih.gov/mesh/{id}.html |  *any*        | HTML page with info about the resource {id} |
| http://id.nlm.nih.gov/mesh/{id}.json |  *any*        | json format output                        |
| http://id.nlm.nih.gov/mesh/{id}.ntriples | *any*     | ntriples format output                      |
| http://id.nlm.nih.gov/mesh/{id}.ttl   |    *any*      | turtle format output                      |

