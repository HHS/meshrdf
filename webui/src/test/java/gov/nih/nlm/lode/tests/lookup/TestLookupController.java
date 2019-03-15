package gov.nih.nlm.lode.tests.lookup;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;


/**
 * Test the content type and error handling of the LookupController
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class TestLookupController extends AbstractTestNGSpringContextTests {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeClass(alwaysRun=true)
    public void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testGetDescriptors() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/descriptor")
                .param("label",  "fubar")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0]").value("http://id.nlm.nih.gov/mesh/D01882"))
            .andExpect(jsonPath("$[1]").value("http://id.nlm.nih.gov/mesh/D01883"));
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
            .andExpect(jsonPath("$[0]").value("http://id.nlm.nih.gov/mesh/D01882"))
            .andExpect(jsonPath("$[1]").value("http://id.nlm.nih.gov/mesh/D01883"));
    }

    @Test
    public void testGetPairs() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/lookup/pair")
                .param("label",  "fubar")
                .accept(MediaType.APPLICATION_JSON);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0]").value("http://id.nlm.nih.gov/mesh/Q01882"))
            .andExpect(jsonPath("$[1]").value("http://id.nlm.nih.gov/mesh/Q01883"));

    }

    @Test
    public void testPostPairs() throws Exception {
        String body = "{\"label\": \"fubar\"}";
        MockHttpServletRequestBuilder request =
                post("/lookup/pair")
                .accept(MediaType.APPLICATION_JSON)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body);
        mvc.perform(request)
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=UTF-8"))
            .andExpect(jsonPath("$[0]").value("http://id.nlm.nih.gov/mesh/Q01882"))
            .andExpect(jsonPath("$[1]").value("http://id.nlm.nih.gov/mesh/Q01883"));
    }
}