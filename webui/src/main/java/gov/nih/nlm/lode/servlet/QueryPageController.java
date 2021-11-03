package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
// import org.springframework.validation.BindException;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.ResponseStatus;
// import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import gov.nih.nlm.lode.model.QueryEditorForm;


@Controller
@RequestMapping("/editor")
public class QueryPageController  {

    @Autowired
    private Validator validator;

    private Logger log = LoggerFactory.getLogger(getClass());

    @GetMapping(produces="text/html; charset=UTF-8")
    public String get(
            QueryEditorForm form,
            HttpServletRequest request,
            BindingResult result,
            HttpServletResponse response) throws IOException {
        response.setContentType(MediaType.TEXT_HTML_VALUE);

        validator.validate(form, result);
        if (result.hasErrors()) {
            // TODO: get the error message from the reuslt
            response.sendError(HttpStatus.BAD_REQUEST.value(), "Invalid Query Parameters");
            return "query";
        }

        return "query";
    }
}
