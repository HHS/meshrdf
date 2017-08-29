package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import javax.servlet.jsp.JspWriter;
import javax.servlet.http.HttpServletResponse;
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

    /**
     * This is a careful wrapping of the system property, in case some administrator
     * is using a system property to inject JavaScript or something.
     *
     * @return gtmcode - validated gtmcode property
     */
    public static String getGTMCode() {
        String checkedcode = null;
        String rawcode = System.getProperty("meshrdf.gtmcode");
        if (null != rawcode && rawcode.length() != 0) {
            Pattern expr = Pattern.compile("^GTM-[A-Z0-9]+$");
            Matcher idm = expr.matcher(rawcode);
            if (idm.matches()) {
                checkedcode = idm.group();
            }
        }
        return checkedcode;
    }

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.print("<!-- Google Tag Manager -->\n");
            String gtmcode = getGTMCode();
            if (null != gtmcode) {
                out.print(String.format(TAG_FORMAT, gtmcode));
            }
            out.print("<!-- End Google Tag Manager -->\n");
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return super.doStartTag();
    }
}
