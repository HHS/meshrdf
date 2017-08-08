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
        <script type="text/javascript">
          var switchTo5x = true;
        </script>
        <script type="text/javascript" src="https://ws.sharethis.com/button/buttons.js"></script>
        <script type="text/javascript">
          stLight.options({
            publisher: "e9b3d8ae-cb2a-4d2b-b8a6-a3c03949ec62",
            doNotHash: false,
            doNotCopy: false,
            hashAddressBar: false,
            shorten: false
          });
        </script>
        <lodestar:gtmscript/>
    </head>

    <body>
      <lodestar:gtmnoscript/>
      <div class="skipnav"><a class="skipnav" href="#skip">Skip Navigation</a>
      </div>
      <div class="header">
        <%@ include file="internal/header.html" %>
      </div>
      <div class="container-fluid">
        <div id="meshTabContent" class="tab-content">
          <div class="tab-pane fade in active" id="home">
            <div class="navi">
              <%@ include file="internal/nav.jspf" %>
            </div>

            <div class="row content">
              <div class="col-md-4 col-sm-4 meshrdf-description">
                <a id="skip" name="skip"></a>
                <p>Medical Subject Headings (MeSH) RDF is a linked data representation of the <a href="https://www.nlm.nih.gov/mesh/">MeSH</a> biomedical vocabulary produced by the National Library of Medicine. MeSH RDF includes a downloadable file in
                  <a
                    href="ftp://ftp.nlm.nih.gov/online/mesh/mesh.nt.gz">RDF N-Triples format</a>, a <a href="/mesh/query">SPARQL query editor</a>, a <a href="http://hhs.github.io/meshrdf/sparql-and-uri-requests">SPARQL endpoint (API)</a>, and a RESTful interface for retrieving MeSH data.</p>
                <p>MeSH RDF supports the following use cases:
                  <ul>
                    <li>Perform highly granular queries on the MeSH vocabulary. For example, <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0ASELECT+*+%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0AWHERE+%7B%0D%0A++mesh%3AD015242+meshv%3ApharmacologicalAction+%3Fpa+.%0D%0A++%3Fpa+rdfs%3Alabel+%3FpaLabel+.%0D%0A%7D+%0D%0A&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">get all of the pharmacological actions for a given substance</a>.</li>
                    <li>Get data for a particular MeSH identifier. For example, this URL will provide json data for the descriptor for Ofloxacin: <a href="https://id.nlm.nih.gov/mesh/D015242.json">https://id.nlm.nih.gov/mesh/D015242.json</a></li>
                    <li>Find MeSH descriptors that include specific strings. For example, <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0A+SELECT+%3Fd+%3FdName+%3Fc+%3FcName%0D%0A+FROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0A+%0D%0A+WHERE+%7B%0D%0A+++%0D%0A+%3Fd+a+meshv%3ADescriptor+.%0D%0A+%3Fd+meshv%3Aactive+1+.%0D%0A+%3Fd+meshv%3Aconcept+%3Fc+.%0D%0A+%3Fd+rdfs%3Alabel+%3FdName+.%0D%0A+%3Fc+rdfs%3Alabel+%3FcName%0D%0A+FILTER%28REGEX%28%3FdName%2C%22infection%22%2C%22i%22%29+%7C%7C+REGEX%28%3FcName%2C%22infection%22%2C%22i%22%29%29%0D%0A+%0D%0A+%7D%0D%0A+ORDER+BY+%3Fd%0D%0A%0D%0A%23Find+a+set+of+descriptors+and+terms+that+contain+%22infection.%22&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">find all MeSH descriptors and concepts with the "infection" in the name</a>.
                      <li>Download any subset of the MeSH vocabulary using SPARQL queries. For instance, <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0ASELECT+*+%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0AWHERE+%7B%0D%0A++%3FDescriptorUI+rdf%3Atype+meshv%3ADescriptor+.%0D%0A++%3FDescriptorUI+rdfs%3Alabel+%3FLabel++%0D%0A%7D+%0D%0AORDER+BY+%3FLabel%0D%0A&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">get all descriptor labels and identifiers</a>.</li>
                      <li>Get <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0ASELECT+%3FEntryTerm%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0AWHERE+%7B%0D%0A++mesh%3AD015242+meshv%3Aconcept+%3Fconcept+.%0D%0A++%3Fconcept+meshv%3Aterm+%3Fterm+.%0D%0A++%3Fterm+rdfs%3Alabel+%3FEntryTerm%0D%0A%7D+%0D%0A%0D%0A%23Entry+Terms+for+Ofloxacin+%28D015242%29%0D%0A&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">entry terms</a>,
                        <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0ASELECT+*%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0AWHERE+%7B%0D%0A++mesh%3AD001641+rdfs%3Alabel+%3FDescriptorLabel+.%0D%0A++mesh%3AD001641+meshv%3ApreferredConcept+%3Fconcept+.%0D%0A++%3Fconcept+meshv%3AscopeNote+%3FScopeNote+%0D%0A%7D+%0D%0A%0D%0A&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">definitions</a>,
                        <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0ASELECT+%3FtreeNum+%3FancestorTreeNum+%3Fancestor+%3Falabel%0D%0AFROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0A%0D%0AWHERE+%7B%0D%0A+++mesh%3AD005138+meshv%3AtreeNumber+%3FtreeNum+.%0D%0A+++%3FtreeNum+meshv%3AparentTreeNumber%2B+%3FancestorTreeNum+.%0D%0A+++%3Fancestor+meshv%3AtreeNumber+%3FancestorTreeNum+.%0D%0A+++%3Fancestor+rdfs%3Alabel+%3Falabel%0D%0A%7D%0D%0A%0D%0AORDER+BY+%3FtreeNum+%3FancestorTreeNum%0D%0A%0D%0A%23All+ancestors+of+Eyebrow+%28D005138%29&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">ancestors</a>                        or <a href="/query?query=PREFIX+rdf%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F1999%2F02%2F22-rdf-syntax-ns%23%3E%0D%0APREFIX+rdfs%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2000%2F01%2Frdf-schema%23%3E%0D%0APREFIX+xsd%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema%23%3E%0D%0APREFIX+owl%3A+%3Chttp%3A%2F%2Fwww.w3.org%2F2002%2F07%2Fowl%23%3E%0D%0APREFIX+meshv%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2Fvocab%23%3E%0D%0APREFIX+mesh%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F%3E%0D%0APREFIX+mesh2015%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2015%2F%3E%0D%0APREFIX+mesh2016%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2016%2F%3E%0D%0APREFIX+mesh2017%3A+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%2F2017%2F%3E%0D%0A%0D%0A+SELECT+DISTINCT+%3Fdescriptor+%3Flabel%0D%0A+FROM+%3Chttp%3A%2F%2Fid.nlm.nih.gov%2Fmesh%3E%0D%0A%0D%0A+WHERE+%7B%0D%0A+++mesh%3AD009369+meshv%3AtreeNumber+%3FtreeNum+.%0D%0A+++%3FchildTreeNum+meshv%3AparentTreeNumber%2B+%3FtreeNum+.%0D%0A+++%3Fdescriptor+meshv%3AtreeNumber+%3FchildTreeNum+.%0D%0A+++%3Fdescriptor+rdfs%3Alabel+%3Flabel+.%0D%0A+%7D%0D%0A+%0D%0A+ORDER+BY+%3Flabel%0D%0A%0D%0A%23Descendants+of+Neoplasms+%28D009369%29%0D%0A&format=HTML&inference=true&year=current&limit=50&offset=0#lodestart-sparql-results">descendants</a>.</li>
                      <li>Download all <a href="ftp://ftp.nlm.nih.gov/online/mesh/mesh.nt.gz">MeSH RDF triples in one file</a>. </li>
                  </ul>
                </p>
                <p>To provide feedback, please visit us on <a href="https://github.com/HHS/meshrdf/issues">GitHub</a>.</p>
              </div>
              <div class="col-md-6 col-sm-8">
                <h3 class="meshrdf-resources-header">MeSH RDF Resources</h3>
                <div class="row meshrdf-resource-item">
                  <div class="col-md-6">
                    <h4><a href="ftp://ftp.nlm.nih.gov/online/mesh/">Download</a></h4>
                  </div>
                  <div class="col-md-6">
                    <p>Download MeSH in RDF N-Triples format (mesh.nt.gz).</p>
                  </div>
                </div>
                <div class="row meshrdf-resource-item">
                  <div class="col-md-6">
                    <h4><a href="/mesh/query">SPARQL Query Editor</a></h4>
                  </div>
                  <div class="col-md-6">
                    <p>Query MeSH using SPARQL. See our <a href="https://hhs.github.io/meshrdf/sample-queries">sample queries</a>.</p>
                  </div>
                </div>
                <div class="row meshrdf-resource-item">
                  <div class="col-md-6">
                    <h4><a href="https://hhs.github.io/meshrdf/sparql-and-uri-requests">API / SPARQL Endpoint</a></h4>
                  </div>
                  <div class="col-md-6">
                    <p>Request data for specific MeSH identifiers or using SPARQL queries.</p>
                  </div>
                </div>
                <div class="row meshrdf-resource-item">
                  <div class="col-md-6">
                    <h4><a href="https://hhs.github.io/meshrdf/">Documentation</a></h4>
                  </div>
                  <div class="col-md-6">
                    <p>Documentation includes <a href="https://hhs.github.io/meshrdf/sample-queries">sample queries</a>, MeSH data model diagrams and more.</p>
                  </div>
                </div>
                <div class="row meshrdf-resource-item">
                  <div class="col-md-6">
                    <h4><a href="https://support.nlm.nih.gov/ics/support/ticketnewwizard.asp?style=classic&amp;deptID=28054&amp;from=https://id.nlm.nih.gov/mesh/">Support</a></h4>
                  </div>
                  <div class="col-md-6">
                    <p>Visit our <a href="https://github.com/HHS/meshrdf/issues">GitHub</a> repository and submit an issue or contact <a href="https://support.nlm.nih.gov/ics/support/ticketnewwizard.asp?style=classic&amp;deptID=28054&amp;from=https://id.nlm.nih.gov/mesh/">NLM Customer Support</a>.</p>
                  </div>
                </div>
              </div>
            </div>
            <div class="footer">
              <%@ include file="internal/footer.html" %>
            </div>
          </div>
        </div>
    </body>

    </html>
