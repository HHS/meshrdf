<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/lodestar-tags.tld" prefix="lodestar" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH SPARQL Explorer</title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <lodestar:nlmconfig/>
    <%@ include file="/internal/head.jspf" %>
    <link rel="stylesheet" href="<%= resourcePrefix %>jquery-ui/jquery-ui.min.css"/>
    <link rel="stylesheet" href="<%= resourcePrefix %>/css/lookup.css"/>
    <lodestar:gtmscript/>
  </head>

  <body>
    <lodestar:gtmnoscript/>
    <div class="skipnav"><a href="#main" class="skipnav">Skip Navigation</a></div>
    <div class="header">
      <%@ include file="/internal/header.html" %>
    </div>
    <div class="container-fluid">
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
          <div class="navi">
            <%@ include file="/internal/nav.jspf" %>
          </div>
          <div id="main" class="grid_24" id="sparql-content">
            <div class="container-fluid">
              <div class="row">
                <div class="col-md-3">
                  <ul id="lookupTabs" class="nav nav-pills nav-stacked" role="tablist">
                    <li role="presentation">
                      <a href="#descriptor" role="tab" id="descriptor-tab" data-toggle="tab" aria-controls="descriptor" aria-expanded="true">
                        Descriptor (Heading)
                      </a>
                    </li>
                    <li role="presentation">
                      <a href="#pair" role="tab" id="pair-tab" data-toggle="tab" aria-controls="pair" aria-expanded="false">
                        Pair (Subheading)
                      </a>
                    </li>
                  </ul>
                </div>
                <div class="col-md-9 tab-content">
                  <div role="tabpanel" class="tab-pane fade template" id="descriptor" aria-labelledby="descriptor-tab">
                    <%@ include file="/internal/lookupDescriptor.jspf" %>
                  </div>
                  <div role="tabpanel" class="tab-pane fade template" id="pair" aria-labelledby="pair-tab">
                    <%@ include file="/internal/lookupPair.jspf" %>
                  </div>
                </div>
              </div>
            </div>
            <script src="<%= resourcePrefix %>jquery-ui/jquery-ui.min.js"></script>
            <script src="<%= resourcePrefix %>vendor/js/handlebars.runtime.min.js"></script>
            <script src="<%= resourcePrefix %>scripts/templates-min.js"></script>
            <script src="<%= resourcePrefix %>scripts/lookup.js"></script>
          </div>
          <div class="footer">
            <%@ include file="/internal/footer.jspf" %>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
