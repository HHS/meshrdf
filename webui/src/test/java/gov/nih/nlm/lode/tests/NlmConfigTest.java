package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.*;
import static org.hamcrest.MatcherAssert.assertThat;

import java.time.LocalDate;
import java.io.UnsupportedEncodingException;

import javax.servlet.jsp.JspException;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockPageContext;
import org.springframework.mock.web.MockServletContext;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.NlmConfigTag;


public class NlmConfigTest {
    private static final String MESHRDF_YEAR = NlmConfigTag.MESHRDF_YEAR;
    private static final int MESHRDF_MINYEAR = NlmConfigTag.MESHRDF_MINYEAR;

    private String origMeshYear = null;
    private Integer defaultYear = null;
    private MockHttpServletRequest request = null;
    private MockHttpServletResponse response = null;
    private MockServletContext servletContext = null;
    private MockPageContext pageContext = null;

    @BeforeTest(alwaysRun = true)
    public void setUp() throws JspException {
        // original
        origMeshYear = System.getProperty(MESHRDF_YEAR);

        // default value
        defaultYear = LocalDate.now().getYear();

        // stuff to use in tests
        request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
        servletContext = new MockServletContext();
        pageContext = new MockPageContext(servletContext, request, response);
    }

    @AfterTest(alwaysRun = true)
    public void tearDown() {
        if (null == origMeshYear) {
            System.clearProperty(MESHRDF_YEAR);
        } else {
            System.setProperty(MESHRDF_YEAR, origMeshYear);
        }
    }

    @Test(groups="unit")
    public void testDefault() throws JspException, UnsupportedEncodingException {
        // Set the tag
        System.clearProperty(MESHRDF_YEAR);

        // test
        NlmConfigTag tag = new NlmConfigTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String currentYear = String.format("meshYear: %d", defaultYear);
        String minYear = String.format("minYear: %d", MESHRDF_MINYEAR);

        String content = response.getContentAsString();
        assertThat(content, containsString(currentYear));
        assertThat(content, containsString(minYear));
    }

    @Test(groups="unit")
    public void testPropertyInvalid() throws JspException, UnsupportedEncodingException {
        // Set the tag (digital but wrong number of digits)
        System.setProperty(MESHRDF_YEAR, "19");

        // test
        NlmConfigTag tag = new NlmConfigTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String currentYear = String.format("meshYear: %d", defaultYear);
        String minYear = String.format("minYear: %d", MESHRDF_MINYEAR);
        String content = response.getContentAsString();
        assertThat(content, containsString(currentYear));
        assertThat(content, containsString(minYear));
    }

    @Test(groups="unit")
    public void testPropertyOK() throws JspException, UnsupportedEncodingException {
        // Set the tag
        System.setProperty(MESHRDF_YEAR, "2136");

        // test
        NlmConfigTag tag = new NlmConfigTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String currentYear = "meshYear: 2136";
        String minYear = String.format("minYear: %d", MESHRDF_MINYEAR);
        String content = response.getContentAsString();
        assertThat(content, containsString(currentYear));
        assertThat(content, containsString(minYear));
    }
}
