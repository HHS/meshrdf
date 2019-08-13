package gov.nih.nlm.lode.servlet;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.jena.query.QueryParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import gov.nih.nlm.lode.utils.LoggingContext;
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
        final long startTime = System.currentTimeMillis();
        String v = request.getHeader("Referer");
        LoggingContext.put("webui", v != null && v.contains("/mesh/query"));
        if (query != null)
            LoggingContext.put("query", query);
        if (format != null)
            LoggingContext.put("format", format);
        if (limit != null)
            LoggingContext.put("limit", limit);
        if (offset != null)
            LoggingContext.put("offset", offset);
        LoggingContext.put("inference", inference);
        super.query(query, format, offset, limit, inference, request, response);
        final long responseTime = System.currentTimeMillis() - startTime;
        LoggingContext.put("responsetime", responseTime);
        apilog.info("sparql query");
        LoggingContext.clear();
    }
}
