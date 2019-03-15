package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.greaterThan;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.Relation;
import gov.nih.nlm.lode.servlet.LookupServiceImpl;

/**
 * Test the content type and error handling of the LookupController
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class TestLookupService extends AbstractTestNGSpringContextTests {

    @Autowired
    private LookupService serviceIntf;

    @Test
    public void testWiring() throws IOException {
        assertThat(serviceIntf, notNullValue());
        assertThat(serviceIntf, instanceOf(LookupServiceImpl.class));
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        assertThat(service, notNullValue());
        assertThat(service.getQueryResource(), notNullValue());

        InputStream is = service.getQueryResource().getInputStream();
        String extras = IOUtils.toString(is, Charset.forName("UTF-8"));
        assertThat(extras, notNullValue());
        assertThat(extras.length(), greaterThan(20));

        assertThat(service.getResourceService(), notNullValue());
    }

    @Test
    public void testDescriptorQueriesExist() throws Exception {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        for (Relation rel : Relation.values()) {
            String queryKey = LookupServiceImpl.DESCRIPTOR_QUERY_PREFIX+rel.toString().toLowerCase();
            String query = service.getQuery(queryKey);
            assertThat(
                queryKey+" query is not null",
                query, notNullValue());
            assertThat(
                queryKey+" query is not empty",
                query.length(), greaterThan(0));
        }
    }

    @Test
    public void testPairQueriesExist() throws Exception {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        for (Relation rel : Relation.values()) {
            String queryKey = LookupServiceImpl.PAIR_QUERY_PREFIX+rel.toString().toLowerCase();
            String query = service.getQuery(queryKey);
            assertThat(
                queryKey+" query is not null",
                query, notNullValue());
            assertThat(
                queryKey+" query is not empty",
                query.length(), greaterThan(0));
        }
    }

    @Test
    public void testQualifierQueriesExist() throws Exception {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        String queryKey = LookupServiceImpl.ALLOWED_QUALIFERS_ID;
        String query = service.getQuery(queryKey);
        assertThat(
            queryKey+" query is not null",
            query, notNullValue());
        assertThat(
            queryKey+" query is not empty",
            query.length(), greaterThan(0));
    }
}
