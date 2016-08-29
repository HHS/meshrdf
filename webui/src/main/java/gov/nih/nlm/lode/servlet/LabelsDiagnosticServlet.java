package gov.nih.nlm.lode.servlet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LabelsDiagnosticServlet extends HttpServlet {
  
  private static final long serialVersionUID = 1L;
  
  private Logger log = LoggerFactory.getLogger(getClass());

  private Connection getVirtuosoConnection() {
    Connection connection = null;
    try {
        Context initcontext = new InitialContext();
        Context context = (Context) initcontext.lookup("java:comp/env");
        DataSource dataSource = (DataSource) context.lookup("jdbc/virtuoso");
        connection = dataSource.getConnection();
    } catch (NamingException e) {
        log.error("JNDI resource not found", e);
        return null;
    } catch (SQLException e) {
        log.error("Unable to connect to Virtuoso", e);
        return null;
    }
    return connection;
  }
  
  @Override
  protected void doGet(HttpServletRequest req, HttpServletResponse resp)
          throws ServletException, IOException {
    
      resp.setContentType("text/plain");
      resp.setCharacterEncoding("utf-8");
      PrintWriter out = resp.getWriter();
      try {
        // verify arguments
        String id = req.getParameter("id");
        if (id == null || id.isEmpty()) {
          id = "T504747";
        }
        
        String relation = req.getParameter("rel");
        if (relation == null || relation.isEmpty()) {
          relation = "rdfs:label"; 
        }
        
        // Get Virtuoso DB connection
        Connection connection = getVirtuosoConnection();
        if (null == connection) {
          return;
        }
        
        out.println(String.format("Results for %s %s are:", id, relation));
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
        String query = String.format(queryFormat, id, relation);
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
            out.println("\""+label+"\" codepoints ["+b.toString()+"]");
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
