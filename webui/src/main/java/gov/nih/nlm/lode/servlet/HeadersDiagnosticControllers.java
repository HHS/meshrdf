package gov.nih.nlm.lode.servlet;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
@RequestMapping("headers")
public class HeadersDiagnosticControllers {

    @RequestMapping(method = RequestMethod.GET, produces=MediaType.TEXT_HTML_VALUE)
    public ModelAndView echoHeaders(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(MediaType.TEXT_HTML_VALUE);
        ModelAndView mv = new ModelAndView("internal/headers", HttpStatus.OK);
        mv.addObject("headers", ServletUtils.getHeaders(request));
        return mv;
    }

    @RequestMapping(method = RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    public Map<String,List<String>> echoHeadersRestful(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        return ServletUtils.getHeaders(request);
    }
}
