package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.Set;
import java.util.stream.Collectors;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * @author Dan Davis
 * @date 08/21/2019
 *
 * Enable CORS requests to this application
 */
public class CorsFilter extends OncePerRequestFilter {

   private Logger logger = LoggerFactory.getLogger(getClass());
   private static String[] ALLOWED_HEADERS = new String[] {
           "Cache-Control",
           "Pragma",
           "Origin",
           "Authorization",
           "Content-Type",
           "X-Requested-With"
   };
   private static final String allowedHeaders = String.join(", ", ALLOWED_HEADERS);

   @Override
   protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

       response.addHeader("Access-Control-Allow-Origin", "*");
       response.addHeader("Access-Control-Allow-Methods", "GET, POST, PUT");
       response.addHeader("Access-Control-Allow-Headers", allowedHeaders);
       response.addHeader("Access-Control-Max-Age", "1800"); // 30 minutes

       if (request.getMethod().equals("OPTIONS")) {
           String v;
           if ((v = request.getHeader("Access-Control-Request-Headers")) != null) {
               Set<String> allowedHeaderSet = Arrays.stream(ALLOWED_HEADERS).collect(Collectors.toSet());
               boolean missing = false;
               String[] headers = v.split(", *");
               for (int i = 0; i < headers.length; i++) {
                   if (!allowedHeaderSet.contains(headers[i])) {
                       missing = true;
                       break;
                   }
               }
               if (missing) {
                   logger.warn(String.format("pre-flight request with Access-Control-Request-Headers: %s", v));
               }
           }
           // CORS "pre-flight" request
           response.setStatus(HttpServletResponse.SC_ACCEPTED);
           return;
        }

        // Simple request
        filterChain.doFilter(request, response);
   }
}
