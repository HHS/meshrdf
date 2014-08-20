Can document information about our Lodestar deployment here, as well as tips and tricks for how to set  it up.
See [issue #35](https://github.com/HHS/mesh-rdf/issues/35).

## Caveats

* Do not put any sensitive information into this page, like server names or (especially) credentials.

## Summary

Lodestar ([main documentation](https://github.com/HHS/mesh-rdf/wiki/Virtuoso), [GitHub repo](https://github.com/EBISPOT/lodestar)) is designed to provide the web interface (front end) part of a linked data application.  It would handle dereferencing the RDF URIs, and providing:

* Pretty HTML pages for people to look at from a browser
* Machine-readable RDF when requested by scripts and bots, using content negotiation.

It is a Java web application, and we can set it up inside of a Tomcat instance.  It seems to have been written with a Virtuoso connection in mind (although they say it will work with any SPARQL endpoint) so that is nice.

Here is an example of an implementation of Lodestar by EMBL-EBI: http://www.ebi.ac.uk/rdf/services/chembl/sparql. This demonstrates a number of features we may want:

* The query interface is pre-populated with a basic, useful query
* Example queries are listed along the right side, and they can be added to the query interface by clicking a link. 
* Users can select the output they want from a drop-down menu (HTML, XML, JSON, CSV, TSV, RDF/XML, RDF/N3)
* Perhaps most importantly, the HTML output provides active links to pages about each URI. Run a query, click a link from the output, get an HTML view of the relationships to that particular URI. 

## Installation / configuration

***TBD***
