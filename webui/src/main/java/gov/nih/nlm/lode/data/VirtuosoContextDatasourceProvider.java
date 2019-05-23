package gov.nih.nlm.lode.data;

import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;
import virtuoso.jdbc4.VirtuosoDataSource;

/*
 * This is not yet in use.  The goal was to caputer the destroy event and make sure to release anything that needs to be released.
 */
public class VirtuosoContextDatasourceProvider implements DatasourceProvider {

    private final Logger logger = LoggerFactory.getLogger(getClass());

    private DataSource dataSource = null;

    public VirtuosoContextDatasourceProvider() {
        // Get the DataSource using JNDI
        if (dataSource == null) {
            try {
                Context context = (Context) (new InitialContext()).lookup("java:comp/env");
                dataSource = (DataSource) context.lookup("jdbc/virtuoso");
                context.close();
            }
            catch (NamingException e) {
                throw new IllegalStateException("Virtuoso JNDI datasource not configured: " + e.getMessage());
            }
        }
    }

    public VirtuosoContextDatasourceProvider(String endpointUrl, int port) {
        // Get the DataSource
        if (dataSource == null) {
            try {
                Context context = (Context) (new InitialContext()).lookup("java:comp/env");
                // NOTE: If we need setServerName() and setPortNumber(), we insist on the real thing
                VirtuosoDataSource virtuosoSource = (VirtuosoDataSource) context.lookup("jdbc/virtuoso");
                virtuosoSource.setServerName(endpointUrl);
                virtuosoSource.setPortNumber(port);
                dataSource = virtuosoSource;
                context.close();
            }
            catch (NamingException e) {
                throw new IllegalStateException("Virtuoso JNDI datasource not configured: " + e.getMessage());
            }
        }
    }

    @Override
    public DataSource getDataSource() throws SQLException {
        return dataSource;
    }
}
