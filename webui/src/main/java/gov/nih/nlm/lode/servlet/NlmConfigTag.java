package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import java.time.LocalDate;

import javax.servlet.jsp.JspWriter;
import javax.servlet.ServletContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;


/**
 * MeshYearTag inserts some global configuration as a JavaScript object
 */
public class NlmConfigTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    public static final String MESHRDF_YEAR = "meshrdf.year";
    public static final int MESHRDF_MINYEAR = 2015;

    private static final String TAG_FORMAT = "<script>"
            + "var NLM = (function() {"
            + "  return {"
            + "    meshYear: %d,"
            + "    minYear: %d,"
            + "  }"
            + "})();"
            + "</script>\n";

    public int getMeshYear() {
        // check whether there is a system property
        Object value = SafeProperty.getProperty(MESHRDF_YEAR, "[0-9]{4}");
        if (value != null) {
            return Integer.parseInt((String) value);
        }

        // default to the current year
        LocalDate now = LocalDate.now();
        return now.getYear();
    }

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.print(String.format(TAG_FORMAT, getMeshYear(), MESHRDF_MINYEAR));
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return super.doStartTag();
    }
}
