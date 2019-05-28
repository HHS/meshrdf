package gov.nih.nlm.lode.tests;

import java.io.File;
import java.io.IOException;

import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.data.VirtuosoSimpleDatasourceProvider;
import gov.nih.nlm.lode.servlet.MeshStatus;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

@ContextConfiguration(locations = {"classpath:spring-test-context.xml"})
@Test(groups = "unit")
public class MeshStatusTest extends AbstractTestNGSpringContextTests {

    @Autowired
    @Qualifier("virtuosoDataSourceProvider")
    private DatasourceProvider datasourceProvider;

    private File tempfile;
    private String tempfilePath;

    @BeforeClass(alwaysRun=true)
    public void setUp() throws IOException {
        tempfile = File.createTempFile("meshrdftest-", ".txt");
        tempfile.setLastModified(System.currentTimeMillis() - 35*60*1000);
        tempfilePath = tempfile.getCanonicalPath();
    }

    @AfterClass(alwaysRun=true)
    public void cleanUp() {
        if (tempfile != null) {
            tempfile.delete();
        }
    }

    @Test
    public void testMeshStatus() {
        MeshStatus status = new MeshStatus(datasourceProvider);
        status.check();

        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(true));
        assertThat(status.isMeshdataOK(), is(true));
        assertThat(status.isUpdating(), is(false));
        assertThat(status.isUpdateError(), is(false));
        assertThat(status.getStatus(), is(equalTo("Status: OK")));
    }

    @Test
    public void testMeshStatusUpdating() throws IOException {
        MeshStatus status = new MeshStatus(datasourceProvider, tempfilePath, 3*60*60);
        status.check();

        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(false));
        assertThat(status.isMeshdataOK(), is(false));
        assertThat(status.isUpdating(), is(true));
        assertThat(status.isUpdateError(), is(false));
        assertThat(status.getStatus(), is(equalTo("Status: Updating")));
    }

    @Test
    public void testMeshUpdatingTooLong() throws IOException {
        MeshStatus status = new MeshStatus(datasourceProvider, tempfilePath, 30*60);
        status.check();

        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(false));
        assertThat(status.isMeshdataOK(), is(false));
        assertThat(status.isUpdating(), is(true));
        assertThat(status.isUpdateError(), is(true));
        assertThat(status.getStatus(), is(equalTo("Status: Error")));
    }

    @Test
    public void testMeshVirtuosoConnectError() {
        // not real connection parameters
        VirtuosoSimpleDatasourceProvider brokenProvider = new VirtuosoSimpleDatasourceProvider();
        brokenProvider.setServerName("localhost");
        brokenProvider.setUserName("notrealuser");
        brokenProvider.setPassword("notrealpassword");

        //build a mesh status and check status
        MeshStatus status = new MeshStatus(brokenProvider);
        status.check();

        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(false));
        assertThat(status.isMeshdataOK(), is(false));
        assertThat(status.isUpdating(), is(false));
        assertThat(status.isUpdateError(), is(false));
        assertThat(status.getStatus(), is(equalTo("Status: Error")));
    }
}
