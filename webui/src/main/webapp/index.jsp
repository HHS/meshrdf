<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH Linked Data (beta)</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
          <div class="navi">
            <%@ include file="internal/nav.jspf" %>
          </div>

          <a name="skip"> </a>
          <h1>Medical Subject Headings (MeSH) RDF Linked Data (beta)</h1>
          
          <p>The National Library of Medicine (NLM) is now offering a beta version of the Medical Subject Headings (MeSH&#174;) data in RDF (Resource Description Framework). RDF is a well-known standard for representing structured data on the Web. Systems that use RDF are often called Linked Data because of RDF emphasis on well-described links between resources.</p>
            
          <p>During this beta release, NLM is seeking stakeholder input and feedback as part of a broader effort to evaluate the creation of an NLM Linked Data Service. NLM hopes that users will help us refine MeSH RDF and contribute use cases for future linked data services.</p>
            
          <p>Once beta testing is finished, NLM will evaluate the results of the testing and the impact of the service for current stakeholders and potential future users.</p>
            
          <h3>Why MeSH as Linked Data?</h3>
            
          <p>The MeSH thesaurus is a controlled vocabulary produced by NLM since 1960. NLM uses MeSH in our products and systems for indexing, cataloging, and searching for biomedical and health-related information and documents. It includes Descriptors (main headings), Qualifiers (subheadings), Descriptor/Qualifier pairs, and Supplementary Concept Records (SCRs for controlled terms that are not main headings). The hierarchical structure of the vocabulary permits use at various levels of specificity. MeSH is also widely used by libraries and other organizations around the world. Visit the <a href="http://www.nlm.nih.gov/mesh/">MeSH homepage</a> for additional information.</p>
                    
          <p>Many national libraries have published authoritative terminologies as Linked Data. Other organizations have already demonstrated a need for MeSH RDF by producing their own versions of the data. NLM will provide the official beta MeSH RDF release.</p>
                    
          <h3>Access MeSH RDF</h3>
            
          <p>The latest release of MeSH RDF includes the 2016 MeSH data. See the <a href="https://hhs.github.io/meshrdf/release-notes.html">release notes</a> for more details. The data will update nightly.</p>
                    
          <ul>
            <li>Read about <a href="http://hhs.github.io/meshrdf/">MeSH RDF</a>. Documentation includes data model diagrams, sample queries and policy statements.</li>
            <li>Search MeSH RDF directly using the <a href="./query">SPARQL Query</a> interface.&nbsp;&nbsp;&nbsp;*Note - some versions of Internet Explorer may not be supported.</li>
            <li>Integrate MeSH RDF into your programs and services using the <a href="./sparql">SPARQL Endpoint</a>.</li>
            <li>Review <a href="https://hhs.github.io/meshrdf/sample-queries.html">sample queries</a> to get you started.</li>
            <li><a href="ftp://ftp.nlm.nih.gov/online/mesh/">Download</a> the MeSH RDF data.</li>
          </ul>
                
          <h3>Feedback</h3>

          <p>Join us on <a href="https://github.com/HHS/meshrdf/issues/">GitHub</a> for a collaborative discussion about MeSH RDF. Your use cases and comments, suggestions, and questions are welcome. Your participation will help us refine the MeSH RDF and develop future RDF releases.</p>
                
          <p>You may also direct questions and comments to the <a target="_blank" href="https://support.nlm.nih.gov/ics/support/default.asp?deptID=28054&from=https://id.nlm.nih.gov/mesh/">NLM Customer Service form</a>; please use NLM Linked Data in the subject line.</p>
                
          <p>Commentary via social media is another option; use the icons on our pages. Comment on Twitter using <a target="_blank" href="https://twitter.com/intent/tweet?text=MeSH%20Linked%20Data%20(beta)%20%23NLMLD%20%40nlm_news&source=sharethiscom&related=sharethis&url=http://id.nlm.nih.gov/mesh/#sthash.Yqn2yh5c.uxfs">#NLMLD and @nlm_news.</a></p>
                
          <span class='st_twitter_large' st_url="http://id.nlm.nih.gov/mesh/" st_title="MeSH Linked Data (beta) #NLMLD @nlm_news" st_via="" displayText='Tweet'></span>
          <span class='st_facebook_large' st_url="http://id.nlm.nih.gov/mesh/" st_summary="MeSH Linked Data" displayText='Facebook'></span>

          <div class="footer">
            <%@ include file="internal/footer.html" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
