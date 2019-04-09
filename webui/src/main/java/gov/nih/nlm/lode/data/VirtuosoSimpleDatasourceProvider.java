package gov.nih.nlm.lode.data;

import java.sql.SQLException;

import javax.sql.DataSource;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;
import virtuoso.jdbc4.VirtuosoDataSource;

public class VirtuosoSimpleDatasourceProvider implements DatasourceProvider {

    private String serverName;
    private String userName;
    private String password;

    private DataSource dataSource;

    public VirtuosoSimpleDatasourceProvider(String userName, String password) {
        this("localhost", userName, password);
    }
    public VirtuosoSimpleDatasourceProvider(String serverName, String userName, String password) {
        this.serverName = serverName;
        this.userName = userName;
        this.password = password;
        dataSource = null;
    }
    public VirtuosoSimpleDatasourceProvider() {
        this("localhost", "dba", "dba");
    }

    public String getServerName() {
        return serverName;
    }

    public void setServerName(String hostName) {
        this.serverName = hostName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public DataSource getDataSource() throws SQLException {
        if (dataSource == null) {
            VirtuosoDataSource virtuosoSource = new VirtuosoDataSource();
            virtuosoSource.setServerName(getServerName());
            virtuosoSource.setPortNumber(1111);
            virtuosoSource.setCharset("UTF-8");
            virtuosoSource.setUser(getUserName());
            virtuosoSource.setPassword(getPassword());
            dataSource = virtuosoSource;
        }
        return dataSource;
    }

}
