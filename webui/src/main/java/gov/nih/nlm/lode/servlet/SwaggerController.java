package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import org.yaml.snakeyaml.Yaml;

import com.fasterxml.jackson.databind.ObjectMapper;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

@RestController
@RequestMapping("swagger")
public class SwaggerController {

    private Logger log = LoggerFactory.getLogger(getClass());

    @Value("${lode.swagger:classpath:swagger.yaml}")
    private Resource swaggerResource;

    private Map<String,Object> swaggerData = null;

    @GetMapping("ui")
    public ModelAndView swaggerUi() {
        return new ModelAndView("swaggerui", HttpStatus.OK);
    }

    @GetMapping("spec")
    public @ResponseBody void jsonSpec(HttpServletRequest request, HttpServletResponse response) throws IOException, LodeException {
        /* get swagger spec adjusted for this request */
        String host = request.getHeader("host");

        @SuppressWarnings("unchecked")
        Map<String,Object> swaggerSpec = (Map<String,Object>) ((HashMap<String,Object>) getSwaggerData()).clone();

        if (host != null && !host.equals("localhost")) {
            swaggerSpec.put("host", host);
            swaggerSpec.put("schemes", Collections.singletonList("https"));
        }

        /* Write that data as Json */
        ObjectMapper mapper = new ObjectMapper();
        response.setContentType("application/json;charset=UTF-8");
        ServletOutputStream out = response.getOutputStream();

        mapper.writeValue(out, swaggerSpec);
        out.close();
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
