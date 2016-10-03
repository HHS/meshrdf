package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import uk.ac.ebi.fgpt.lode.utils.DatasourceProvider;


/**
 * A servlet that can be embedded within your web application and simply returns the string "OK" if it could be
 * accessed.  This can be used to allow load balancers in the production environment to detect when a web application
 * has crashed and send a notification to the mailing lists.
 */
@Controller
@RequestMapping("/status")
public class StatusController {

    @Autowired
    DatasourceProvider datasourceProvider;

    @Value("${meshrdf.update.path}")
    String updatesPath;

    @Value("${meshrdf.update.maxseconds}")
    long updateMaxSeconds;

    @RequestMapping(method = RequestMethod.GET)
    public void checkStatus(HttpServletResponse resp) throws IOException {
        PrintWriter out = null;
        ObjectMapper mapper = null;
        try {
            MeshStatus status = new MeshStatus(datasourceProvider, updatesPath, updateMaxSeconds);
            status.check();

            resp.setContentType("application/json; charset=UTF-8");
            if (status.getStatusCode() != MeshStatus.STATUS_OK) {
                resp.setStatus(status.getStatusCode());
                if (status.isUpdating()) {
                    resp.addHeader("Retry-After", "300");
                }
            }

            out = resp.getWriter();
            mapper = new ObjectMapper();
            // These serialization features make the result easier to read.
            // It is for these reasons that we serialize ourselves rather than let Spring do it.
            mapper.enable(SerializationFeature.INDENT_OUTPUT);
            mapper.enable(SerializationFeature.ORDER_MAP_ENTRIES_BY_KEYS);
            mapper.writeValue(out, status);
            out.println();
        } finally {
            if (null != out) {
                out.flush();
                out.close();
            }
        }
    }

}
