package gov.nih.nlm.lode.servlet;

import javax.servlet.http.HttpServletRequest;

public class ServletUtils {

    public static String getClientAddress(HttpServletRequest request) {
        String v;
        if ((v = request.getHeader("X-Forwarded-For")) != null) {
            // parse and return
            return v.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

}
