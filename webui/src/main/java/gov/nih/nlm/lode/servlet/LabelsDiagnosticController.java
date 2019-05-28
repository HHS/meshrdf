package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

// NOTE:
//   This is diagnostic code, please comment in if you want to run it.
@Controller
@RequestMapping("/internalonly/labels")
public class LabelsDiagnosticController {

  private Logger log = LoggerFactory.getLogger(getClass());

  @Autowired
  private DatasourceProvider datasourceProvider;

  private Connection getVirtuosoConnection() {
      Connection connection = null;
      try {
          DataSource ds = datasourceProvider.getDataSource();
          connection = ds.getConnection();
      } catch (SQLException e) {
          log.error("Unable to connect to Virtuoso", e);
          // This overkill is for Checkmarx
          if (null != connection) {
              try { connection.close(); } catch (SQLException ignored) { }
          }
          return null;
      }
      return connection;
  }

  @RequestMapping(method = RequestMethod.GET)
  protected void getLabels(
          @RequestParam(value="id", defaultValue="T504747") String id,
          @RequestParam(value="prop", defaultValue="rdfs:label") String prop,
          HttpServletResponse resp)
          throws ServletException, IOException {

      resp.setContentType("text/plain; charset=utf-8");
      resp.setCharacterEncoding("utf-8");

      String safeprop = null;
      if (prop.equals("rdfs:label")) {
          safeprop = "rdfs:label";
      } else if (prop.equals("meshv:prefLabel")) {
          safeprop = "meshv:prefLabel";
      } else if (prop.equals("meshv:altLabel")) {
          safeprop = "meshv:altLabel";
      } else {
          resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                  "label property must be one of \"rdfs:label\", \"meshv:prefLabel\", or \"meshv:altLabel\"");
          return;
      }

      Pattern expr = Pattern.compile("^[DQMCT\\d]+$");
      Matcher idm = expr.matcher(id);
      if (!idm.matches()) {
          resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "id must be a meshv identifier");
          return;
      }
      // Extracting the match is added protection.
      id = idm.group();

      PrintWriter out = resp.getWriter();
      Connection connection = null;

      try {
        // Get Virtuoso DB connection
        connection = getVirtuosoConnection();
        if (null == connection) {
          resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error");
          return;
        }

        out.println(String.format("Results for %s %s are:", Encode.forHtml(id), safeprop));
        out.println();

        String queryFormat = "SPARQL"
            + " define input:inference \"http://id.nlm.nih.gov/mesh/vocab\""
            + " PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>"
            + " PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>"
            + " PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>"
            + " PREFIX owl: <http://www.w3.org/2002/07/owl#>"
            + " PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>"
            + " PREFIX mesh: <http://id.nlm.nih.gov/mesh/>"
            + " SELECT ?l"
            + " FROM <http://id.nlm.nih.gov/mesh>"
            + " WHERE { mesh:%s %s ?l }";
        String query = String.format(queryFormat, id, safeprop);
        log.info(query);
        Statement stmt = connection.createStatement();
        ResultSet rset = stmt.executeQuery(query);
        while (rset.next()) {
          String label = rset.getNString(1);
          if (null != label) {
            String delim = "";
            StringBuilder b = new StringBuilder(label.length()*2);
            for (int i = 0; i < label.length(); i++) {
              int c = label.codePointAt(i);
              b.append(Encode.forHtml(String.format("%s%X", delim, c)));
              delim = ", ";
            }
            out.println("\""+Encode.forHtml(label)+"\" codepoints ["+b.toString()+"]");
          }
        }
        out.println();
        rset.close();
        stmt.close();
      }
      catch (SQLException e) {
        log.error("sparql query SQL error", e);
      }
      finally {
        // close the print writer
        if (null != out) {
          out.flush();
          out.close();
        }
        // close the connection
        if (null != connection) {
          try { connection.close(); } catch (SQLException e) { }
        }
      }
  }
}
