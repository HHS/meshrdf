package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;

import org.apache.commons.lang3.tuple.Pair;
import org.apache.jena.query.QueryParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import gov.nih.nlm.lode.model.DescriptorParams;
import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.model.LabelMatchEditor;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairParams;
import gov.nih.nlm.lode.model.ResourceAndLabel;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

@Validated
@RestController
@RequestMapping("lookup")
public class LookupController {

    private Logger log = LoggerFactory.getLogger(getClass());

    private LookupService service;

    @Autowired
    public LookupController(LookupService service) {
        this.service = service;
    }

    public LookupService getService() {
        return service;
    }

    public void setService(LookupService service) {
        this.service = service;
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(LabelMatch.class, new LabelMatchEditor());
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/descriptor", produces="application/json")
    public Collection<ResourceAndLabel> lookupDescriptors(@Valid DescriptorParams criteria) throws QueryParseException, LodeException, IOException {
        log.trace(String.format("get descriptor criteria label=%s, rel=%s, limit=%s", criteria.getMatch(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/descriptor", produces="application/json", consumes="application/json")
    public Collection<ResourceAndLabel> lookupDescriptorsJson(@Valid @RequestBody DescriptorParams criteria) throws LodeException {
        log.trace(String.format("post descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/descriptor", produces="application/json", consumes="application/x-www-form-urlencoded")
    public Collection<ResourceAndLabel> lookupDescriptorsForm(@Valid DescriptorParams criteria) throws LodeException {
        log.trace(String.format("post descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/pair", produces="application/json")
    public Collection<ResourceAndLabel> lookupPair(@Valid PairParams criteria) throws IOException, LodeException {
        log.trace(String.format("get pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/pair", produces="application/json", consumes="application/json")
    public Collection<ResourceAndLabel> lookupPairJson(@Valid @RequestBody PairParams criteria) throws IOException, LodeException {
        log.trace(String.format("post pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/pair", produces="application/json", consumes="application/x-www-form-urlencoded")
    public Collection<ResourceAndLabel> lookupPairForm(@Valid PairParams criteria) throws IOException, LodeException {
        log.trace(String.format("post pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/qualifiers", produces="application/json")
    public Collection<ResourceAndLabel> lookupQualifiers(@RequestParam("descriptor") @NotEmpty String descriptorUri) throws LodeException {
        log.trace(String.format("get qualifiers descriptor=%s", descriptorUri));
        return getService().allowedQualifiers(descriptorUri);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/label", produces="application/json")
    public Collection<String> lookupLabel(@RequestParam("resource") @NotEmpty String resourceUri) throws LodeException, BindException {
        log.trace(String.format("get label resource=%s", resourceUri));
        return getService().lookupLabel(resourceUri);
    }

    @ResponseBody
    @ExceptionHandler(BindException.class)
    public ResponseEntity<Map> handleBindException(BindException ex) {
        log.warn("binding failure", ex);
        return error(ex.getBindingResult().getFieldErrors()
                .stream()
                .map((f) -> Pair.of(f.getField(), getFieldErrorMessage(f)))
                .collect(Collectors.groupingBy(Pair::getLeft,
                        Collectors.mapping(Pair::getRight, Collectors.toList()))), HttpStatus.BAD_REQUEST);
    }

    @ResponseBody
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map> handleNotValidException(MethodArgumentNotValidException ex) {
        log.warn("method argument not valid", ex);
        return error(ex.getBindingResult().getFieldErrors()
                .stream()
                .map((f) -> Pair.of(f.getField(), f.getDefaultMessage()))
                .collect(Collectors.groupingBy(Pair::getLeft,
                        Collectors.mapping(Pair::getRight, Collectors.toList()))), HttpStatus.BAD_REQUEST);
    }

    private String getFieldErrorMessage(final FieldError fieldError) {
        if (fieldError.getField().equals("match")) {
            return LabelMatchEditor.ERROR_MESSAGE;
        } else {
            return fieldError.getDefaultMessage();
        }
    }

    @ResponseBody
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<Map> handleMissingParameterException(MissingServletRequestParameterException ex) {
        return fieldError(ex.getParameterName(), "required parameter");
    }

    @ResponseBody
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map> handlesJsonException(final HttpMessageNotReadableException ex) {
        log.warn("http message not readable", ex);
        final Throwable cause = ex.getCause();
        if (cause == null) {
            return fieldError("general", ex.getMessage());
        } else if (cause instanceof JsonMappingException) {
            return fieldError("match", LabelMatchEditor.ERROR_MESSAGE);
        } else if (cause instanceof JsonParseException) {
            return fieldError("general", "JSON Parse Error: "+cause.getMessage());
        } else {
            return fieldError("general", cause.getMessage());
        }
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map> handleGenericException(Exception ex) {
        log.error("unexpected exception", ex);
        return fieldError("unknown", Collections.singletonList(ex.getMessage()));
    }

    public ResponseEntity<Map> fieldError(String field, Object message, HttpStatus status) {
        return error(Collections.singletonMap(field, Collections.singletonList(message)), status);
    }
    public ResponseEntity<Map> fieldError(String field, Object message) {
        return fieldError(field, message, HttpStatus.BAD_REQUEST);
    }
    public ResponseEntity<Map> error(Object message, HttpStatus status) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON_UTF8);
        return new ResponseEntity<Map>(Collections.singletonMap("error", message), headers, status);
    }
}
