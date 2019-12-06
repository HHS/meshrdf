package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;


public class SurveyTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    private static final String TAG_FORMAT = "<iframe src=\"%s\" class=\"survey\"></iframe>\n";
    public static final String URL_PARAM_NAME = "surveyUrl";

    private String url;

    @Override
    public void setPageContext(PageContext context) {
        super.setPageContext(context);
        ServletContext servletContext = context.getServletContext();
        url = ServletUtils.getParameter(servletContext, URL_PARAM_NAME);
    }

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            if (url != null) {
                out.print(String.format(TAG_FORMAT, url));
            } else {
                out.print("<!-- survey not configured -->");
            }
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return SKIP_BODY;
    }
}
