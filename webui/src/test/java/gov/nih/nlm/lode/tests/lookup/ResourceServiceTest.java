package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import java.util.Arrays;
import java.util.Collection;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import gov.nih.nlm.lode.service.JenaResourceServiceImpl;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

/**
 * Test the resource service can actually run queries
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class ResourceServiceTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private JenaResourceService service;


    @Test
    public void testWiring() {
        assertThat(service, notNullValue());
        assertThat(service, instanceOf(JenaResourceServiceImpl.class));
    }

    @Test
    public void testDescriptorExactMatch() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "SELECT ?resource ?label",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label ?label .",
                "  ?resource rdfs:label ?bound .",
                "} ORDER BY ?label"
        });

        Collection<String> expectedUris = Arrays.asList(Pyrin.EXACT_MATCH_URIS);
        Collection<ResourceAndLabel> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        Collection<String> actualUris = actualList.stream()
                .map(rs -> rs.getResource())
                .collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testBifBinding() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "PREFIX bif: <bif:>",
                "SELECT ?resource ?label",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label ?label .",
                "  ?label bif:contains ?bound .",
                "} ORDER BY ?label"
        });

        Collection<String> expectedUris = Arrays.asList(Pyrin.CONTAINS_MATCH_URIS);
        Collection<ResourceAndLabel> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        Collection<String> actualUris = actualList.stream()
                .map(rs -> rs.getResource())
                .collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testBindingStrStarts() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "SELECT ?resource ?label",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label ?label .",
                "  FILTER(STRSTARTS(?label, STR(?bound))) .",
                "} ORDER BY ?label"
        });

        Collection<String> expectedUris = Arrays.asList(Pyrin.STARTSWITH_MATCH_URIS);
        Collection<ResourceAndLabel> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        Collection<String> actualUris = actualList.stream()
                .map(rs -> rs.getResource())
                .collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

}
