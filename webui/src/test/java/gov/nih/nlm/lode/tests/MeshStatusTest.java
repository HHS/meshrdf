package gov.nih.nlm.lode.tests;

import java.io.File;
import java.io.IOException;

import org.testng.annotations.AfterGroups;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.MeshStatus;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;

@ContextConfiguration(locations = {"classpath:spring-test-context.xml"})
public class MeshStatusTest extends AbstractTestNGSpringContextTests {

    @Autowired
    @Qualifier("testProvider")
    private DatasourceProvider datasourceProvider;

    @Autowired
    @Qualifier("brokenProvider")
    private DatasourceProvider brokenProvider;

    private File tempfile;
    private String tempfilePath;

    public MeshStatusTest() throws IOException {
        tempfile = File.createTempFile("meshrdftest-", ".txt");
        tempfile.setLastModified(System.currentTimeMillis() - 35*60*1000);
        tempfilePath = tempfile.getCanonicalPath();
    }

    @AfterGroups(groups={"unit"})
    public void cleanUp() {
        tempfile.delete();
    }

    @Test(groups={"unit"})
    public void testMeshStatus() {
        MeshStatus status = new MeshStatus(datasourceProvider);
        status.check();
        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(true));
        assertThat(status.isMeshdataOK(), is(true));
        assertThat(status.isUpdating(), is(false));
        assertThat(status.isAllOK(), is(true));
        assertThat(status.getMessage(), is(equalTo("Status: OK")));
    }

    @Test(groups={"unit"})
    public void testMeshStatusUpdating() throws IOException {
        MeshStatus status = new MeshStatus(datasourceProvider, tempfilePath, 3*60*60);
        status.check();
        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(true));
        assertThat(status.isMeshdataOK(), is(true));
        assertThat(status.isUpdating(), is(true));
        assertThat(status.isAllOK(), is(false));
        assertThat(status.getMessage(), is(equalTo("Status: Updating")));
    }

    @Test(enabled=false, groups={"unit"})
    public void testMeshUpdatingTooLong() throws IOException {
        MeshStatus status = new MeshStatus(datasourceProvider, tempfilePath, 30*60);
        status.check();
        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(true));
        assertThat(status.isMeshdataOK(), is(true));
        assertThat(status.isUpdating(), is(false));
        assertThat(status.isAllOK(), is(false));
        assertThat(status.getMessage(), is(equalTo("Status: Error")));
    }

    // This test must be last - we set priority
    @Test(groups={"unit"})
    public void testMeshVirtuosoConnectError() {
        MeshStatus status = new MeshStatus(brokenProvider);
        status.check();
        assertThat(status.isHttpdOK(), is(true));
        assertThat(status.isTomcatOK(), is(true));
        assertThat(status.isVirtuosoOK(), is(false));
        assertThat(status.isMeshdataOK(), is(false));
        assertThat(status.isUpdating(), is(false));
        assertThat(status.isAllOK(), is(false));
        assertThat(status.getMessage(), is(equalTo("Status: Error")));
    }
}
