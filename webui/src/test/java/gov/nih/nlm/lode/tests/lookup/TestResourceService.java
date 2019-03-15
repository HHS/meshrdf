package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import java.util.Arrays;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.servlet.JenaResourceServiceImpl;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

/**
 * Test the resource service can actually run queries
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class TestResourceService extends AbstractTestNGSpringContextTests {

    @Autowired
    private JenaResourceService service;


    private static String DESCRIPTOR_LABEL = "Pyrin";
    private static String[] EXPECTED_DESCRIPTORS = new String[] { "http://id.nlm.nih.gov/mesh/D000071198" };

    @Test
    public void testWiring() {
        assertThat(service, notNullValue());
        assertThat(service, instanceOf(JenaResourceServiceImpl.class));
    }

    @Test
    public void testResourceQueryWithoutBinding() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "SELECT ?resource",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label \"Pyrin\"@en .",
                "}"
        });

        Collection<String> expected = Arrays.asList(EXPECTED_DESCRIPTORS);
        Collection<String> actual = service.getResourcesFromLabel(query, DESCRIPTOR_LABEL, 10);
        assertThat(actual, equalTo(expected));
    }

    @Test
    public void testResourceQueryWithBinding() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "SELECT ?resource",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label ?bound .",
                "}"
        });

        Collection<String> expected = Arrays.asList(EXPECTED_DESCRIPTORS);
        Collection<String> actual = service.getResourcesFromLabel(query, DESCRIPTOR_LABEL, 10);
        assertThat(actual, equalTo(expected));
    }

    @Test
    public void testBifBinding() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "SELECT ?resource ?label ",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?resource a meshv:TopicalDescriptor .",
                "  ?resource rdfs:label ?label .",
                "  ?resource bif:contains ?bound .",
                "} ORDER BY ?label"
        });


    }
}
