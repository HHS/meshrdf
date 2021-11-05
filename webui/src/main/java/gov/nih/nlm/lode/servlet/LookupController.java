package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.net.URI;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.tuple.Pair;
import org.apache.jena.query.QueryParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;

import gov.nih.nlm.lode.model.ConfigService;
import gov.nih.nlm.lode.model.DescriptorChildren;
import gov.nih.nlm.lode.model.DescriptorChildrenParams;
import gov.nih.nlm.lode.model.DescriptorParams;
import gov.nih.nlm.lode.model.LabelMatch;
import gov.nih.nlm.lode.model.LabelMatchEditor;
import gov.nih.nlm.lode.model.LabelParams;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairParams;
import gov.nih.nlm.lode.model.ResourceResult;
import gov.nih.nlm.lode.model.ValidYears;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

@Validated
@RestController
@RequestMapping("lookup")
public class LookupController {

    private Logger log = LoggerFactory.getLogger(getClass());

    private LookupService service;
    private ConfigService config;

    @Value("${lode.explorer.service.baseuri:}")
    private URI baseUri = null;

    @Autowired
    public LookupController(LookupService service, ConfigService config) {
        this.service = service;
        this.config = config;
    }

    public LookupService getService() {
        return service;
    }
    public void setService(LookupService service) {
        this.service = service;
    }
    public ConfigService getConfigService() {
        return config;
    }
    public void setConfig(ConfigService configService) {
        this.config = configService;
    }
    public URI getBaseUri() {
        return this.baseUri;
    }
    public void setBaseUri(URI baseUri) {
        this.baseUri = baseUri;
    }

    public String resolveUri(String uri) {
        if (baseUri != null) {
            uri = baseUri.resolve(uri).toString();
        }
        return uri;
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(LabelMatch.class, new LabelMatchEditor());
    }

    @GetMapping(produces=MediaType.TEXT_HTML_VALUE)
    public ModelAndView lookupForm(HttpServletRequest request, HttpServletResponse response) {
        response.setContentType(MediaType.TEXT_HTML_VALUE);
        ModelAndView mv = new ModelAndView("internal/lookup", HttpStatus.OK);
        return mv;
    }

    protected void massageCriteria(DescriptorParams criteria) {
        if (criteria.getYear() == "interim") {
            Integer year = config.getInterimYear();
            criteria.setYear(year != null ? year.toString() : null);
        }
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/descriptor", produces="application/json")
    public Collection<ResourceResult> lookupDescriptors(@Valid DescriptorParams criteria) throws QueryParseException, LodeException, IOException {
        log.info(String.format("get descriptor criteria label=%s, rel=%s, year=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getYear(), criteria.getLimit()));
        massageCriteria(criteria);
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/descriptor", produces="application/json", consumes="application/json")
    public Collection<ResourceResult> lookupDescriptorsJson(@Valid @RequestBody DescriptorParams criteria) throws LodeException {
        log.info(String.format("post descriptor criteria label=%s, rel=%s, year=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getYear(), criteria.getLimit()));
        massageCriteria(criteria);
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/descriptor", produces="application/json", consumes="application/x-www-form-urlencoded")
    public Collection<ResourceResult> lookupDescriptorsForm(@Valid DescriptorParams criteria) throws LodeException {
        log.info(String.format("post descriptor criteria label=%s, rel=%s, year=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getYear(), criteria.getLimit()));
        massageCriteria(criteria);
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/pair", produces="application/json")
    public Collection<ResourceResult> lookupPair(@Valid PairParams criteria) throws IOException, LodeException {
        log.info(String.format("get pair criteria label=%s, rel=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        criteria.setDescriptor(resolveUri(criteria.getDescriptor()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/pair", produces="application/json", consumes="application/json")
    public Collection<ResourceResult> lookupPairJson(@Valid @RequestBody PairParams criteria) throws IOException, LodeException {
        log.info(String.format("post pair criteria label=%s, rel=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        criteria.setDescriptor(resolveUri(criteria.getDescriptor()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @PostMapping(path="/pair", produces="application/json", consumes="application/x-www-form-urlencoded")
    public Collection<ResourceResult> lookupPairForm(@Valid PairParams criteria) throws IOException, LodeException {
        log.info(String.format("post pair criteria label=%s, rel=%s, limit=%s",
                criteria.getLabel(), criteria.getMatch(), criteria.getLimit()));
        criteria.setDescriptor(resolveUri(criteria.getDescriptor()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/term", produces="application/json")
    public Collection<ResourceResult> lookupTerms(@Valid DescriptorParams criteria) throws QueryParseException, LodeException, IOException {
        log.info(String.format("get terms criteria label=%s, rel=%s, limit=%s",
                criteria.getMatch(), criteria.getMatch(), criteria.getLimit()));
        return getService().lookupTerms(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/years", produces="application/json")
    public List<String> lookupDetails() {
        return getConfigService().getValidYears().dropdownValues();
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/details", produces="application/json")
    public DescriptorChildren lookupDetails(@Valid DescriptorChildrenParams params) throws LodeException {
        log.info(String.format("get details descriptor=%s, includes=%s", params.getDescriptor(), params.getIncludes()));
        String descriptorUri = resolveUri(params.getDescriptor());
        DescriptorChildren children = new DescriptorChildren(descriptorUri);

        if (params.includes("qualifiers")) {
            children.setQualifiers(getService().allowedQualifiers(descriptorUri));
        }
        if (params.includes("seealso")) {
            children.setSeeAlso(getService().lookupDescriptorSeeAlso(descriptorUri));
        }
        if (params.includes("terms")) {
            children.setTerms(getService().lookupDescriptorTerms(descriptorUri));
        }
        return children;
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/qualifiers", produces="application/json")
    public Collection<ResourceResult> lookupQualifiers(@Valid DescriptorChildrenParams params) throws LodeException {
        log.info(String.format("get qualifiers descriptor=%s", params.getDescriptor()));
        String descriptorUri = resolveUri(params.getDescriptor());
        return getService().allowedQualifiers(descriptorUri);
    }

    @ResponseStatus(HttpStatus.OK)
    @GetMapping(path="/label", produces="application/json")
    public Collection<String> lookupLabel(@Valid LabelParams params) throws LodeException {
        log.info(String.format("get label resource=%s", params.getResource()));
        return getService().lookupLabel(resolveUri(params.getResource()));
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
