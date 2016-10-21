package gov.nih.nlm.lode.servlet;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import org.owasp.encoder.Encode;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

@Controller
@RequestMapping("/labels")
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
      if (!(prop.equals("rdfs:label") || prop.equals("meshv:prefLabel") || prop.equals("meshv:altLabel"))) {
          resp.sendError(HttpServletResponse.SC_BAD_REQUEST,
                  "label property must be one of \"rdfs:label\", \"meshv:prefLabel\", or \"meshv:altLabel\"");
          return;
      }

      if (!Pattern.matches("^[DQMCT\\d]+$", id)) {
          resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "id must be a meshv identifier");
          return;
      }

      PrintWriter out = resp.getWriter();

      try {
        // Get Virtuoso DB connection
        Connection connection = getVirtuosoConnection();
        if (null == connection) {
          resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error");
          return;
        }

        out.println(String.format("Results for %s %s are:", id, prop));
        out.println();

        Statement stmt = connection.createStatement();

        String queryFormat  = "SPARQL"
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
        String query = String.format(queryFormat, id, prop);
        log.info(query);
        ResultSet rset = stmt.executeQuery(query);
        while (rset.next()) {
          String label = rset.getNString(1);
          if (null != label) {
            String delim = "";
            StringBuilder b = new StringBuilder(label.length()*2);
            for (int i = 0; i < label.length(); i++) {
              int c = label.codePointAt(i);
              b.append(String.format("%s%X", delim, c));
              delim = ", ";
            }
            out.println("\""+
                    Encode.forHtml(label)+
                    "\" codepoints ["
                    +b.toString()
                    +"]");
          }
        }
        out.println();
        rset.close();
        stmt.close();

        // close the connection
        if (null != connection) {
          connection.close();
        }
      }
      catch (SQLException e) {
        log.error("sparql query SQL error", e);
      }
      finally {
          if (null != out) {
              out.flush();
              out.close();
          }
      }
  }
}
