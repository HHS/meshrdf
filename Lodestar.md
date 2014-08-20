Can document information about our Lodestar deployment here, as well as tips and tricks for how to set  it up.
See [issue #35](https://github.com/HHS/mesh-rdf/issues/35).

## Caveats

* Do not put any sensitive information into this page, like server names or (especially) credentials.

## Summary

Lodestar ([main documentation](https://github.com/HHS/mesh-rdf/wiki/Virtuoso), [GitHub repo](https://github.com/EBISPOT/lodestar)) is designed to provide the web interface (front end) part of a linked data application.  It would handle dereferencing the RDF URIs, and providing:

* Pretty HTML pages for people to look at from a browser
* Machine-readable RDF when requested by scripts and bots, using content negotiation.

It is a Java web application, and we can set it up inside of a Tomcat instance.  It seems to have been written with a Virtuoso connection in mind (although they say it will work with any SPARQL endpoint) so that is nice.

## Installation / configuration

***TBD***
