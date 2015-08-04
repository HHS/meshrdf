---
title: SPARQL and URI Requests
layout: page
resource: true
categories:
- Cheat Sheets
---
### SPARQL Endpoint Requests

Our SPARQL endpoint has the following base URL: http://id.nlm.nih.gov/sparql. All SPARQL query requests for data should be sent to the SPARQL endpoint. We also offer a [SPARQL query editor](http://id.nlm.nih.gov/query) for writing and running SPARQL queries in a web browser. Queries run against our SPARQL endpoint or from our SPARQL query editor will produce persistent, shareable URLs. Build SPARQL endpoint requests by appending the following parameters to the base URL: http://id.nlm.nih.gov/sparql. 

{:.data-table-standard .row-border .hover}
Parameter | Valid Values (SELECT Queries) | Valid Values (CONSTRUCT Queries) | Default Value | Use Case
------------- | --------------------- | --------------------- | ---------- | ------------------------------
limit | Accepts positive integers up to 1000 | N/A | 1000 | Limits the number of results per request. The maximum number of results per request for SELECT queries is 1,000. This parameter does not affect CONSTRUCT queries. CONSTRUCT queries will return all triples requested up to a limit of 10,000 triples. 
offset | Accepts positive integers | N/A | 0 | When offset=n, this parameter will return results starting with the nth result. Use this parameter to loop through multiple requests for large result sets.
inference | Accepts true or false | Accepts true or false | false | Running a query with inference set to "true" will return results for all subclasses and subproperties of those classes and properties you specify in your query. For example, there are no direct instances of meshv:Descriptor, but if you run a query with inference and look for rdf:type meshv:Descriptor, you will get all instances of meshv:Descriptor's subclasses - meshv:TopicalDescriptor, meshv:GeographicalDescriptor, meshv:PublicationType and meshv:CheckTag. Running a query with inference=true may affect performance.
format | Accepts HTML*, XML, CSV, TSV or JSON | Accepts HTML*, XML, RDF/JSON, RDF/XML, TURTLE or N3 | HTML* | Returns a file with the specified syntax. 
year | Accepts "current" or a year. | Accepts "current" or a year. | current |Queries either the current MeSH graph (<http://id.nlm.nih.gov/mesh>) or a versioned MeSH graph, for example: (<http://id.nlm.nih.gov/mesh/2015>). 
query | Accepts a SELECT SPARQL query | Accepts a CONSTRUCT SPARQL query | N/A | This parameter is required and must contain a SPARQL query. For an example of how these are formatted, run a query from the [SPARQL query editor](http://id.nlm.nih.gov/query) and view the resulting URL. 

*Note that only the SPARQL query editor (http://id.nlm.nih.gov/query) will accept HTML as a format. The SPARQL endpoint will return an error if you request format=HTML. 

### URI Data Requests

The table below describes URL patterns and Accept Headers that applications can use to retrieve MeSH linked data from URIs in various formats. Users can also append the format to the end of the URI (e.g. D000900.html) to specify the desired return format.

All URLs assume the prefix http://id.nlm.nih.gov/

{:.data-table-long .row-border .hover }
URL | Accept Header | Return Format
------- | --------- | -------
mesh/D000900 | text/html | html
[mesh/D000900.html](http://id.nlm.nih.gov/mesh/D000900.html){:target="_blank"} | | html
mesh/D000900 | application/rdf+xml | rdf 
[mesh/D000900.rdf](http://id.nlm.nih.gov/mesh/D000900.rdf){:target="_blank"} | | rdf
mesh/D000900 | application/rdf+n3 | n3
[mesh/D000900.n3](http://id.nlm.nih.gov/mesh/D000900.n3){:target="_blank"} | | n3
mesh/D000900 | application/rdf+x-turtle | turtle
[mesh/D000900.ttl](http://id.nlm.nih.gov/mesh/D000900.ttl){:target="_blank"} | | turtle
mesh/D000900 | application/rdf+json | json
[mesh/D000900.json](http://id.nlm.nih.gov/mesh/D000900.json){:target="_blank"} | | json
