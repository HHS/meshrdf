<%@page language="java" contentType="text/html"  pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta http-equiv="Content-Type" content="text/html" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>MeSH RDF Swagger API</title>
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.22.0/swagger-ui.css" >
    <!-- 
      <link rel="icon" type="image/png" href="./favicon-32x32.png" sizes="32x32" />
      <link rel="icon" type="image/png" href="./favicon-16x16.png" sizes="16x16" />
    -->
    <style>
      html {
        box-sizing: border-box;
        overflow: -moz-scrollbars-vertical;
        overflow-y: scroll;
      }

      *,
      *:before, *:after {
        box-sizing: inherit;
      }
      
      .download-url-wrapper {
        display: none;
      }

      body {
        margin:0;
        background: #fafafa;
      }
    </style>
  </head>

  <body>
    <div id="swagger-ui"></div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.23.1/swagger-ui-bundle.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.23.1/swagger-ui-standalone-preset.js"></script>
    <script id="swagger-start">
    window.onload = function() {

      // If the user provide search parameters/query part,
      // strip them and redirect.
      var url = new URL(document.location.href);
      if (url.search !== "") {
        document.location.href = url.origin + url.pathname + url.hash;
        // NEVER REACHED
      }

      // Begin Swagger UI call region
      const ui = SwaggerUIBundle({
        url: "${specUri}",
        dom_id: '#swagger-ui',
        deepLinking: true,
        presets: [
          SwaggerUIBundle.presets.apis,
        ],
        plugins: [
          SwaggerUIBundle.plugins.DownloadUrl
        ],
        jsonEditor: false,
        defaultModelRendering: 'schema',
        defaultModelExpandDepth: 3,
        defaultModelsExpandDepth: -1,
        showRequestHeaders: false,
        showOperationIds: false
      })
      // End Swagger UI call region

      window.swaggerUi = ui
    }
  </script>
  </body>
</html>
