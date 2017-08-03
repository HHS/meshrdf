---
layout: page
---

__Welcome to MeSH RDF Technical Documentation.__ MeSH RDF is a linked data representation of [Medical Subject Headings](https://www.nlm.nih.gov/mesh/), a biomedical vocabulary produced by the National Library of Medicine. MeSH RDF includes a downloadable file in N-Triples format, a SPARQL query interface, a SPARQL API, and a RESTful interface for retrieving MeSH data. 

---

### Mesh RDF Resources

[__Download__](ftp://ftp.nlm.nih.gov/online/mesh/): Download MeSH in N-Triples format (mesh.nt.gz).

[__Query__](https://id.nlm.nih.gov/mesh/query): Use the SPARQL editor to query MeSH. For help, see our list of [sample queries](sample-queries).

[__API__](sparql-and-uri-requests): Request data for a specific MeSH identifier or via SPARQL query.

---

### MeSH RDF Documentation

{% for cat in site.category-list %}
__{{cat}}__
 <ul>
   {% for page in site.pages %}
    {% if page.resource == true and page.archived != true %}
     {% for pc in page.categories %}
      {% if pc == cat %}
      <li><a href="{{site.baseurl}}{{ page.url }}">{{ page.title }}</a></li>
      {% endif %}
     {% endfor %}
    {% endif %}  
   {% endfor %}
   </ul>
{% endfor %}

---

MeSH RDF is updated nightly.  Visit the [MeSH homepage](http://www.nlm.nih.gov/mesh/) for more information about MeSH.

To provide feedback, please submit an issue on [GitHub](https://github.com/HHS/meshrdf/issues).


