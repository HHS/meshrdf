# MeSH RDF technical documentation on GitHub pages

MeSH RDF technical documentation is located on the web at http://hhs.github.io/mesh-rdf/. The first set of pages describes the data model for MeSH in RDF.  Each page shows RDF graph diagrams that illustrate particular examples from data model. SPARQL queries show how to get the data illustrated in the graph diagram from the SPARQL endpoint. Finally, the pages include the RDF data produced by the SPARQL query and the corresponding MeSH XML data. Documentation also includes lists of RDF predicates, URL patterns, and sample queries.

All of the examples are drawn from the XML contained within the sample XML files ([desc-samples.xml](https://github.com/HHS/meshrdf/blob/master/samples/desc-samples.xml), [qual-samples.xml](https://github.com/HHS/meshrdf/blob/master/samples/qual-samples.xml), and [supp-samples.xml](https://github.com/HHS/meshrdf/blob/master/samples/supp-samples.xml)), so it should be possible to run the XSLTs on just those samples, without downloading the entire MeSH dataset, in order to verify that the documentation is correct.

The drawings are all done with [LucidChart](https://www.lucidchart.com), and the original files are editable on Google Drive.  To edit any of them, first create an account on LucidChart that's linked to your Google account, and then click on the link under the drawing. Then, export it as a png and put it into the doc folder in the repository.

The documentation pages were created in [Markdown](http://daringfireball.net/projects/markdown/) and converted to HTML using [Jekyll](http://jekyllrb.com/). 
