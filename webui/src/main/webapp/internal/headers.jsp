<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="lodestar" uri="/WEB-INF/lodestar-tags.tld" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>MeSH RDF Diagnostics</title>
    <meta name="description" content="" />
    <meta name="author" content="" />
    <lodestar:nlmconfig/>
    <%@ include file="/internal/head.jspf" %>
    <style>
      #main dt { width: 300px; }
      #main dd { margin-left: 320px; }
    </style>
  </head>

  <body>
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
                <dl class="dl-horizontal">
                  <c:forEach items="${headers}" var="entry">
                    <dt><c:out value="${entry.key}"/>
                    <dd>
                      <c:forEach items="${entry.value}" var="value">
                        <div><c:out value="${value}"/></div>
                      </c:forEach>
                    </dd>
                  </c:forEach>
                </dl>
              </div>
            </div>
          </div>
          <div class="footer">
            <%@ include file="/internal/footer.jspf" %>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
