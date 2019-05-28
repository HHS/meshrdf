<%@page language="java" contentType="text/html"  pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
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

    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.22.0/swagger-ui-bundle.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.22.0/swagger-ui-standalone-preset.js"></script>
    <script id="swagger-start">
    window.onload = function() {
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
        defaultModelsExpandDepth: 0,
        showRequestHeaders: false,
        showOperationIds: false
      })
      // End Swagger UI call region

      window.swaggerUi = ui
    }
  </script>
  </body>
</html>
