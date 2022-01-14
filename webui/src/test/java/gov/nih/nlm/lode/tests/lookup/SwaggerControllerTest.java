package gov.nih.nlm.lode.tests.lookup;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.service.ConfigServiceImpl;
import gov.nih.nlm.lode.servlet.SwaggerController;

/**
 * Test that the swagger controller generates/translates the swagger specification appropriately.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
public class SwaggerControllerTest extends AbstractTestNGSpringContextTests {

    private MockMvc mvc;
    private MockServletContext context;
    private ConfigService mockConfig;

    @BeforeClass(groups = "unit")
    public void setUp() {
        context = new MockServletContext();
        context.setInitParameter(ConfigService.MESHRDF_YEAR, "2018");
        context.setInitParameter(ConfigService.MESHRDF_INTERIM, "true");
        mockConfig = new ConfigServiceImpl(context);
        SwaggerController controller = new SwaggerController(mockConfig);
        Resource swaggerSpec = new InputStreamResource(getClass().getClassLoader().getResourceAsStream("swagger.yaml"));
        controller.setSwaggerResource(swaggerSpec);
        mvc = MockMvcBuilders.standaloneSetup(controller).build();
    }

    public void specGuts(String host, String scheme) throws Exception {
        /*
         * This one tests that X-Forwarded-Host takes precedence
         */
        MockHttpServletRequestBuilder request =
                get("/swagger/swagger")
                .header("X-Forwarded-Host", host)
                .header("Host", "127.0.0.1:8080");
        mvc.perform(request)
                    .andExpect(status().isOk())
                    .andExpect(content().contentType("application/json"))
                    .andExpect(jsonPath("$.host").value(host))
                    .andExpect(jsonPath("$.schemes").isArray())
                    .andExpect(jsonPath("$.schemes").value(scheme))
                    .andExpect(jsonPath("$.baseUri").value("/testing"));
    }

    @Test(groups = "unit")
    public void testSpecAsPetstore() throws Exception {
        specGuts("petstore.swagger.io", "https");
    }

    @Test(groups = "unit")
    public void testSpecOnLocalhost() throws Exception {
        specGuts("localhost:8081", "http");
    }

    public void uiGuts(String host, String scheme) throws Exception {
        /*
         * This one tests the fall-back to the Host header
         */
        String expectedUri = String.format("%s://%s/testing/swagger/swagger", scheme, host);
        MockHttpServletRequestBuilder request =
                get("/swagger/ui")
                .header("Host", host);
        mvc.perform(request)
                    .andExpect(status().isOk())
                    .andExpect(content().contentType("text/html"))
                    .andExpect(model().attribute("specUri", expectedUri));
    }

    @Test(groups = "unit")
    public void testUIOnLocalhost() throws Exception {
        uiGuts("localhost", "http");
    }

    @Test(groups = "unit")
    public void testUIAsPetstore() throws Exception {
        uiGuts("petstore.swagger.io", "https");
    }

    @Test(groups = "unit")
    public void testRedirectToUI() throws Exception {
        MockHttpServletRequestBuilder request = get("/swagger");
        mvc.perform(request)
            .andExpect(status().isTemporaryRedirect())
            .andExpect(header().string("Location", "/testing/swagger/ui"));
    }
}
