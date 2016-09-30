package gov.nih.nlm.lode.tests;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.hamcrest.CoreMatchers.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;


/**
 * The underlying MeshStatus class has been covered with the MeshStatusTest.
 * The point of this test is just to verify the request methods of the
 * StatusController.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration
@Test(groups = "unit")
public class StatusControllerTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeClass(alwaysRun=true)
    public void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testStatus() throws Exception {
        mvc.perform(get("/status"))
                .andExpect(header().doesNotExist("Retry-After"))
                .andExpect(content().contentType("application/json; charset=utf-8"))
                .andExpect(jsonPath("$.httpdOK", is(true)))
                .andExpect(jsonPath("$.tomcatOK", is(true)))
                .andExpect(jsonPath("$.virtuosoOK", is(true)))
                .andExpect(jsonPath("$.meshdataOK", is(true)))
                .andExpect(jsonPath("$.updating", is(false)))
                .andExpect(jsonPath("$.updateError", is(false)))
                .andExpect(jsonPath("$.status", is(equalTo("Status: OK"))))
                .andExpect(status().isOk());
    }
}
