package gov.nih.nlm.lode.tests;

import java.sql.SQLException;
import javax.sql.DataSource;

import virtuoso.jdbc4.VirtuosoDataSource;
import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

public class VirtuosoTestDatasourceProvider implements DatasourceProvider {

    private String serverName;
    private String userName;
    private String password;

    private DataSource dataSource;

    public VirtuosoTestDatasourceProvider() {
        serverName = null;
        userName = null;
        password = null;
        dataSource = null;
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
