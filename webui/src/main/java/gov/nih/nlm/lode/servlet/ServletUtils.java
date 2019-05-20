package gov.nih.nlm.lode.servlet;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

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

    public static Map<String,List<String>> getHeaders(HttpServletRequest request) {
        Map<String,List<String>> headers = new HashMap<String,List<String>>();
        Enumeration<String> names = request.getHeaderNames();
        while (names.hasMoreElements()) {
            String headerName = names.nextElement();
            Enumeration<String> values = request.getHeaders(headerName);
            List<String> valuesList = new LinkedList<String>();
            while (values.hasMoreElements()) {
                valuesList.add(values.nextElement());
            }
            headers.put(headerName, valuesList);
        }
        return headers;
    }

}
