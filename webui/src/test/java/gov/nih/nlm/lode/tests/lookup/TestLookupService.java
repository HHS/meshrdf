package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.hasItem;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.greaterThan;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import gov.nih.nlm.lode.model.SemanticSearchParams;
import gov.nih.nlm.lode.service.LookupServiceImpl;

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
        for (LabelMatch rel : LabelMatch.values()) {
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
        for (LabelMatch rel : LabelMatch.values()) {
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
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.EXACT_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorContains() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setMatch(LabelMatch.CONTAINS);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorStartsWith() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setMatch(LabelMatch.STARTSWITH);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.STARTSWITH_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testDescriptorLimit() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setMatch(LabelMatch.CONTAINS);
        criteria.setLimit(2);

        Collection<ResourceAndLabel> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS).subList(0,  2);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testPairExactNone() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setDescriptor(Pyrin.EXACT_MATCH_URIS[0]);
        criteria.setLabel("chemical");
        criteria.setMatch(LabelMatch.EXACT);

        Collection<ResourceAndLabel> results = serviceIntf.lookupPairs(criteria);
        assertThat(results.size(), equalTo(0));
    }

    @Test
    public void testPairExact() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel("chemistry");
        criteria.setMatch(LabelMatch.EXACT);

        Collection<ResourceAndLabel> results = serviceIntf.lookupPairs(criteria);
        assertThat(results.size(), equalTo(1));

        for (ResourceAndLabel result : results) {
            assertThat(result.getResource(), equalTo(Pyrin.CHEMI_QUALIFIER_URIS[1]));
            assertThat(result.getLabel(), equalTo(Pyrin.CHEMI_QUALIFIER_LABELS[1]));
        }
    }

    @Test
    public void testPairContains() throws Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel("chemi");
        criteria.setMatch(LabelMatch.CONTAINS);

        Collection<ResourceAndLabel> results = serviceIntf.lookupPairs(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CHEMI_QUALIFIER_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));

        Collection<String> expectedLabels = Arrays.asList(Pyrin.CHEMI_QUALIFIER_LABELS);
        Collection<String> actualLabels = results.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, equalTo(expectedLabels));
    }

    @Test
    public void testPairStartswith() throws  Exception {
        SemanticSearchParams criteria = new SemanticSearchParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel("chemic");
        criteria.setMatch(LabelMatch.STARTSWITH);

        Collection<ResourceAndLabel> results = serviceIntf.lookupPairs(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CHEMI_QUALIFIER_URIS).subList(0,  1);;
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));

        Collection<String> expectedLabels = Arrays.asList(Pyrin.CHEMI_QUALIFIER_LABELS).subList(0,  1);
        Collection<String> actualLabels = results.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, equalTo(expectedLabels));
    }

    @Test
    public void testAllowedQualifiers() throws Exception {
        Collection<ResourceAndLabel> actualResults = serviceIntf.allowedQualifiers(Pyrin.DESCRIPTOR_URI);
        assertThat(actualResults.size(), greaterThan(1));

        List<String> actualLabels = actualResults.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, hasItem(equalTo("chemistry")));
    }

    @Test
    public void testLookupLabelNoMatch() throws Exception {
        Collection<String> actualLabels = serviceIntf.lookupLabel("http://id.nlnm.nih.gov/mesh/D0123456789");
        assertThat(actualLabels.size(), equalTo(0));
    }

    @Test
    public void testLookupLabel() throws Exception {
        Collection<String> actualLabels = serviceIntf.lookupLabel(Pyrin.DESCRIPTOR_URI);
        assertThat(actualLabels.size(), equalTo(1));
        assertThat(actualLabels, equalTo(Collections.singletonList(Pyrin.DESCRIPTOR_LABEL)));
    }
}
