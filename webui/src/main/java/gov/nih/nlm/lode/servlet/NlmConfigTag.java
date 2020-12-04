package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

import org.apache.commons.lang3.BooleanUtils;


/**
 * MeshYearTag inserts some global configuration as a JavaScript object
 */
public class NlmConfigTag extends TagSupport {

    private static final long serialVersionUID = 1L;

    public static final String MESHRDF_YEAR = "meshrdf.year";
    public static final String MESHRDF_INTERIM = "meshrdf.interim";
    public static final int MESHRDF_MINYEAR = 2015;

    private static final String TAG_FORMAT = "<script>"
            + "var NLM = (function() {"
            + "  return {"
            + "    meshYear: %d,"
            + "    meshInterim: %s,"
            + "    minYear: %d"
            + "  };"
            + "})();"
            + "</script>\n";

    public int getMeshYear() {
        // check whether there is a system property (takes priority)
        Object value = SafeProperty.getProperty(MESHRDF_YEAR, "[0-9]{4}");
        if (value != null) {
            return Integer.parseInt((String) value);
        }

        // check whether there is a container parameter
        value = ServletUtils.getParameter(pageContext.getServletContext(), MESHRDF_YEAR);
        if (value != null) {
            return Integer.parseInt((String) value);
        }

        // default to the current year
        LocalDate now = LocalDate.now();
        return now.getYear();
    }

    public boolean getMeshInterim() {
        Object value = ServletUtils.getParameter(pageContext.getServletContext(), MESHRDF_INTERIM);
        if (value != null) {
            return BooleanUtils.toBoolean((String) value);
        }
        return false;
    }

    @Override
    public int doStartTag() throws JspException {
        JspWriter out = pageContext.getOut();
        try {
            out.print(
                String.format(
                    TAG_FORMAT,
                    getMeshYear(),
                    BooleanUtils.toStringTrueFalse(getMeshInterim()),
                    MESHRDF_MINYEAR
                )
            );
        } catch (IOException e) {
            throw new JspException("IOException", e);
        }
        return super.doStartTag();
    }
}
