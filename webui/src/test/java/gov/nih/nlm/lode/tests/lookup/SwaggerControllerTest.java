package gov.nih.nlm.lode.tests.lookup;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.net.URISyntaxException;

import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.SwaggerController;

/**
 * Test that the swagger controller generates/translates the swagger specification appropriately.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class SwaggerControllerTest extends AbstractTestNGSpringContextTests {

    private MockMvc mvc;

    @BeforeClass
    public void setUp() throws URISyntaxException {
        SwaggerController controller = new SwaggerController();
        Resource swaggerSpec = new InputStreamResource(getClass().getClassLoader().getResourceAsStream("swagger.yaml"));
        controller.setSwaggerResource(swaggerSpec);
        mvc = MockMvcBuilders.standaloneSetup(controller).build();
    }

    public void specGuts(String host, String scheme) throws Exception {
        MockHttpServletRequestBuilder request =
                get("/swagger/swagger")
                .header("Host", host);
        mvc.perform(request)
                    .andExpect(status().isOk())
                    .andExpect(content().contentType("application/json;charset=UTF-8"))
                    .andExpect(jsonPath("$.host").value(host))
                    .andExpect(jsonPath("$.schemes").isArray())
                    .andExpect(jsonPath("$.schemes").value(scheme))
                    .andExpect(jsonPath("$.baseUri").value("/testing"));
    }

    @Test
    public void testSpecAsPetstore() throws Exception {
        specGuts("petstore.swagger.io", "https");
    }

    @Test
    public void testSpecOnLocalhost() throws Exception {
        specGuts("localhost:8081", "http");
    }

    public void uiGuts(String host, String scheme) throws Exception {
        String expectedUri = String.format("%s://%s/testing/swagger/swagger.json", scheme, host);
        MockHttpServletRequestBuilder request =
                get("/swagger/ui")
                .header("Host", host);
        mvc.perform(request)
                    .andExpect(status().isOk())
                    .andExpect(content().contentType("text/html"))
                    .andExpect(model().attribute("specUri", expectedUri));
    }

    @Test
    public void testUIOnLocalhost() throws Exception {
        uiGuts("localhost", "http");
    }

    @Test
    public void testUIAsPetstore() throws Exception {
        uiGuts("petstore.swagger.io", "https");
    }

    @Test
    public void testRedirectToUI() throws Exception {
        MockHttpServletRequestBuilder request = get("/swagger");
        mvc.perform(request)
            .andExpect(status().isTemporaryRedirect())
            .andExpect(header().string("Location", "/testing/swagger/ui"));
    }
}
