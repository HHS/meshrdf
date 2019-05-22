package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
public class LabelsDiagControllerTest extends AbstractTestNGSpringContextTests {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeClass(alwaysRun=true)
    public void setUp() {
        mvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testDefaults() throws Exception {
        mvc.perform(get("/internalonly/labels"))
            .andExpect(content().contentType("text/plain; charset=utf-8"))
            .andExpect(content().string(containsString("T504747")))
            .andExpect(content().string(containsString("Acébutolol")))
            .andExpect(status().isOk());
    }

    @Test
    public void testValidParms() throws Exception {
        mvc.perform(get("/internalonly/labels?id=T504748&prop=meshv:prefLabel"))
            .andExpect(content().contentType("text/plain; charset=utf-8"))
            .andExpect(content().string(containsString("T504748")))
            .andExpect(content().string(containsString("Acebutolol Hydrochloride")))
            .andExpect(status().isOk());
    }

    @Test
    public void testValidatesId() throws Exception {
        mvc.perform(get("/internalonly/labels?id=../../etc/passwd"))
            .andExpect(status().isBadRequest());
    }

    @Test
    public void testValidatesRelation() throws Exception {
        mvc.perform(get("/internalonly/labels?id=T504748&prop=meshv:identifier"))
            .andExpect(status().isBadRequest());
    }
}
