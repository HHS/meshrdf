package gov.nih.nlm.lode.tests;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import org.testng.SkipException;
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
public class StatusControllerTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeClass(alwaysRun=true)
    public void setUp() {
        /*
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
         */
    }

    @Test
    public void testStatus() throws Exception {
        throw new SkipException("Not yet implemented");
        /*
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
        MvcResult result = mvc.perform(get("/servlet/status"))
                .andExpect(status().isOk())
                .andReturn();
         */
    }
}
