package gov.nih.nlm.lode.tests;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
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
 * Test the Query page validation that is used only to validate syntax and so on.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class QueryPageControllerTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeClass
    public void setUp() {
        // NOTE - now that we are validating ourself, we may don't need standaloneSetup.
        // mvc = MockMvcBuilders.standaloneSetup(controller).build();
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testWithoutParams() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/editor")
               .accept(MediaType.TEXT_HTML);
        mvc.perform(request)
            .andExpect(status().isOk());
    }

    @Test
    public void testWithParams() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/editor")
               .param("query", "not validated here")
               .param("year", "current")
               .param("format", "HTML")
               .param("offset", "0")
               .param("limit", "25")
               .accept(MediaType.TEXT_HTML);
        mvc.perform(request)
            .andExpect(status().isOk());
    }

    @Test
    public void testInvalidLimit() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/editor")
               .param("limit", "2000")
               .accept(MediaType.TEXT_HTML);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(status().reason("Invalid Query Parameters"));
    }

    @Test
    public void testInvalidFormat() throws Exception {
        MockHttpServletRequestBuilder request =
                get("/editor")
               .param("format", "QSV")
               .accept(MediaType.TEXT_HTML);
        mvc.perform(request)
            .andExpect(status().isBadRequest())
            .andExpect(status().reason("Invalid Query Parameters"));
    }
}
