package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;


/**
 * This class inherits the definition of getGTMCode from the other class.
 *
 * @author davisda4
 */
public class GTMNoScriptTag extends GTMScriptTag {

    private static final long serialVersionUID = 1L;

    private static final String TAG_FORMAT =
            "<noscript>" +
            "<iframe src=\"https://www.googletagmanager.com/ns.html?id=%s\" "+
            "height=\"0\" width=\"0\" style=\"display:none;visibility:hidden\">"+
            "</iframe></noscript>\n";

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.print("<!-- Google Tag Manager (noscript) -->\n");
            if (null != gtmcode) {
                out.print(String.format(TAG_FORMAT, gtmcode));
            }
            out.print("<!-- End Google Tag Manager (noscript) -->\n");
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return SKIP_BODY;
    }

}
