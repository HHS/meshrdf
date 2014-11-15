---
title: REST URL Examples
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below describes URL patterns and Accept Headers that applications can use to retrieve MeSH linked data in various formats.
Users can also append the format to the end of the URL (e.g. D064927.html) to specify the desired return format.

All URLs assume the prefix https://id.nlm.nih.gov/

{:.data-table-standard .row-border .hover }
URL | Accept Header | Return Format
------- | --------- | -------
mesh/D064927 | text/html | html
mesh/D064927.html | | html
mesh/D064927 | application/rdf+xml | rdf 
mesh/D064297.rdf | | rdf
mesh/D064927 | application/rdf+n3 | n3
mesh/D064297.n3 | | n3
mesh/D064927 | application/rdf+x-turtle | turtle
mesh/D064297.ttl | | turtle



