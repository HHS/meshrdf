package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;


public class QualtricsSurveyTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    private static final String TAG_FORMAT = "<iframe src=\"%s\" height=\"%dpx\" width=\"%dpx\"></iframe>\n";

    public static final String URL_PARAM_NAME = "qualtrics.url";
    public static final String HEIGHT_PARAM_NAME = "qualtrics.height";
    public static final String WIDTH_PARAM_NAME = "qualtrics.width";

    private String url;
    private int height;
    private int width;

    @Override
    public void setPageContext(PageContext context) {
        super.setPageContext(context);
        ServletContext servletContext = context.getServletContext();
        url = ServletUtils.getParameter(servletContext, URL_PARAM_NAME);
        height = ServletUtils.getIntParameter(servletContext, HEIGHT_PARAM_NAME, 600);
        width = ServletUtils.getIntParameter(servletContext, WIDTH_PARAM_NAME, 800);
    }

    @Override
    public int doStartTag() throws JspException {
        if (url != null) {
            JspWriter out = pageContext.getOut();
            try {
                out.print(String.format(TAG_FORMAT, url, height, width));
            } catch (IOException e) {
                throw new JspException("IOException", e);
            }
        }
        return super.doStartTag();
    }
}
