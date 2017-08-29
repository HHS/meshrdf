package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.*;
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

import gov.nih.nlm.lode.servlet.GTMScriptTag;
import gov.nih.nlm.lode.servlet.GTMNoScriptTag;

public class TestGTMScriptTag {

    private String previousGtmCode = null;

    /* A fake GTM code to test */
    private static final String GTM_TESTCODE = "GTM-PPP9999";

    /* The property value that GTMScriptTag will look for */
    private static final String GTM_PROPERTY = "meshrdf.gtmcode";

    @BeforeTest(alwaysRun = true)
    public void setUp() {
        previousGtmCode = System.getProperty(GTM_PROPERTY);
    }

    @AfterTest(alwaysRun = true)
    public void tearDown() {
        if (null == previousGtmCode) {
            System.clearProperty(GTM_PROPERTY);
        } else {
            System.setProperty(GTM_PROPERTY, previousGtmCode);
        }
    }

    @Test(groups="unit")
    public void testGTMScriptTag() throws JspException, UnsupportedEncodingException {
        // stuff to use in test
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockServletContext servletContext = new MockServletContext();
        MockPageContext pageContext = new MockPageContext(servletContext, request, response);

        // Set the tag
        System.setProperty("meshrdf.gtmcode", GTM_TESTCODE);

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
        // stuff to use in test
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockServletContext servletContext = new MockServletContext();
        MockPageContext pageContext = new MockPageContext(servletContext, request, response);

        // Clear the tag
        System.clearProperty(GTM_PROPERTY);

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
        // stuff to use in test
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockServletContext servletContext = new MockServletContext();
        MockPageContext pageContext = new MockPageContext(servletContext, request, response);

        // Set the tag
        System.setProperty("meshrdf.gtmcode", GTM_TESTCODE);

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
        // stuff to use in test
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockServletContext servletContext = new MockServletContext();
        MockPageContext pageContext = new MockPageContext(servletContext, request, response);

        // Clear the tag
        System.clearProperty(GTM_PROPERTY);

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
