package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.instanceOf;
import static org.hamcrest.CoreMatchers.notNullValue;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.greaterThan;

import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.JenaResourceService;
import gov.nih.nlm.lode.model.ResourceResult;
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


    /*
     * "Athlete's Heart" is stored in the full-text index as athlete, s and heart.
     * UAX#29 keeps an apostrophe between two letters inside the Lucene token, so
     * "athlete's" used to be appended raw into this single-quoted argument, which
     * left a stray quote in it and asked for a token the index does not hold.
     */
    @Test
    public void testContainsArgSplitsOnApostrophe() throws LodeException {
        JenaResourceServiceImpl impl = (JenaResourceServiceImpl) service;

        assertThat(impl.buildContainsArg("athlete's heart"), equalTo("'athlete* s heart* '"));
        assertThat(impl.buildContainsArg("morgagni's hernia"), equalTo("'morgagni* s hernia* '"));

        // A trailing apostrophe and one between a digit and a hyphen are already
        // dropped by the tokenizer, so these must not change.
        assertThat(impl.buildContainsArg("wilms' tumor gene"), equalTo("'wilms* tumor* gene* '"));
        assertThat(impl.buildContainsArg("abacavir 5'-phosphate"), equalTo("'abacavir* 5 phosphate* '"));

        // No apostrophe at all, unchanged.
        assertThat(impl.buildContainsArg("crohn disease"), equalTo("'crohn* disease* '"));
    }

    /* The argument is a single-quoted literal, so it must not contain a stray quote. */
    @Test
    public void testContainsArgIsWellQuoted() throws LodeException {
        JenaResourceServiceImpl impl = (JenaResourceServiceImpl) service;

        for (String label : new String[] {
            "athlete's heart", "morgagni's hernia", "wilms' tumor gene",
            "abacavir 5'-phosphate", "crohn disease",
        }) {
            String arg = impl.buildContainsArg(label);
            String body = arg.substring(1, arg.length() - 1);
            assertThat("stray quote for label " + label, body.indexOf('\''), equalTo(-1));
        }
    }

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
                "  BIND(LCASE(STR(?label)) AS ?lowerlabel) .",
                "  FILTER(?lowerlabel = ?bound) .",
                "} ORDER BY ?label"
        });

        Collection<String> expectedUris = Arrays.asList(Pyrin.EXACT_MATCH_URIS);
        Collection<ResourceResult> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        long countOfPreferred = actualList.stream().filter(rs -> rs.getPreferred() != null).count();
        assertThat(countOfPreferred, equalTo(0L));
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
        Collection<ResourceResult> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        long countOfPreferred = actualList.stream().filter(rs -> rs.getPreferred() != null).count();
        assertThat(countOfPreferred, equalTo(0L));
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
                "  BIND(LCASE(STR(?label)) AS ?lowerlabel) . ",
                "  FILTER(STRSTARTS(?lowerlabel, ?bound)) .",
                "} ORDER BY ?label"
        });

        Collection<String> expectedUris = Arrays.asList(Pyrin.STARTSWITH_MATCH_URIS);
        Collection<ResourceResult> actualList = service.getResources(query, Pyrin.DESCRIPTOR_LABEL, 10);
        long countOfPreferred = actualList.stream().filter(rs -> rs.getPreferred() != null).count();
        assertThat(countOfPreferred, equalTo(0L));
        Collection<String> actualUris = actualList.stream()
                .map(rs -> rs.getResource())
                .collect(Collectors.toList());
        assertThat(actualUris, equalTo(expectedUris));
    }

    @Test
    public void testConceptsPreferred() throws LodeException {
        String query = String.join("\n", new String[] {
                "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
                "PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>",
                "PREFIX meshv: <http://id.nlm.nih.gov/mesh/vocab#>",
                "PREFIX mesh: <http://id.nlm.nih.gov/mesh/>",
                "",
                "SELECT ?resource ?label ?preferred",
                "FROM <http://id.nlm.nih.gov/mesh>",
                "WHERE {",
                "  ?parent a meshv:TopicalDescriptor .",
                "  {",
                "    ?parent meshv:preferredConcept ?resource . ",
               "    BIND(xsd:boolean(1) AS ?preferred) . ",
                "  } UNION {",
                "    ?parent meshv:concept ?resource .",
                "    BIND(xsd:boolean(0) AS ?preferred) .",
                "  } .",
                "  ?resource rdfs:label ?label .",
                "} ORDER BY DESC(?preferred) ?label"
        });

        /*  NOTE: serves to test getChildResources, but also serves to check preferred binding */
        Collection<ResourceResult> actualList = service.getChildResources(query, "http://id.nlm.nih.gov/mesh/D013498");
        assertThat(actualList.size(), greaterThan(3));

        long countWithoutPreferred = actualList.stream().filter(rs -> rs.getPreferred() == null).count();
        assertThat(countWithoutPreferred, equalTo(0L));

        ResourceResult first = ((List<ResourceResult>) actualList).get(0);
        assertThat(first, equalTo(new ResourceResult("http://id.nlm.nih.gov/mesh/M0020853", "Suramin", true)));

        ResourceResult last = ((List<ResourceResult>) actualList).get(3);
        assertThat(last, equalTo(new ResourceResult("http://id.nlm.nih.gov/mesh/M0351762", "Naganin", false)));
    }
}
