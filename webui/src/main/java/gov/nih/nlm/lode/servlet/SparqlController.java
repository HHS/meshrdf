package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jena.query.QueryParseException;
import org.apache.log4j.MDC;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
        String v = request.getHeader("Referer");
        MDC.put("webui", v != null && v.contains("/mesh/query"));
        if (query != null)
            MDC.put("query", query);
        if (format != null)
            MDC.put("format", format);
        if (limit != null)
            MDC.put("limit", limit);
        if (offset != null)
            MDC.put("offset", offset);
        MDC.put("inference", inference);
        DiagnosticHttpServletResponseWrapper wrappedResponse = new DiagnosticHttpServletResponseWrapper(response);
        super.query(query, format, offset, limit, inference, request, wrappedResponse);
        MDC.put("responsesize", wrappedResponse.getCount());
        MDC.put("responsetime", wrappedResponse.getResponseTime());
        apilog.info("sparql query");
        MDC.clear();
    }
}
