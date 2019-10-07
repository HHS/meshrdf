package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.not;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.UnsupportedEncodingException;

import javax.servlet.jsp.JspException;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockPageContext;
import org.springframework.mock.web.MockServletContext;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.GTMNoScriptTag;
import gov.nih.nlm.lode.servlet.GTMScriptTag;

public class TestGTMScriptTag {

    /* A fake GTM code to test */
    private static final String GTM_TESTCODE = "GTM-PPP9999";

    MockHttpServletResponse response;
    private MockServletContext servletContext;
    private MockPageContext pageContext;

    @BeforeTest(alwaysRun = true)
    public void setUp() {
        MockHttpServletRequest request = new MockHttpServletRequest();
        response = new MockHttpServletResponse();
        servletContext = new MockServletContext();
        pageContext = new MockPageContext(servletContext, request, response);
    }

    @AfterTest(alwaysRun = true)
    public void tearDown() {
        response = null;
        servletContext = null;
        pageContext = null;
    }


    @Test(groups="unit")
    public void testGTMScriptTag() throws JspException, UnsupportedEncodingException {
        // stuff to use in test
        servletContext.addInitParameter(GTMScriptTag.GTM_PARAM_NAME, GTM_TESTCODE);

        // test
        GTMScriptTag tag = new GTMScriptTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, containsString(GTM_TESTCODE));
        assertThat(content, containsString("https://www.googletagmanager.com/gtm.js"));
        assertThat(content, containsString("<!-- Google Tag Manager"));
    }

    @Test(groups="unit")
    public void testGTMScriptTagNoCode() throws JspException, UnsupportedEncodingException {
        // test
        GTMScriptTag tag = new GTMScriptTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, not(containsString(GTM_TESTCODE)));
        assertThat(content, not(containsString("https://www.googletagmanager.com/gtm.js")));
        assertThat(content, containsString("<!-- Google Tag Manager"));
    }

    @Test(groups="unit")
    public void testGTMNoScriptTag() throws JspException, UnsupportedEncodingException {
        // Set the tag
        servletContext.addInitParameter(GTMScriptTag.GTM_PARAM_NAME, GTM_TESTCODE);

        // test
        GTMNoScriptTag tag = new GTMNoScriptTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, containsString(GTM_TESTCODE));
        assertThat(content, containsString("https://www.googletagmanager.com/ns.html"));
        assertThat(content, containsString("<!-- Google Tag Manager"));
    }

    @Test(groups="unit")
    public void testGTMNoScriptTagNoCode() throws JspException, UnsupportedEncodingException {
        // Set the tag
        servletContext.addInitParameter(GTMScriptTag.GTM_PARAM_NAME, "");

        // test
        GTMNoScriptTag tag = new GTMNoScriptTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, not(containsString(GTM_TESTCODE)));
        assertThat(content, not(containsString("https://www.googletagmanager.com/ns.html")));
        assertThat(content, containsString("<!-- Google Tag Manager"));
    }

}
