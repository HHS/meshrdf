package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.hasItem;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.not;
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
import org.apache.jena.query.QueryException;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.query.Syntax;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.DescriptorParams;
import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairParams;
import gov.nih.nlm.lode.model.ResourceResult;
import gov.nih.nlm.lode.service.LookupServiceImpl;

/**
 * Test the content type and error handling of the LookupService.
 * Note that these tests depend on Virtuoso and so are data dependendent
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
public class LookupServiceTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private LookupService serviceIntf;

    @Test(groups = "unit")
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


    public void queryExistsGuts(String queryKey) throws Exception {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        String query = service.getQuery(queryKey);
        assertThat(
                queryKey+": query is not null",
                query, notNullValue());
            assertThat(
                queryKey+": query is not empty",
                query.length(), greaterThan(0));

        try {
            QueryFactory.create(query, Syntax.syntaxARQ);
        } catch (QueryException e) {
            assertThat(queryKey+": query should parse properly", not(true));
        }
    }

    @Test(groups = "unit")
    public void testGetGraphUriCurrent() {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        String graphUri = service.getGraphUri("current");
        assertThat(graphUri, equalTo("http://id.nlm.nih.gov/mesh"));
    }

    @Test(groups = "unit")
    public void testGetGraphUriNumeric() {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        String graphUri = service.getGraphUri("2018");
        assertThat(graphUri, equalTo("http://id.nlm.nih.gov/mesh/2018"));
    }

    @Test(groups = "unit", enabled=false)
    public void testGetGraphUriInterim() {
        LookupServiceImpl service = (LookupServiceImpl) serviceIntf;
        String graphUri = service.getGraphUri("interim");
        assertThat(graphUri, equalTo("http://id.nlm.nih.gov/mesh/2021"));
    }

    @Test(groups = "unit")
    public void testDescriptorQueriesExist() throws Exception {
        for (LabelMatch rel : LabelMatch.values()) {
            String queryKey = LookupServiceImpl.DESCRIPTOR_QUERY_PREFIX+rel.toString().toLowerCase();
            queryExistsGuts(queryKey);
        }
    }

    @Test(groups = "unit")
    public void testPairQueriesExist() throws Exception {
        for (LabelMatch rel : LabelMatch.values()) {
            String queryKey = LookupServiceImpl.PAIR_QUERY_PREFIX+rel.toString().toLowerCase();
            queryExistsGuts(queryKey);
        }
    }

    @Test(groups = "unit")
    public void testTermQueriesExist() throws Exception {
        for (LabelMatch match : LabelMatch.values()) {
            String queryKey = LookupServiceImpl.TERM_QUERY_PREFIX+match.toString().toLowerCase();
            queryExistsGuts(queryKey);
        }
    }

    @Test(groups = "unit")
    public void testQualifierQueriesExist() throws Exception {
        queryExistsGuts(LookupServiceImpl.ALLOWED_QUALIFERS_ID);
    }

    @Test(groups = "unit")
    public void testDescriptorConceptsQueryExists() throws Exception {
        queryExistsGuts(LookupServiceImpl.DESCRIPTOR_CONCEPTS_ID);
    }

    @Test(groups = "unit")
    public void testDescriptorEntriesQuery() throws Exception {
        queryExistsGuts(LookupServiceImpl.DESCRIPTOR_TERMS_ID);
    }

    @Test(groups = "unit")
    public void testDescriptorSeeAlsoQuery() throws Exception {
        queryExistsGuts(LookupServiceImpl.DESCRIPTOR_SEEALSO_ID);
    }

    public void descriptorExactGuts(String label) throws Exception {
        DescriptorParams criteria = new DescriptorParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        Collection<ResourceResult> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.EXACT_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test(groups = "unit")
    public void testDescriptorExact() throws Exception {
        descriptorExactGuts(Pyrin.DESCRIPTOR_LABEL);
    }

    @Test(groups = "unit")
    public void testDescriptorExactUpper() throws Exception {
        // descriptor exact match should be case insensitive
        descriptorExactGuts(Pyrin.DESCRIPTOR_LABEL.toUpperCase());
    }

    @Test(groups = "unit")
    public void testDescriptorContains() throws Exception {
        DescriptorParams criteria = new DescriptorParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setMatch(LabelMatch.CONTAINS);

        Collection<ResourceResult> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    public void descriptorStartswithGuts(String label) throws Exception {
        DescriptorParams criteria = new DescriptorParams();
        criteria.setLabel(label);
        criteria.setMatch(LabelMatch.STARTSWITH);

        Collection<ResourceResult> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.STARTSWITH_MATCH_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test(groups = "unit")
    public void testDescriptorStartsWith() throws Exception {
        descriptorStartswithGuts(Pyrin.DESCRIPTOR_LABEL);
    }

    @Test(groups = "unit")
    public void testDescriptorLimit() throws Exception {
        DescriptorParams criteria = new DescriptorParams();
        criteria.setLabel(Pyrin.DESCRIPTOR_LABEL);
        criteria.setMatch(LabelMatch.CONTAINS);
        criteria.setLimit(2);

        Collection<ResourceResult> results = serviceIntf.lookupDescriptors(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS).subList(0,  2);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test(groups = "unit")
    public void testPairExactNone() throws Exception {
        PairParams criteria = new PairParams();
        criteria.setDescriptor(Pyrin.EXACT_MATCH_URIS[0]);
        criteria.setLabel("chemical");
        criteria.setMatch(LabelMatch.EXACT);

        Collection<ResourceResult> results = serviceIntf.lookupPairs(criteria);
        assertThat(results.size(), equalTo(0));
    }

    public void pairExactGuts(String qualifierLabel) throws Exception {
        PairParams criteria = new PairParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel(qualifierLabel);
        criteria.setMatch(LabelMatch.EXACT);

        Collection<ResourceResult> results = serviceIntf.lookupPairs(criteria);
        assertThat(results.size(), equalTo(1));

        for (ResourceResult result : results) {
            assertThat(result.getResource(), equalTo(Pyrin.CHEMI_QUALIFIER_URIS[1]));
            assertThat(result.getLabel(), equalTo(Pyrin.CHEMI_QUALIFIER_LABELS[1]));
        }
    }

    @Test(groups = "unit")
    public void testPairExact() throws Exception {
        pairExactGuts("chemistry");
    }

    @Test(groups = "unit")
    public void testPairExactUpper() throws Exception {
        // exact match should be case-insensitive
        pairExactGuts("CHEMISTRY");
    }

    @Test(groups = "unit")
    public void testPairContains() throws Exception {
        PairParams criteria = new PairParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel("chemi");
        criteria.setMatch(LabelMatch.CONTAINS);

        Collection<ResourceResult> results = serviceIntf.lookupPairs(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CHEMI_QUALIFIER_URIS);
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));

        Collection<String> expectedLabels = Arrays.asList(Pyrin.CHEMI_QUALIFIER_LABELS);
        Collection<String> actualLabels = results.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, equalTo(expectedLabels));
    }

    public void pairStartswithGuts(String qualifierLabel) throws Exception {
        PairParams criteria = new PairParams();
        criteria.setDescriptor(Pyrin.DESCRIPTOR_URI);
        criteria.setLabel(qualifierLabel);
        criteria.setMatch(LabelMatch.STARTSWITH);

        Collection<ResourceResult> results = serviceIntf.lookupPairs(criteria);
        Collection<String> expectedUris = Arrays.asList(Pyrin.CHEMI_QUALIFIER_URIS).subList(0,  1);;
        Collection<String> actualUris = results.stream().map(rl -> rl.getResource()).collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));

        Collection<String> expectedLabels = Arrays.asList(Pyrin.CHEMI_QUALIFIER_LABELS).subList(0,  1);
        Collection<String> actualLabels = results.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, equalTo(expectedLabels));

    }

    @Test(groups = "unit")
    public void testPairStartswith() throws  Exception {
        pairStartswithGuts("chemic");
    }

    @Test(groups = "unit")
    public void testPairStartswithUpper() throws Exception {
        // startswith match should be case-insensitive
        pairStartswithGuts("CHEMIC");
    }


    @Test(groups = "unit")
    public void testAllowedQualifiers() throws Exception {
        Collection<ResourceResult> actualResults = serviceIntf.allowedQualifiers(Pyrin.DESCRIPTOR_URI);
        assertThat(actualResults.size(), greaterThan(1));

        List<String> actualLabels = actualResults.stream().map(rl -> rl.getLabel()).collect(Collectors.toList());
        assertThat(actualLabels, hasItem(equalTo("chemistry")));
    }

    @Test(groups = "unit")
    public void testLookupLabelNoMatch() throws Exception {
        Collection<String> actualLabels = serviceIntf.lookupLabel("http://id.nlnm.nih.gov/mesh/D0123456789");
        assertThat(actualLabels.size(), equalTo(0));
    }

    @Test(groups = "unit")
    public void testLookupLabel() throws Exception {
        Collection<String> actualLabels = serviceIntf.lookupLabel(Pyrin.DESCRIPTOR_URI);
        assertThat(actualLabels.size(), equalTo(1));
        assertThat(actualLabels, equalTo(Collections.singletonList(Pyrin.DESCRIPTOR_LABEL)));
    }

    @Test(groups = "unit")
    public void testLookupTermExact() throws Exception {
        String expectedLabel = "Child Psychology";
        DescriptorParams criteria = new DescriptorParams();
        criteria.setLabel(expectedLabel);
        Collection<ResourceResult> actualTerms = serviceIntf.lookupTerms(criteria);
        assertThat(actualTerms.size(), greaterThan(0));

        List<String> actualLabels = actualTerms.stream()
                                               .map(r -> r.getLabel())
                                               .collect(Collectors.toList());
        assertThat(actualLabels.get(0), equalTo(expectedLabel));
    }
}
