package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

/**
 * DAPScriptTag inserts the appropriate U.S. Federal DAP script to the page.
 */
public class DAPScriptTag extends SimpleTagSupport {
    public void doTag() throws IOException, JspException {
        String environment = System.getenv("MESHRDF_ENV");
        if (null != environment && environment.equals("production")) {
            JspWriter out = getJspContext().getOut();
            out.print("<script language=\"javascript\" id=\"_fed_an_ua_tag\" src=\"//www.nlm.nih.gov/core/dap/Universal-Federated-Analytics.js?agency=HHS&subagency=NIH&enhlink=true\"></script>\n");
        }
    }
}
