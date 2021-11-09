package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.startsWith;
import static org.hamcrest.MatcherAssert.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;

import org.springframework.http.MediaType;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.service.ConfigServiceImpl;
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
    private ConfigService mockConfig;
    private MockMvc mvc;
    private MockServletContext context;

    @BeforeClass
    public void setUp() throws URISyntaxException {
        context = new MockServletContext();
        context.setInitParameter(ConfigService.MESHRDF_YEAR, "2018");
        context.setInitParameter(ConfigService.MESHRDF_INTERIM, "true");
        mockService = new MockLookupService();
        mockConfig = new ConfigServiceImpl(context);
        LookupController controller = new LookupController(mockService, mockConfig);
        controller.setBaseUri(new URI("http://id.nlm.nih.gov/mesh/"));
        mvc = MockMvcBuilders.standaloneSetup(controller).build();
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        mockService.clear();
    }

    @Test
    public void testGetDescriptorJson() throws Exception {
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
        assertThat(mockService.desc.getYear(), equalTo("current"));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testGetDescriptorYearInterim() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("label",  "fubar")
                .param("match", "contains")
                .param("year", "interim")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("fubar"));
        assertThat(mockService.desc.getMatch(), equalTo(LabelMatch.CONTAINS));
        assertThat(mockService.desc.getYear(), equalTo("2019"));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testGetDescriptorYear2018() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("label",  "fubar")
                .param("match", "contains")
                .param("year", "2018")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("fubar"));
        assertThat(mockService.desc.getMatch(), equalTo(LabelMatch.CONTAINS));
        assertThat(mockService.desc.getYear(), equalTo("2018"));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testPostDescriptorJson() throws Exception {
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
        assertThat(mockService.desc.getYear(), equalTo("current"));
    }

    @Test
    public void testPostDescriptorForm() throws Exception {
        String body = "label=density&year=2019";
        MockHttpServletRequestBuilder request =
                post("/lookup/descriptor")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/D1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/D2"));
        assertThat(mockService.count, equalTo(1));
        assertThat(mockService.desc.getLabel(), equalTo("density"));
        assertThat(mockService.desc.getMatch(), equalTo(LabelMatch.EXACT));
        assertThat(mockService.desc.getYear(), equalTo("2019"));
        assertThat(mockService.desc.getLimit(), equalTo(10));
    }

    @Test
    public void testGetPair() throws Exception {
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
    public void testPostPairJson() throws Exception {
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
        assertThat(mockService.pair.getDescriptor(), equalTo("http://id.nlm.nih.gov/nosuchthing"));
    }

    @Test
    public void testPostPairForm() throws Exception {
        String descriptorParam = "http://should.be/decoded/";
        String body = "label=smoky&limit=20&descriptor="+URLEncoder.encode(descriptorParam, "ascii");
        MockHttpServletRequestBuilder request =
                post("/lookup/pair")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
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
        assertThat(mockService.pair.getDescriptor(), equalTo(descriptorParam));
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
    public void testGetDescriptorYearFubarIsInvalid() throws Exception {
        /*
         * This tests a couple of things:
         *   - The get request is validated
         *   - The meshYear may not be "fubar"
         */
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("year", "fubar")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.year[0]").value("must be current, interim, or a positive number"));

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
    public void testPostDescriptorYearFubarIsInvalid() throws Exception {
        /*
         * This tests a couple of things:
         *   - The POST request is validated
         *   - The meshYear may not be "fubar"
         */
        String body = String.join("\n",  new String[] {
                "{",
                "\"label\": \"smoky\",",
                "\"year\": \"fubar\"",
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
            .andExpect(jsonPath("$.error.year[0]").value("must be current, interim, or a positive number"));

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
    public void testDescriptorJSONParseError() throws Exception {
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

    @Test
    public void testPairGetDescriptorRequired() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/pair")
                .param("label",  "fubar")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.descriptor").value("must not be empty"));
    }

    @Test
    public void testPostPairDescriptorRequired() throws Exception {
        String body = "{\"label\": \"barfu\"}";
        MockHttpServletRequestBuilder request =
                post("/lookup/pair")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.descriptor").value("must not be empty"));
    }

    @Test
    public void testAllowedQualifiers() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/qualifiers")
                .param("descriptor", "/SOMETHING")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0].resource").value("http://id.nlm.nih.gov/mesh/Q1"))
            .andExpect(jsonPath("$[1].resource").value("http://id.nlm.nih.gov/mesh/Q2"));
        assertThat(mockService.count, equalTo(1));
        // NOTE: this is resolved relative to the main URI
        assertThat(mockService.descriptorUri, equalTo("http://id.nlm.nih.gov/SOMETHING"));
    }

    @Test
    public void testAllowedQualifiersDescriptorMissing() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/qualifiers")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.descriptor").value("must not be empty"));
    }

    @Test
    public void testAllowedQualifiersDescriptorEmpty() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/qualifiers")
                .param("descriptor", "")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.descriptor").value("must not be empty"));
    }

    @Test
    public void testDescriptorDetails() throws Exception {
        // NOTE: These are mock results from the MockLookupService
        MockHttpServletRequestBuilder request =
                get("/lookup/details")
                .param("descriptor", "D013498")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.descriptor").value("http://id.nlm.nih.gov/mesh/D013498"))
            .andExpect(jsonPath("$.seealso").isArray())
            .andExpect(jsonPath("$.terms").isArray())
            .andExpect(jsonPath("$.qualifiers").isArray())
            .andExpect(jsonPath("$.seealso.length()", Integer.class).value(2))
            .andExpect(jsonPath("$.terms.length()", Integer.class).value(4))
            .andExpect(jsonPath("$.qualifiers.length()", Integer.class).value(2));

        assertThat(mockService.count, equalTo(3));
    }

    @Test
    public void testDescriptorDetailsSeeAlso() throws Exception {
        // NOTE: These are mock results from the MockLookupService
        MockHttpServletRequestBuilder request =
                get("/lookup/details")
                .param("descriptor", "D013498")
                .param("includes", "seealso")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.descriptor").value("http://id.nlm.nih.gov/mesh/D013498"))
            .andExpect(jsonPath("$.seealso").isArray())
            .andExpect(jsonPath("$.seealso.length()", Integer.class).value(2))
            .andExpect(jsonPath("$.terms").doesNotExist())
            .andExpect(jsonPath("$.qualifiers").doesNotExist());

        assertThat(mockService.count, equalTo(1));
    }

    @Test
    public void testDescriptorDetailsYear() throws Exception {
        // NOTE: These are mock results from the MockLookupService
        MockHttpServletRequestBuilder request =
                get("/lookup/details")
                .param("descriptor", "http://id.nlm.nih.gov/mesh/2021/D013498")
                .param("includes", "seealso,terms,qualifiers")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.descriptor").value("http://id.nlm.nih.gov/mesh/2021/D013498"))
            .andExpect(jsonPath("$.seealso").isArray())
            .andExpect(jsonPath("$.terms").isArray())
            .andExpect(jsonPath("$.qualifiers").isArray())
            .andExpect(jsonPath("$.seealso.length()", Integer.class).value(2))
            .andExpect(jsonPath("$.terms.length()", Integer.class).value(4))
            .andExpect(jsonPath("$.qualifiers.length()", Integer.class).value(2));

        assertThat(mockService.count, equalTo(3));
    }

    @Test
    public void testLabels() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/label")
                .param("resource", "MOSS")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0]").value("Mean Older Sibling Syndrome"));
        assertThat(mockService.count, equalTo(1));

        // NOTE: this test that URI is treated as relative
        assertThat(mockService.resourceUri, equalTo("http://id.nlm.nih.gov/mesh/MOSS"));
    }

    @Test
    public void testLabelsResourceMissing() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/label")
               .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.resource").value("must not be empty"));
    }

    @Test
    public void testLabelsResourceEmpty() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/label")
                .param("resource", "")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$.error.resource").value("must not be empty"));
    }

    @Test
    public void testGetValidYears() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/years")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
           .andExpect(status().isOk())
           .andExpect(content().contentType("application/json;charset=UTF-8"))
           .andExpect(jsonPath("$[0]").value("current"))
           .andExpect(jsonPath("$[1]").value("interim"))
           .andExpect(jsonPath("$[2]").value("2019"))
           .andExpect(jsonPath("$[3]").value("2018"));
    }
}
