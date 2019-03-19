package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Arrays;
import java.util.Collection;

import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.DescriptorCriteria;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairCriteria;
import gov.nih.nlm.lode.model.Relation;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import gov.nih.nlm.lode.servlet.LookupController;
import uk.ac.ebi.fgpt.lode.exception.LodeException;


/**
 * Test the content type and error handling of the LookupController,
 * using a LookupConttroller that has a mocked lookupService.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class TestLookupController extends AbstractTestNGSpringContextTests {

    private class MockLookupService implements LookupService {
        public DescriptorCriteria desc = null;
        public PairCriteria pair = null;
        public int count = 0;

        @Override
        public Collection<ResourceAndLabel> lookupDescriptors(DescriptorCriteria criteria) throws LodeException {
            count++;
            this.desc= criteria;
            return Arrays.asList(new ResourceAndLabel[] {
               new ResourceAndLabel("http://id.nlm.nih.gov/mesh/D1", "First label"),
               new ResourceAndLabel("http://id.nlm.nih.gov/mesh/D2", "Later label")
            });
        }

        @Override
        public Collection<ResourceAndLabel> lookupPairs(PairCriteria criteria) throws LodeException {
            count++;
            this.pair = criteria;
            return Arrays.asList(new ResourceAndLabel[] {
                new ResourceAndLabel("http://id.nlm.nih.gov/mesh/DQ1", "First label"),
                new ResourceAndLabel("http://id.nlm.nih.gov/mesh/DQ2", "Later label")
             });
        }

        public void clear() {
            count = 0;
            desc = null;
            pair = null;
        }
    }

    private MockLookupService mockService;
    private MockMvc mvc;

    @BeforeClass
    public void setUp() {
        mockService = new MockLookupService();
        mvc = MockMvcBuilders.standaloneSetup(new LookupController(mockService)).build();
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        mockService.clear();
    }

    @Test
    public void testGetDescriptors() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("label",  "fubar")
                .param("relation", "contains")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("fubar"));
        assertThat(mockService.desc.getRelation(), equalTo(Relation.CONTAINS));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testPostDescriptors() throws Exception {
        String body = "{\"label\": \"fubar\"}";
        MockHttpServletRequestBuilder request =
                post("/lookup/descriptor")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("fubar"));
        assertThat(mockService.desc.getRelation(), equalTo(Relation.EXACT));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testGetPairs() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/pair")
                .param("descriptor", "http://id.nlm.nih.gov/nosuchthing")
                .param("label",  "barfu")
                .param("relation", "startswith")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/DQ1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/DQ2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.pair.getLabel(), equalTo("barfu"));
        assertThat(mockService.pair.getRelation(), equalTo(Relation.STARTSWITH));
        assertThat(mockService.pair.getLimit(), equalTo(10));
        assertThat(mockService.pair.getDescriptor(), equalTo("http://id.nlm.nih.gov/nosuchthing"));
    }

    @Test
    public void testPostPairs() throws Exception {
        String body = "{\"label\": \"smoky\", \"limit\": 20}";
        MockHttpServletRequestBuilder request =
                post("/lookup/pair")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/DQ1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/DQ2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.pair.getLabel(), equalTo("smoky"));
        assertThat(mockService.pair.getRelation(), equalTo(Relation.EXACT));
        assertThat(mockService.pair.getLimit(), equalTo(20));
    }
}