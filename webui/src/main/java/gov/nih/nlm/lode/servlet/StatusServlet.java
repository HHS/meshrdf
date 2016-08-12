package gov.nih.nlm.servlet;

import java.util.HashMap;
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

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * A servlet that can be embedded within your web application and simply returns the string "OK" if it could be
 * accessed.  This can be used to allow load balancers in the production environment to detect when a web application
 * has crashed and send a notification to the mailing lists.
 */
public class StatusServlet extends HttpServlet {

    private static final int SC_ENGINEERED_FAILCODE = 524;

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

    private Boolean virtuosoHasData(Connection connection) {
        if (null == connection) {
            return false;
        }
        boolean successful = false;
        try { 
            Statement stmt = connection.createStatement();
            ResultSet rset = stmt.executeQuery("SPARQL"
                    + " PREFIX mesh: <http://id.nlm.nih.gov/mesh/>"
                    + " PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>"
                    + " SELECT COUNT(?pa)"
                    + " FROM <http://id.nlm.nih.gov/mesh>"
                    + " WHERE { mesh:D015242 meshv:pharmacologicalAction ?pa . }");
            if (rset.next()) {
                Integer count = rset.getInt(1);
                if (null != count && count == 4) {
                    successful = true;
                }
            }
            rset.close();
            stmt.close();
        }
        catch (SQLException e) { 
            log.error("SPARQL query failed", e);
        }
        return successful;
    }

    private Boolean currentlyUpdating() {
        String updatesPath = System.getenv("MESHRDF_UPDATES_PATH");
        if (null == updatesPath) {
            return false;
        }
        File updatesFile = new File(updatesPath);
        return updatesFile.exists();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        PrintWriter out = null;
        ObjectMapper mapper = null;
        try {
            boolean ok = true;
            HashMap<String,Object> status = new HashMap<String,Object>();

            // httpd and Tomcat are implicitly OK if we are here
            status.put("httpd", true);
            status.put("tomcat", true);

            // Check status of Virtuoso DB server
            Connection connection = getVirtuosoConnection();
            if (null != connection) {
                status.put("virtuoso-connect", true);
            } else {
                status.put("virtuoso-connect", false);
                if (ok) {
                    ok = false;
                    resp.setStatus(SC_ENGINEERED_FAILCODE);
                    resp.addHeader("Retry-After", "300");
                }
            }

            // Check Virtuoso data
            if (virtuosoHasData(connection)) {
                status.put("virtuoso-data", true);
            } else {
                status.put("virtuoso-data", false);
                if (ok) {
                    ok = false;
                    resp.setStatus(SC_ENGINEERED_FAILCODE);
                    resp.addHeader("Retry-After", "300");
                }
            }

            // close the connection
            if (null != connection) {
                try { connection.close(); } catch (SQLException e) { }
            }

            // Check whether we are currently updating
            if (!currentlyUpdating()) {
                status.put("update-is-idle", true);
            } else {
                status.put("update-is-idle", false);
                if (ok) {
                    ok = false;
                    resp.setStatus(SC_ENGINEERED_FAILCODE);
                    resp.addHeader("Retry-After", "300");
                }
            }

            // save overall status
            status.put("allok", ok);

            resp.setContentType("application/json; charset=UTF-8");
            out = resp.getWriter();
            mapper = new ObjectMapper();
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            mapper.enable(SerializationFeature.ORDER_MAP_ENTRIES_BY_KEYS);
            mapper.writeValue(out, status);
            out.println();
        }
        finally {
            if (null != out) {
                out.flush();
                out.close();
            }
        }

    }
}
