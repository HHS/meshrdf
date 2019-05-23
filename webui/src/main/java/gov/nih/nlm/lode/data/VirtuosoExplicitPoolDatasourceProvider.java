package gov.nih.nlm.lode.data;

import java.sql.SQLException;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;
import virtuoso.jdbc4.VirtuosoConnectionPoolDataSource;

/*
 * This is not yet in use - the idea was to implement our own datasource providers so that we can be sure to clean-up.
 */
public class VirtuosoExplicitPoolDatasourceProvider implements DatasourceProvider {

    private final VirtuosoConnectionPoolDataSource virtuosoSource;
    private final Logger logger = LoggerFactory.getLogger(getClass());

    public VirtuosoExplicitPoolDatasourceProvider() {
        try {
            VirtuosoConnectionPoolDataSource ds = new VirtuosoConnectionPoolDataSource();
            ds.setInitialPoolSize(0);
            ds.setMinPoolSize(0);
            ds.setMaxPoolSize(4);
            ds.setCharset("UTF-8");
            ds.setUser("dba");
            ds.setPassword("dba");
            virtuosoSource = ds;
        }
        catch (SQLException e) {
            throw new IllegalStateException("Failed to create " + getClass().getSimpleName() + ": " + e.getMessage());
        }
    }

    public VirtuosoExplicitPoolDatasourceProvider(String endpointUrl, int port) {
        this();
        // now override server name and port number
        virtuosoSource.setServerName(endpointUrl);
        virtuosoSource.setPortNumber(port);
    }

    public VirtuosoExplicitPoolDatasourceProvider setInitialPoolSize(int poolSize) {
        try {
            virtuosoSource.setInitialPoolSize(poolSize);
            return this;
        } catch (SQLException e) {
            throw new IllegalStateException("Failed to set initial pool size " + getClass().getSimpleName() + ": " + e.getMessage());
        }
    }

    public VirtuosoExplicitPoolDatasourceProvider setMinPoolSize (int minPoolSize) {
        try {
            virtuosoSource.setMinPoolSize(minPoolSize);
            return this;
        } catch (SQLException e) {
            throw new IllegalStateException("Failed to set minimum pool size " + getClass().getSimpleName() + ": " + e.getMessage());
        }
    }

    public VirtuosoExplicitPoolDatasourceProvider setMaxPoolSize (int maxPoolSize) {
        try {
            virtuosoSource.setMaxPoolSize(maxPoolSize);
            return this;
        } catch (SQLException e) {
            throw new IllegalStateException("Failed to set max pool size " + getClass().getSimpleName() + ": " + e.getMessage());
        }
    }

    public VirtuosoExplicitPoolDatasourceProvider setCharset (String charset) {
        virtuosoSource.setCharset(charset);
        return this;
    }

    public VirtuosoExplicitPoolDatasourceProvider setUser (String user) {
        virtuosoSource.setUser(user);
        return this;
    }

    public VirtuosoExplicitPoolDatasourceProvider setPassword (String password) {
        virtuosoSource.setPassword(password);
        return this;
    }

    @Override
    public DataSource getDataSource() throws SQLException {
        return virtuosoSource;
    }

    public void cleanUp() {
        logger.info("datasourceProvider cleanUp");
        try {
            virtuosoSource.close();
        } catch (SQLException e) {
            logger.warn("Unable to close Virtuoso datasource", e);
        }
    }
}
