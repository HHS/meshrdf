package gov.nih.nlm.lode.tests.lookup;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.nullValue;
import static org.hamcrest.MatcherAssert.assertThat;

import java.time.LocalDate;

import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.springframework.test.context.web.WebAppConfiguration;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.model.ValidYears;
import gov.nih.nlm.lode.service.ConfigServiceImpl;

/**
 * Test the config service can figure out the mesh year and whether there is a mesh year
 * from the servlet Context.
 *
 * @author davisda4
 */
@ContextConfiguration(locations={"classpath:spring-test-context.xml"})
@WebAppConfiguration()
@Test(groups = "unit")
public class ConfigServiceTest extends AbstractTestNGSpringContextTests {

    private MockServletContext context;
    private ConfigService configService;

    /*
     * context has no attributes and we are testing the defaults
     */
    @Test
    public void testDefaults() {
        context = new MockServletContext();
        configService = new ConfigServiceImpl(context);

        ValidYears years = configService.getValidYears();

        assertThat(years.getCurrent(), equalTo(LocalDate.now().getYear()));
        assertThat(years.getInterim(), nullValue());
    }

    /*
     * We can specify the mesh year explicitly, and it works.
     */
    @Test
    public void testSpecificYear() {
        context = new MockServletContext();
        context.setInitParameter(ConfigService.MESHRDF_YEAR, "2018");
        context.setInitParameter(ConfigService.MESHRDF_INTERIM, "true");
        configService = new ConfigServiceImpl(context);

        ValidYears years = configService.getValidYears();

        assertThat(years.getCurrent(), equalTo(2018));
        assertThat(years.getInterim(), equalTo(2019));
    }

    /*
     * MeSH RDF interim may be turned off
     */
    @Test
    public void testInterimOff() {
        context = new MockServletContext();
        context.setInitParameter(ConfigService.MESHRDF_YEAR, "2016");
        context.setInitParameter(ConfigService.MESHRDF_INTERIM, "false");
        configService = new ConfigServiceImpl(context);

        ValidYears years = configService.getValidYears();

        assertThat(years.getCurrent(), equalTo(2016));
        assertThat(years.getInterim(), nullValue());
    }
}
