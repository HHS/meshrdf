package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.startsWith;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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

import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.servlet.LookupController;


/**
 * Test the content type and nominal processing of the LookupController,
 * using a LookupConttroller that has a mocked lookupService.
 *
 * These are all nominal tests that do not exercise validation.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class LookupControllerTest extends AbstractTestNGSpringContextTests {

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
                .param("match", "contains")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("fubar"));
        assertThat(mockService.desc.getMatch(), equalTo(LabelMatch.CONTAINS));
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
        assertThat(mockService.desc.getMatch(), equalTo(LabelMatch.EXACT));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testGetPairs() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/pair")
                .param("descriptor", "http://id.nlm.nih.gov/nosuchthing")
                .param("label",  "barfu")
                .param("match", "startswith")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/DQ1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/DQ2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.pair.getLabel(), equalTo("barfu"));
        assertThat(mockService.pair.getMatch(), equalTo(LabelMatch.STARTSWITH));
        assertThat(mockService.pair.getLimit(), equalTo(10));
        assertThat(mockService.pair.getDescriptor(), equalTo("http://id.nlm.nih.gov/nosuchthing"));
    }

    @Test
    public void testPostPairs() throws Exception {
        String body = String.join("\n",  new String[] {
                "{",
                "\"label\": \"smoky\",",
                "\"descriptor\": \"http://id.nlm.nih.gov/nosuchthing\",",
                "\"limit\": 20",
                "}",
        });
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
        assertThat(mockService.pair.getMatch(), equalTo(LabelMatch.EXACT));
        assertThat(mockService.pair.getLimit(), equalTo(20));
    }

    @Test
    public void testDescriptorGetValidated() throws Exception {
        /*
         * This tests a couple of things:
         *   - The get request is validated
         *   - The label is required
         *   - The limit must be positive
         *   - When errors occur, JSON is returned in our approved format
         */
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("limit", "-4")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.label[0]").value("must not be empty"))
            .andExpect(jsonPath("$.error.limit[0]").value("must be greater than 0"));

        // The service should not have been called, because there was an error before that
        assertThat(mockService.count, equalTo(0));
    }

    @Test
    public void testDescriptorPostValidated() throws Exception {
        /*
         * This tests a couple of things:
         *   - The post request is validated
         *   - The limit <= 50
         *   - When errors occur, JSON is returned in our approved format
         */
        String body = String.join("\n",  new String[] {
                "{",
                "\"label\": null,",
                "\"limit\": 71",
                "}",
        });
        MockHttpServletRequestBuilder request =
                post("/lookup/descriptor")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.label[0]").value("must not be empty"))
            .andExpect(jsonPath("$.error.limit[0]").value("must be less than or equal to 50"));

        // The service should not have been called, because there was an error before that
        assertThat(mockService.count, equalTo(0));
    }

    @Test
    public void testDescriptorMatchValidationGet() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("label", "fubar")
                .param("match", "invalid_enum_value")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.label").doesNotExist())
            .andExpect(jsonPath("$.error.match[0]").value("must be one of \"contains\", \"exact\", or \"startswith\""));

        // The service should not have been called, because there was an error before that
        assertThat(mockService.count, equalTo(0));
    }

    @Test
    public void testDescriptorMatchalidationPost() throws Exception {
        String body = String.join("\n",  new String[] {
                "{",
                "\"label\": \"fubar\",",
                "\"match\": \"invalid_enum_value\"",
                "}",
        });
        MockHttpServletRequestBuilder request =
                post("/lookup/descriptor")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.label").doesNotExist())
            .andExpect(jsonPath("$.error.match[0]").value("must be one of \"contains\", \"exact\", or \"startswith\""));

        // The service should not have been called, because there was an error before that
        assertThat(mockService.count, equalTo(0));
    }

    @Test
    public void testJSONParseError() throws Exception {
        String body = String.join("\n",  new String[] {
                "{",
                "\"label\": \"fubar\",",
                "bad json",
                "}",
        });
        MockHttpServletRequestBuilder request =
                post("/lookup/descriptor")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.general[0]").value(startsWith("JSON Parse Error")));

        // The service should not have been called, because there was an error before that
        assertThat(mockService.count, equalTo(0));
    }
}
