package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.time.Instant;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.MDC;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hp.hpl.jena.query.QueryParseException;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import uk.ac.ebi.fgpt.lode.servlet.SparqlServlet;


@Controller
@RequestMapping("/query")
public class SparqlController extends SparqlServlet {

    private Logger apilog = LoggerFactory.getLogger("gov.nih.nlm.lode.api");

    @Override
    @RequestMapping
    public @ResponseBody
    void query(
            @RequestParam(value = "query", required = false) String query,
            @RequestParam(value = "format", required = false) String format,
            @RequestParam(value = "offset", required = false) Integer offset,
            @RequestParam(value = "limit", required = false) Integer limit,
            @RequestParam(value = "inference", required = false) boolean inference,
            HttpServletRequest request,
            HttpServletResponse response) throws QueryParseException, LodeException, IOException {
        super.query(query, format, offset, limit, inference, request, response);
        String v;
        v = request.getHeader("Referer");
        MDC.put("webui", v != null && v.contains("/mesh/query"));
        if ((v = request.getHeader("User-Agent")) != null)
            MDC.put("ua", v);
        if ((v = ServletUtils.getClientAddress(request)) != null)
            MDC.put("cliaddr", v);
        if (query != null)
            MDC.put("query", query);
        if (format != null)
            MDC.put("format", format);
        if (limit != null)
            MDC.put("limit", limit);
        if (offset != null)
            MDC.put("offset", offset);
        MDC.put("inference", inference);
        if ((v = request.getRequestedSessionId()) != null)
            MDC.put("session-requested", v);
        HttpSession session = request.getSession();
        if (session != null) {
            // Convert session datetime into a zoned date time
            ZonedDateTime zdt = ZonedDateTime.ofInstant(
                    Instant.ofEpochMilli(session.getCreationTime()),
                    ZoneId.systemDefault()
            );
            // print that as ISO8601 formatted timestamp
            MDC.put("session-time", zdt.format(DateTimeFormatter.ISO_OFFSET_DATE_TIME));
            MDC.put("session-id", session.getId());
        }
        apilog.info("sparql query");
        MDC.clear();
    }
}
