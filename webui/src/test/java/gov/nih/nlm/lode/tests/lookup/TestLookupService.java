package gov.nih.nlm.lode.tests.lookup;

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
    private LookupService service;

    @Test
    private void testServiceAndQueriesWired() throws IOException {
        assertThat(service, notNullValue());
        assertThat(service.getExtraQueries(), notNullValue());

        InputStream is = service.getExtraQueries().getInputStream();
        String extras = IOUtils.toString(is, Charset.forName("UTF-8"));
        assertThat(extras, notNullValue());
        assertThat(extras.length(), greaterThan(20));
    }

    @Test
    private void testDescriptorQueriesExist() throws Exception {
        for (Relation rel : Relation.values()) {
            String queryKey = LookupService.DESCRIPTOR_QUERY_PREFIX+rel.toString();
            String query = service.getQueryReader().getSparqlQuery(queryKey);
            assertThat(
                queryKey+" query is not null",
                query, notNullValue());
            assertThat(
                queryKey+" query is not empty",
                query.length(), greaterThan(0));
        }
    }

    @Test
    private void testPairQueriesExist() throws Exception {
        for (Relation rel : Relation.values()) {
            String queryKey = LookupService.PAIR_QUERY_PREFIX+rel.toString();
            String query = service.getQueryReader().getSparqlQuery(queryKey);
            assertThat(
                queryKey+" query is not null",
                query, notNullValue());
            assertThat(
                queryKey+" query is not empty",
                query.length(), greaterThan(0));
        }
    }

    @Test
    private void testQualifierQueriesExist() throws Exception {
        String queryKey = LookupService.ALLOWED_QUALIFERS_ID;
        String query = service.getQueryReader().getSparqlQuery(queryKey);
        assertThat(
            queryKey+" query is not null",
            query, notNullValue());
        assertThat(
            queryKey+" query is not empty",
            query.length(), greaterThan(0));
    }
}
