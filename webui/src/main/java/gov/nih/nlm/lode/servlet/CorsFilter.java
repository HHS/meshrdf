package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.filter.OncePerRequestFilter;

/**
 * @author Dan Davis
 * @date 08/21/2019
 *
 * Enable CORS requests to this application
 */
public class CorsFilter extends OncePerRequestFilter {

   @Override
   protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.addHeader("Access-Control-Allow-Methods", "GET, POST, PUT");
        response.addHeader("Access-Control-Allow-Headers", "Cache-Control, Pragma, Origin, Authorization, Content-Type, X-Requested-With");
        response.addHeader("Access-Control-Max-Age", "1800"); // 30 minutes

        if (request.getMethod().equals("OPTIONS")) {
            // CORS "pre-flight" request
            response.setStatus(HttpServletResponse.SC_ACCEPTED);
            return;
        }

        // Simple request
        filterChain.doFilter(request, response);
   }
}
