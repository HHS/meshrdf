package gov.nih.nlm.lode.servlet;

import javax.servlet.http.HttpServletRequest;

public class ServletUtils {

    public static String getClientAddress(HttpServletRequest request) {
        String v;
        if ((v = request.getHeader("X-Forwarded-For-IPV6")) != null) {
            // parse and return
            return v.split(",")[0].trim();
        }
        if ((v = request.getHeader("X-Forwarded-For")) != null) {
            // parse and return
            return v.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    public static String getHost(HttpServletRequest request) {
        String host = request.getHeader("X-Forwarded-Host");
        if (host == null) {
            host = request.getHeader("Host");
        }
        return host;
    }

}
