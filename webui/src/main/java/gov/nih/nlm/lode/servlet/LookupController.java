package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

import javax.validation.Valid;
import javax.validation.constraints.NotEmpty;

import org.apache.commons.lang3.tuple.Pair;
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
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hp.hpl.jena.query.QueryParseException;

import gov.nih.nlm.lode.model.SemanticSearchParams;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.PairCriteria;
import gov.nih.nlm.lode.model.Relation;
import gov.nih.nlm.lode.model.RelationEditor;
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
        binder.registerCustomEditor(Relation.class, new RelationEditor());
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/descriptor", produces="application/json", method=RequestMethod.GET)
    public Collection<ResourceAndLabel> lookupDescriptors(@Valid SemanticSearchParams criteria) throws QueryParseException, LodeException, IOException {
        log.trace(String.format("get descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/descriptor", produces="application/json", consumes="application/json", method=RequestMethod.POST)
    public Collection<ResourceAndLabel> lookupDescriptorsPost(@Valid @RequestBody SemanticSearchParams criteria) throws LodeException {
        log.trace(String.format("post descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/qualifiers", produces="application/json", method=RequestMethod.GET)
    public Collection<ResourceAndLabel> lookupQualifiers(@RequestParam("descriptor") @NotEmpty String descriptorUri) throws LodeException {
        log.trace(String.format("get qualifiers descriptor=%s", descriptorUri));
        return getService().allowedQualifiers(descriptorUri);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/pair", produces="application/json", method=RequestMethod.GET)
    public Collection<ResourceAndLabel> lookupPair(@Valid PairCriteria criteria) throws IOException, LodeException {
        log.trace(String.format("get pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/pair", produces="application/json", consumes="application/json", method=RequestMethod.POST)
    public Collection<ResourceAndLabel> lookupPairPost(@Valid @RequestBody PairCriteria criteria) throws IOException, LodeException {
        log.trace(String.format("post pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/label", produces="application/json", method=RequestMethod.GET)
    public Collection<String> lookupLabel(@RequestParam("resource") @NotEmpty String resourceUri) throws LodeException {
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
        if (fieldError.getField().equals("relation")) {
            return RelationEditor.ERROR_MESSAGE;
        } else {
            return fieldError.getDefaultMessage();
        }
    }

    @ResponseBody
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map> handlesJsonException(final HttpMessageNotReadableException ex) {
        log.warn("http message not readable", ex);
        final Throwable cause = ex.getCause();
        if (cause == null) {
            return fieldError("general", ex.getMessage());
        } else if (cause instanceof JsonMappingException) {
            return fieldError("relation", RelationEditor.ERROR_MESSAGE);
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
