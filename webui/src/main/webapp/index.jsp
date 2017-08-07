<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Medical Subject Headings RDF</title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <%@ include file="internal/head.jspf" %>
    <script type="text/javascript">var switchTo5x=true;</script>
    <script type="text/javascript" src="https://ws.sharethis.com/button/buttons.js"></script>
    <script type="text/javascript">
      stLight.options({
        publisher: "e9b3d8ae-cb2a-4d2b-b8a6-a3c03949ec62",
        doNotHash: false,
        doNotCopy: false,
        hashAddressBar: false,
        shorten:false});
    </script>
    <lodestar:gtmscript/>
  </head>

  <body>
    <lodestar:gtmnoscript/>
    <div class="skipnav"><a href="#skip" class="skipnav">Skip Navigation</a></div>
    <div class="header">
      <%@ include file="internal/header.html" %>
    </div>
    <div class="container-fluid">
          <%@ include file="internal/nav.jspf" %>
       <div class="row content meshrdf-row1">
         <div class="col-md-4 col-sm-4 meshrdf-description">
          <a name="skip"> </a>
           <p>**** TEXT BELOW WILL BE REVISED**** </p>
          <p>The National Library of Medicine (NLM) is now offering a beta version of the Medical Subject Headings (MeSH&#174;) data in RDF (Resource Description Framework). RDF is a well-known standard for representing structured data on the Web. Systems that use RDF are often called Linked Data because of RDF emphasis on well-described links between resources.</p>

          <p>During this beta release, NLM is seeking stakeholder input and feedback as part of a broader effort to evaluate the creation of an NLM Linked Data Service. NLM hopes that users will help us refine MeSH RDF and contribute use cases for future linked data services.</p>

          <p>Once beta testing is finished, NLM will evaluate the results of the testing and the impact of the service for current stakeholders and potential future users.</p>

          <h3>Why MeSH as Linked Data?</h3>

          <p>The MeSH thesaurus is a controlled vocabulary produced by NLM since 1960. NLM uses MeSH in our products and systems for indexing, cataloging, and searching for biomedical and health-related information and documents. It includes Descriptors (main headings), Qualifiers (subheadings), Descriptor/Qualifier pairs, and Supplementary Concept Records (SCRs for controlled terms that are not main headings). The hierarchical structure of the vocabulary permits use at various levels of specificity. MeSH is also widely used by libraries and other organizations around the world. Visit the <a href="http://www.nlm.nih.gov/mesh/">MeSH homepage</a> for additional information.</p>

          <p>Many national libraries have published authoritative terminologies as Linked Data. Other organizations have already demonstrated a need for MeSH RDF by producing their own versions of the data. NLM will provide the official beta MeSH RDF release.</p>

         </div>
    <div class="col-md-6 col-sm-8" >

      <h3 class="meshrdf-resources-header">MeSH RDF Resources</h3>
      <div class="row meshrdf-resource-item">
        <div class="col-md-6">
          <h4><a href="">Download</a></h4>
        </div>
        <div class="col-md-6">
          <p>Download MeSH in RDF N-Triples format (mesh.nt.gz).</p>
        </div>
      </div>
      <div class="row meshrdf-resource-item">
        <div class="col-md-6">
          <h4><a href="">SPARQL Query Editor</a></h4>
        </div>
        <div class="col-md-6">
          <p>Query MeSH using SPARQL. See our <a href="">sample queries</a>.</p>
        </div>
      </div>
      <div class="row meshrdf-resource-item">
        <div class="col-md-6">
          <h4><a href="">API / SPARQL Endpoint</a></h4>
        </div>
        <div class="col-md-6">
          <p>Request data for specific MeSH identifiers or using SPARQL queries.</p>
        </div>
      </div>
            <div class="row meshrdf-resource-item">
        <div class="col-md-6">
          <h4><a href="">Documentation</a></h4>
        </div>
        <div class="col-md-6">
          <p>Documentation includes <a href="">sample queries</a>, MeSH data model diagrams and more.</p>
        </div>
      </div>
      <div class="row meshrdf-resource-item">
        <div class="col-md-6">
          <h4><a href="">Support</a></h4>
        </div>
        <div class="col-md-6">
          <p>Visit our <a href="">GitHub</a> repository and submit an issue or contact <a href="">NLM Customer Support</a>.</p>
        </div>
      </div>
    </div>
  </div>
</div>
</div>

          <div class="footer">
            <%@ include file="internal/footer.html" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
