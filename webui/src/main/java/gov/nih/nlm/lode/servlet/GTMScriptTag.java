package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * GTMScriptTag inserts the appropriate <script> tag for Google Tag Manager
 */
public class GTMScriptTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    public static final String GTM_PARAM_NAME = "gtmcode";

    private static final String TAG_FORMAT =
            "<script>" +
            "(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start': " +
            "new Date().getTime(),event:'gtm.js'});" +
            "var f=d.getElementsByTagName(s)[0]," +
            "j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;" +
            "j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;" +
            "f.parentNode.insertBefore(j,f);})" +
            "(window,document,'script','dataLayer','%s');" +
            "</script>\n";

    protected String gtmcode;

    @Override
    public void setPageContext(PageContext context) {
        super.setPageContext(context);
        gtmcode = ServletUtils.getParameter(context.getServletContext(), GTM_PARAM_NAME);
    }

    @Override
    public int doStartTag() throws JspException {

        JspWriter out = pageContext.getOut();
        try {
            out.print("<!-- Google Tag Manager -->\n");
            if (null != gtmcode) {
                out.print(String.format(TAG_FORMAT, gtmcode));
            }
            out.print("<!-- End Google Tag Manager -->\n");
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return SKIP_BODY;
    }
}
