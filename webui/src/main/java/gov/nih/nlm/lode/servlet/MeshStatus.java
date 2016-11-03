package gov.nih.nlm.lode.servlet;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

public class MeshStatus {

    private DatasourceProvider datasourceProvider;

    private String updatesPath;

    private long updateMaxSeconds;

    private boolean httpdOK = true;
    private boolean tomcatOK = true;
    private boolean virtuosoOK = true;
    private boolean meshdataOK = true;
    private boolean updating = false;
    private boolean updateError = false;

    // These are also used as response codes
    public static final int STATUS_OK = 200;
    public static final int STATUS_UPDATING = 503;
    public static final int STATUS_ERROR = 524;

    private Logger log = LoggerFactory.getLogger(getClass());


    public MeshStatus(DatasourceProvider datasourceProvider, String updatesPath, long updateMaxSeconds) {
        this.datasourceProvider = datasourceProvider;
        this.updatesPath = updatesPath;
        this.updateMaxSeconds = updateMaxSeconds;
    }

    public MeshStatus(DatasourceProvider datasourceProvider) {
        this(datasourceProvider, null, 3*60*60);
    }

    private Connection getVirtuosoConnection() {
        Connection connection = null;
        try {
            DataSource datasource = datasourceProvider.getDataSource();
            connection = datasource.getConnection();
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

    private Boolean virtuosoHasData(Connection connection) {
        if (null == connection) {
            return false;
        }
        boolean successful = false;
        try {
            PreparedStatement stmt = connection.prepareStatement("SPARQL"
                    + " PREFIX mesh: <http://id.nlm.nih.gov/mesh/>"
                    + " PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>"
                    + " SELECT COUNT(?pa)"
                    + " FROM <http://id.nlm.nih.gov/mesh>"
                    + " WHERE { mesh:D015242 meshv:pharmacologicalAction ?pa . }");
            ResultSet rset = stmt.executeQuery();
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

    public void check() {
        // We assume httpd and Tomcat are OK
        setHttpdOK(true);
        setTomcatOK(true);

        // Check status of Virtuoso DB server
        Connection connection = getVirtuosoConnection();
        if (null != connection) {
            setVirtuosoOK(true);
        } else {
            setVirtuosoOK(false);
        }

        // Check Virtuoso data
        if (virtuosoHasData(connection)) {
            setMeshdataOK(true);
        } else {
            setMeshdataOK(false);
        }

        if (null != connection) {
            try { connection.close(); } catch (SQLException e) { }
        }

        // Check whether we are currently updating
        if (updatesPath != null) {
            File updatesFile = new File(updatesPath);
            if (updatesFile.exists()) {
                setUpdating(true);
                setUpdateError(false);
                long now = System.currentTimeMillis();
                long maxMillis = (updateMaxSeconds * 1000);
                if ((now - updatesFile.lastModified()) > maxMillis) {
                    setUpdateError(true);
                }
            }
        }
    }

    public boolean isHttpdOK() {
        return httpdOK;
    }

    public void setHttpdOK(boolean httpdOK) {
        this.httpdOK = httpdOK;
    }

    public boolean isTomcatOK() {
        return tomcatOK;
    }

    public void setTomcatOK(boolean tomcatOK) {
        this.tomcatOK = tomcatOK;
    }

    public boolean isVirtuosoOK() {
        return virtuosoOK;
    }

    public void setVirtuosoOK(boolean virtuosoOK) {
        this.virtuosoOK = virtuosoOK;
    }

    public boolean isMeshdataOK() {
        return meshdataOK;
    }

    public void setMeshdataOK(boolean meshdataOK) {
        this.meshdataOK = meshdataOK;
    }

    public boolean isUpdating() {
        return updating;
    }

    public void setUpdating(boolean updating) {
        this.updating = updating;
    }

    public boolean isUpdateError() {
        return updateError;
    }

    public void setUpdateError(boolean updateError) {
        this.updateError = updateError;
    }

    protected int getStatusCode() {
        if (isVirtuosoOK() && isMeshdataOK() && !isUpdating() && !isUpdateError()) {
            return STATUS_OK;
        } else if (isVirtuosoOK() && this.isUpdating() && !isUpdateError()) {
            return STATUS_UPDATING;
        } else {
            return STATUS_ERROR;
        }
    }

    public String getStatus() {
        String message = null;
        switch (getStatusCode()) {
        case STATUS_OK:
            message = "Status: OK";
            break;
        case STATUS_UPDATING:
            message = "Status: Updating";
            break;
        default:
            message = "Status: Error";
            break;
        }
        return message;
    }
}
