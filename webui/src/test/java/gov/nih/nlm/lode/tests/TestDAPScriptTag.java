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

import gov.nih.nlm.lode.servlet.DAPScriptTag;

public class TestDAPScriptTag {

    @BeforeTest(alwaysRun = true)
    public void setUp() {
        System.setProperty("meshrdf.environment", "production");
    }

    @AfterTest(alwaysRun = true)
    public void tearDown() {
        System.clearProperty("meshrdf.environment");
    }

    @Test(groups="unit")
    public void testDAPScriptTag() throws JspException, UnsupportedEncodingException {
        // stuff to use in test
        MockHttpServletRequest request = new MockHttpServletRequest();
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockServletContext servletContext = new MockServletContext();
        MockPageContext pageContext = new MockPageContext(servletContext, request, response);

        // test
        DAPScriptTag tag = new DAPScriptTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, containsString("_fed_an_ua_tag"));
        assertThat(content, containsString("/Universal-Federated-Analytics.js"));
    }
}
