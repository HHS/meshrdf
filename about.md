---
title: About MeSH-RDF Linked Data
layout: page
resource: true
---
The National Library of Medicine is now offering Medical Subject Headings (MeSH) data in RDF for the first time. This beta release will help NLM and its stakeholders to explore and discuss the publishing of NLM data on the web. We hope that the conversation will help NLM better understand uses of MeSH in the broader community.  


MeSH RDF grew from research efforts at the Lister Hill National Center for Biomedical Communications, a division of NLM. In early 2014, NLM chartered a working group to begin exploring the publishing NLM linked data.
Medical Subject Headings (MeSH) was chosen for a pilot release. The working group adapted an XSLT to transform MeSH XML to MeSH RDF.
The group also developed a [SPARQL endpoint](http://iddev.nlm.nih.gov/mesh/sparql) and an interface for querying and viewing MeSH RDF data.

###Our Goals
{: class="inline-header"}

* Understand uses of MeSH. Feedback from this beta release will inform the future development of MeSH.
* Improve NLM data publishing. NLM is examining its data publishing in general. NLM publishes a number of data resources using a variety of methods. Linked Data provides a framework for publishing a number of data resources using standard methods.
* Endorse emerging web standards and the Semantic Web.  


###This is a Beta Release
{: class="inline-header"}
Please note that this is a beta release. We reserve the right to change the MeSH RDF data model and system configurations. Use MeSH RDF at your own risk. Expect changes. We welcome participation in this effort. Your [feedback](/feedback-placeholder) will help us refine MeSH RDF and develop future RDF releases.

### Why Linked Data?  
{: class="inline-header"}
NLM wants to provide users with well-defined, web-friendly, easily consumable data. Linked Data and RDF provide a useful framework for publishing, reusing and linking data on the web. Providing MeSH RDF data will allow users to query data directly, extract data at any level of granularity, and link to NLM data. See 

### Why MeSH?
{: class="inline-header"}
NLM chose MeSH as a pilot dataset because of its role in indexing MEDLINE citations and describing bibliographic resources. Libraries, researchers and developers use MeSH to describe resources and study relationships between concepts. 


### For Developers
{: class="inline-header"}
NLM transformed MeSH XML to MeSH RDF using XSLT. The .xsl files are available at our  [GitHub repository](http://github.com/hhs/meshrdf). NLM used [Virtuoso](http://virtuoso.openlinksw.com/dataspace/doc/dav/wiki/Main/) and the European Bioinformatics Institute's [Lodestar](http://github.com/HHS/lodestar) code to build an interface for querying and viewing MeSH RDF. 
