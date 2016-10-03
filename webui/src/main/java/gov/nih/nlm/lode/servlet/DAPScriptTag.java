package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * DAPScriptTag inserts the appropriate U.S. Federal DAP script to the page.
 */
public class DAPScriptTag extends TagSupport {

    @Override
    public int doStartTag() throws JspException {
        String environment = System.getProperty("meshrdf.environment");
        if (null != environment && environment.equals("production")) {
            JspWriter out = pageContext.getOut();
            try {
                out.print("<script language=\"javascript\" id=\"_fed_an_ua_tag\" src=\"//www.nlm.nih.gov/core/dap/Universal-Federated-Analytics.js?agency=HHS&subagency=NIH&enhlink=true\"></script>\n");
            } catch (IOException e) {
                throw new JspException("IOException", e);
            }
        }
        return super.doStartTag();
    }
}
