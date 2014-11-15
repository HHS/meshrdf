---
title: REST URL Examples
layout: page
resource: true
categories:
- Cheat Sheets
---

The table below describes URL patterns and Accept Headers that applications can use to retrieve MeSH linked data in various formats.
Users can also append the format to the end of the URL (e.g. D000900.html) to specify the desired return format.

All URLs assume the prefix http://id.nlm.nih.gov/

{:.data-table-standard .row-border .hover }
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



