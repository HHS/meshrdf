package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.greaterThan;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Collection;
import java.util.stream.Collectors;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.DescriptorCriteria;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.Relation;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import gov.nih.nlm.lode.servlet.LookupServiceImpl;

/**
 * Test the content type and error handling of the LookupService.
 * Note that these tests depend on Virtuoso and so are data dependendent
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

    @Test
    public void testDescriptorExact() throws Exception {
        DescriptorCriteria criteria = new DescriptorCriteria();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.EXACT_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorContains() throws Exception {
        DescriptorCriteria criteria = new DescriptorCriteria();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setRelation(Relation.CONTAINS);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorStartsWith() throws Exception {
        DescriptorCriteria criteria = new DescriptorCriteria();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setRelation(Relation.STARTSWITH);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.STARTSWITH_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorLimit() throws Exception {
        DescriptorCriteria criteria = new DescriptorCriteria();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setRelation(Relation.CONTAINS);
        criteria.setLimit(2);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS).subList(0,  2);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void test
}
