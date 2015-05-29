---
title: SPARQL Request Parameters
layout: page
resource: true
categories:
- Cheat Sheets
---

SPARQL queries from our [SPARQL endpoint](http://id.nlm.nih.gov/mesh/sparql) will produce permanent, shareable URLs. SPARQL request parameters expressed in SPARQL query URLs are described below.

{:.data-table-long .row-border .hover}
Parameter | SELECT Queries | CONSTRUCT Queries | Default | Use Case
---------- | ------------------ | ------------------ | ------------- | ----------------------------
&limit | Accepts positive integers up to 1000 | N/A | 1000 | Limits the number of results per request. The maximum number of results per request for SELECT queries is 1,000.
&offset | Accepts positive integers | N/A | 0 | When &offset=n, this parameter will return results starting with the nth result. Use this parameter to loop through multiple requests for large result sets.
&inference | Accepts true or false | Accepts true or false | false | Running a query with inference set to "true" will return results for all subclasses and subproperties of those classes and properties you specify in your query. For example, there are no direct instances of meshv:Descriptor, but if you run a query with inference and look for rdf:type meshv:Descriptor, you will get all instances of meshv:Descriptor's subclasses - meshv:TopicalDescriptor, meshv:GeographicalDescriptor, meshv:PublicationType and meshv:CheckTag. Running a query with &inference=true may affect performance.
&format | Accepts HTML, XML, CSV, TSV or JSON | Accepts XML, JSON, RDF/XML, TURTLE or N3 | HTML | Returns data in the browser in the specified syntax.
&render | N/A | Accepts HTML, RDF/XML, RDF/JSON or RDF/N3 | HTML | Returns a file with the specified syntax. Use this to download files. 
