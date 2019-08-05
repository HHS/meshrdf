<%@ page pageEncoding="UTF-8" isErrorPage="true" %>
<%@ page import="javax.servlet.jsp.ErrorData" %>
<%@ taglib prefix="lodestar" uri="/WEB-INF/lodestar-tags.tld" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH Linked Data</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="" />
    <meta name="author" content="" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />

    <!--[if lt IE 9]>
      <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <script src="vendor/js/jquery.min.js"></script>
    <script src="vendor/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="vendor/css/bootstrap.min.css" />
    <%@ include file="internal/prefix.jspf" %>
    <style>
        <%@ include file="css/style.css" %>
        <%@ include file="css/lode-style.css" %>
    </style>
    <lodestar:gtmscript/>
  </head>

  <body>
    <lodestar:gtmnoscript/>
    <div class="skipnav"><a href="#error-div" class="skipnav">Skip Navigation</a></div>
    <div class="header">
      <%@ include file="internal/header.html" %>
    </div>
    <div class="container-fluid">
      <div id="meshTabContent" class="tab-content">
        <div class="tab-pane fade in active" id="home">
            <%@ include file="internal/nav.jspf" %>
          <div class="grid_24" id="error-content">
            <div id="lodestar-main" class="ui-widget ui-corner-all">
              <div id="error-div" class="ui-state-error">
                <p class="alert">
                  <span><b>Error Code ${requestScope['javax.servlet.error.status_code']}:</b></span>
                  <span id="error-text">${requestScope['javax.servlet.error.message']}</span>
                </p>
              </div>
            </div>
          </div>

          <div class="footer">
            <%@ include file="internal/footer.jspf" %>
          </div>
        </div>
      </div>
    </div>
  </body>

</html>
