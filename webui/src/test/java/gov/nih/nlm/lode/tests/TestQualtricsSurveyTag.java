package gov.nih.nlm.lode.tests;

import static org.hamcrest.CoreMatchers.containsString;
import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.MatcherAssert.assertThat;

import java.io.UnsupportedEncodingException;

import javax.servlet.jsp.JspException;

import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockPageContext;
import org.springframework.mock.web.MockServletContext;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import gov.nih.nlm.lode.servlet.QualtricsSurveyTag;


public class TestQualtricsSurveyTag {

    private MockHttpServletResponse response;
    private MockServletContext servletContext;
    private MockPageContext pageContext;

    @BeforeMethod(alwaysRun = true)
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

    @Test(groups = "unit")
    public void testNullUrl() throws JspException, UnsupportedEncodingException {
        QualtricsSurveyTag tag = new QualtricsSurveyTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, equalTo(""));
    }

    @Test(groups = "unit")
    public void testEmptyUrl() throws JspException, UnsupportedEncodingException {
        servletContext.addInitParameter(QualtricsSurveyTag.URL_PARAM_NAME, "");

        QualtricsSurveyTag tag = new QualtricsSurveyTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();
        assertThat(content, equalTo(""));
    }

    @Test(groups = "unit")
    public void testUrlDefaultWidthHeight() throws JspException, UnsupportedEncodingException {
        String expectedUrl = "https://short-survey.com/toehunthehune";
        servletContext.addInitParameter(QualtricsSurveyTag.URL_PARAM_NAME, expectedUrl);

        QualtricsSurveyTag tag = new QualtricsSurveyTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();

        assertThat(content, containsString(String.format("src=\"%s\"", expectedUrl)));
        assertThat(content, containsString("width=\"800px\""));
        assertThat(content, containsString("height=\"600px\""));
    }

    @Test(groups = "unit")
    public void testOverrideWidthHeight() throws JspException, UnsupportedEncodingException {
        String expectedUrl = "https://short-survey.com/ZZEOTUHEG8G89";
        servletContext.addInitParameter(QualtricsSurveyTag.URL_PARAM_NAME, expectedUrl);
        servletContext.addInitParameter(QualtricsSurveyTag.WIDTH_PARAM_NAME, "677");
        servletContext.addInitParameter(QualtricsSurveyTag.HEIGHT_PARAM_NAME, "877");

        QualtricsSurveyTag tag = new QualtricsSurveyTag();
        tag.setPageContext(pageContext);
        tag.doStartTag();

        String content = response.getContentAsString();

        assertThat(content, containsString(String.format("src=\"%s\"", expectedUrl)));
        assertThat(content, containsString("width=\"677px\""));
        assertThat(content, containsString("height=\"877px\""));
    }
}
