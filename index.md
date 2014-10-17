---
title: MeSH-RDF Linked Data Technical Documentation
layout: page
---

See the table of contents in the sidebar on the right.

This is a work-in-progress, and if you find errors or problems, go ahead and fix them!

The first set of pages describes the data model for MeSH in RDF.  Each page gives a sample of XML followed by the corresponding RDF that is produced from that XML, in both a diagram and in turtle format.  Finally, the pages include the SPARQL query or queries that can be used to generate the RDF for the particular example.

All of the examples are drawn from the XML contained within the sample XML files ([desc-samples.xml](https://github.com/HHS/mesh-rdf/blob/master/samples/desc-samples.xml), [qual-samples.xml](https://github.com/HHS/mesh-rdf/blob/master/samples/qual-samples.xml), and [supp-samples.xml](https://github.com/HHS/mesh-rdf/blob/master/samples/supp-samples.xml)), so it should be possible to run the XSLTs on just those samples, without downloading the entire MeSH dataset, in order to verify that the documentation is correct.

The drawings are all done with [LucidChart](https://www.lucidchart.com), and the original files are editable on Google Drive.  To edit any of them, first create an account on LucidChart that's linked to your Google account, and then click on the link under the drawing. Then, export it as a png and put it into the doc folder in the repository.

