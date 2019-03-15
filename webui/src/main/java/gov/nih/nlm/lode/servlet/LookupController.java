package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.stream.Collectors;

import javax.validation.Valid;

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
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.hp.hpl.jena.query.QueryParseException;

import gov.nih.nlm.lode.model.LookupCriteria;
import gov.nih.nlm.lode.model.LookupService;
import gov.nih.nlm.lode.model.Relation;
import gov.nih.nlm.lode.model.RelationEditor;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

@Validated
@RestController
@RequestMapping("lookup")
public class LookupController {

    private Logger log = LoggerFactory.getLogger(getClass());

    private LookupService service;

    public LookupService getService() {
        return service;
    }

    @Autowired
    public void setService(LookupService service) {
        this.service = service;
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Relation.class, new RelationEditor());
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/descriptor", produces="application/json", method=RequestMethod.GET)
    public Collection<String> lookupDescriptors(@Valid LookupCriteria criteria) throws QueryParseException, LodeException, IOException {
        log.info(String.format("get descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/descriptor", produces="application/json", consumes="application/json", method=RequestMethod.POST)
    public Collection<String> lookupDescriptorsPost(@Valid @RequestBody LookupCriteria criteria) {
        log.info(String.format("post descriptor criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupDescriptors(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/pair", produces="application/json", method=RequestMethod.GET)
    public Collection<String> lookupPair(@Valid LookupCriteria criteria) throws IOException {
        log.info(String.format("get pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseStatus(HttpStatus.OK)
    @RequestMapping(path="/pair", produces="application/json", consumes="application/json", method=RequestMethod.POST)
    public Collection<String> lookupPaiPostr(@Valid @RequestBody LookupCriteria criteria) throws IOException {
        log.info(String.format("post pair criteria label=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return getService().lookupPairs(criteria);
    }

    @ResponseBody
    @ExceptionHandler(BindException.class)
    public ResponseEntity<Map> handleBindException(BindException ex) {
        return error(ex.getBindingResult().getFieldErrors()
                .stream()
                .map((f) -> Pair.of(f.getField(), f.getDefaultMessage()))
                .collect(Collectors.groupingBy(Pair::getLeft,
                        Collectors.mapping(Pair::getRight, Collectors.toList()))), HttpStatus.BAD_REQUEST);
    }

    @ResponseBody
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Map> handlesJsonException(final HttpMessageNotReadableException ex) {
        final Throwable cause = ex.getCause();
        if (cause == null) {
            return fieldError("general", Collections.singletonList(ex.getMessage()));
        } else if (cause instanceof JsonMappingException) {
            return fieldError("relation", Collections.singletonList("must be one of \"contains|exact|startswith\""));
        } else if (cause instanceof JsonParseException) {
            return fieldError("general", Collections.singletonList("invalid json: "+cause.getMessage()));
        } else {
            return fieldError("general", Collections.singletonList(cause.getMessage()));
        }
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map> handleGenericException(Exception ex) {
        log.info("Generic exception", ex);
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
