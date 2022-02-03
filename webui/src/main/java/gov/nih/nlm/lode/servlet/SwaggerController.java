package gov.nih.nlm.lode.servlet;

import static gov.nih.nlm.lode.utils.SwaggerUtil.getParameter;

import java.lang.ClassCastException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.yaml.snakeyaml.Yaml;

import com.fasterxml.jackson.databind.ObjectMapper;

import uk.ac.ebi.fgpt.lode.exception.LodeException;
import gov.nih.nlm.lode.model.ConfigService;


@RestController
@RequestMapping(path="swagger")
public class SwaggerController {

    private Logger log = LoggerFactory.getLogger(getClass());

    @Value("${lode.swagger:classpath:swagger.yaml}")
    private Resource swaggerResource;

    private ConfigService config;

    /* Default is for testing  */
    @Autowired(required = false)
    private ServletContext servletContext = null;

    private Map<String,Object> swaggerData = null;

    @Autowired
    public SwaggerController(ConfigService config) {
        this.config = config;
    }

    @GetMapping
    public void redirectToUi(HttpServletRequest request, HttpServletResponse response) {
        response.setHeader("Location", getContextPath()+"/swagger/ui");
        response.setStatus(HttpStatus.TEMPORARY_REDIRECT.value());
    }

    @GetMapping(path="ui", produces=MediaType.TEXT_HTML_VALUE)
    public ModelAndView swaggerUi(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(MediaType.TEXT_HTML_VALUE);
        ModelAndView mv = new ModelAndView("internal/swaggerui", HttpStatus.OK);
        String host = ServletUtils.getHost(request);
        String scheme = (host.startsWith("localhost") ? "http": "https");
        String swaggerSpec = String.format("%s://%s%s/swagger/swagger.json", scheme, host, getContextPath());
        mv.addObject("specUri", swaggerSpec);
        return mv;
    }



    @GetMapping(path="swagger.json", produces=MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody void swaggerSpec(HttpServletRequest request, HttpServletResponse response) throws IOException, LodeException {
        /* get clone of swagger spec */
        @SuppressWarnings("unchecked")
        Map<String,Object> swaggerSpec = (Map<String,Object>) ((HashMap<String,Object>) getSwaggerData()).clone();

        /* adjust to this request */
        String host = ServletUtils.getHost(request);
        String scheme = (host.startsWith("localhost") ? "http": "https");
        if (host != null) {
            swaggerSpec.put("schemes", new String[] { scheme });
            swaggerSpec.put("host", host);
        }
        swaggerSpec.put("baseUri", getContextPath());

        /* Modify year Param */
        Map<String, Object> year = getParameter(swaggerSpec, "/lookup/descriptor", "get", "year");
        if (year != null) {
            year.put("enum", config.getValidYears().dropdownValues());
        }

        /* Write that data as JSON */
        ObjectMapper mapper = new ObjectMapper();
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        ServletOutputStream out = response.getOutputStream();

        mapper.writeValue(out, swaggerSpec);
        out.close();
    }

    public String getContextPath() {
        /* Usually, there will be a servlet context, but not during unit tests */
        return servletContext != null ? servletContext.getContextPath() : "/testing";
    }

    public Resource getSwaggerResource() {
        return swaggerResource;
    }

    public void setSwaggerResource(Resource swaggerSpec) {
        this.swaggerResource = swaggerSpec;
    }

    public synchronized Map<String,Object> getSwaggerData() throws LodeException {
        /* This part must be synchronized to safely load the data */
        if (swaggerData == null) {
            Yaml yaml = new Yaml();
            try {
                swaggerData = yaml.load(getSwaggerResource().getInputStream());
            } catch (IOException ex) {
                log.error("Unable to load swagger specification", ex);
                throw new LodeException("Unable to load swagger specification");
            }
        }
        return swaggerData;
    }
}
