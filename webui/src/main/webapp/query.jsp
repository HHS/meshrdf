<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH SPARQL Explorer</title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <%@ include file="internal/head.jspf" %>
    <lodestar:gtmscript/>
  </head>

  <body onload="$('#sparql-content').sparql({namespaces : lodeNamespacePrefixes, inference: true});">
    <lodestar:gtmnoscript/>
    <lodestar:qualtrics/>
    <div class="skipnav"><a href="#sparql-content" class="skipnav">Skip Navigation</a></div>
    <div class="header">
      <%@ include file="/internal/header.html" %>
    </div>
    <div class="container-fluid">
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
          <div class="navi">
            <%@ include file="/internal/nav.jspf" %>
          </div>
	      <div class="grid_24" id="sparql-content">
	      </div>

          <div class="footer">
            <%@ include file="/internal/footer.jspf" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
