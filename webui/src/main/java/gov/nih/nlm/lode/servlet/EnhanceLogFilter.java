package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.MDC;
import org.springframework.web.filter.OncePerRequestFilter;

/**
 * @author Daniel A. Davis
 * @date 03/06/2019
 * U.S.National Library of Medicine
 *
 * Enhance SPARQL logs and explorer logs to add some MDC variables to the lodestar log.
 */
public class EnhanceLogFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        MDC.put("referer",  request.getHeader("Referrer"));
        MDC.put("userAgent", request.getHeader("User-Agent"));
        filterChain.doFilter(request, response);
        MDC.remove("referer");
        MDC.remove("userAgent");
    }
}
