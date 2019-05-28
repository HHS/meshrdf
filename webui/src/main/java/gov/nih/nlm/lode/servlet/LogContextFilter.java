package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.MDC;
import org.springframework.web.filter.OncePerRequestFilter;

public class LogContextFilter extends OncePerRequestFilter {

    @Override
    public void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        String v;
        if ((v = request.getHeader("User-Agent")) != null)
            MDC.put("ua", v);
        if ((v = (String) request.getAttribute("javax.servlet.forward.request_uri")) == null) {
            v = request.getRequestURI();
        }
        MDC.put("path", v);
        if ((v = ServletUtils.getClientAddress(request)) != null)
            MDC.put("cliaddr", v);
        if ((v = request.getHeader("X-Forwarded-For")) != null)
            MDC.put("xff", v);
        if ((v = request.getHeader("X-Forwarded-For-IPV6")) != null)
            MDC.put("xff6", v);
        if ((v = request.getRequestedSessionId()) != null)
            MDC.put("requestedsession", v);
        MDC.put("referrer", request.getHeader("Referer") != null);
        HttpSession session = request.getSession();
        if (session != null) {
            // Convert session datetime into a zoned date time
            ZonedDateTime zdt = ZonedDateTime.ofInstant(
                    Instant.ofEpochMilli(session.getCreationTime()),
                    ZoneId.systemDefault()
            );
            // print that as ISO8601 formatted timestamp
            MDC.put("sessiontime", zdt.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME));
            MDC.put("sessionid", session.getId());
        }
        chain.doFilter(request, response);
        MDC.clear();
    }
}
