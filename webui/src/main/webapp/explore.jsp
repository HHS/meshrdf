<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH RDF Explorer</title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <lodestar:nlmconfig/>
    <%@ include file="internal/head.jspf" %>
    <lodestar:gtmscript/>
  </head>

  <body onload="$('#data-explorer-content').explore({
      resource_prefix : '<%= resourcePrefix %>',
      namespaces : lodeNamespacePrefixes
    });">
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

          <div class="grid_24" id="data-explorer-content">
          </div>

          <div class="footer">
            <%@ include file="internal/footer.jspf" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
