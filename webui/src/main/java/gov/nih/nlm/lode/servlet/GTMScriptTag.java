package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;


/**
 * GTMScriptTag inserts the appropriate <script> tag for Google Tag Manager
 */
public class GTMScriptTag extends TagSupport {

    private static final long serialVersionUID = 1L;

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

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.print("<!-- Google Tag Manager -->\n");
            String gtmcode = System.getProperty("meshrdf.gtmcode");
            if (null != gtmcode && gtmcode.length() > 0) {
                out.print(String.format(TAG_FORMAT, gtmcode));
            }
            out.print("<!-- End Google Tag Manager -->\n");
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return super.doStartTag();
    }
}
