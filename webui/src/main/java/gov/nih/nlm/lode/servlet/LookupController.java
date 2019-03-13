package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.validation.Valid;

import org.apache.commons.lang3.tuple.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.hp.hpl.jena.query.QueryParseException;

import gov.nih.nlm.lode.model.LookupCriteria;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

@Validated
@RestController
@RequestMapping("lookup")
public class LookupController {

    private Logger log = LoggerFactory.getLogger(getClass());


    @RequestMapping(path="/descriptor", produces="application/json")
    public List<String> lookupDescriptorGet(@Valid LookupCriteria criteria) throws QueryParseException, LodeException, IOException {
        log.info(String.format("get descriptor criteria name=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return Arrays.asList(new String[] {
              "http://id.nlm.nih.gov/mesh/D01882",
              "http://id.nlm.nih.gov/mesh/D01883",
        });
    }

    @RequestMapping(path="/pair", produces="application/json")
    public List<String> lookupPair(@Valid LookupCriteria criteria) throws IOException {
        log.info(String.format("pair criteria name=%s, rel=%s, limit=%s", criteria.getLabel(), criteria.getRelation(), criteria.getLimit()));
        return Arrays.asList(new String[] {
                "http://id.nlm.nih.gov/mesh/Q01882",
                "http://id.nlm.nih.gov/mesh/Q01883",
          });
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(BindException.class)
    public Map handleBindException(BindException ex) {
        return error(ex.getBindingResult().getFieldErrors()
                .stream()
                .map((f) -> Pair.of(f.getField(), f.getDefaultMessage()))
                .collect(Collectors.groupingBy(Pair::getLeft,
                        Collectors.mapping(Pair::getRight, Collectors.toList()))));
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(Exception.class)
    public Map handleGenericException(Exception ex) {
        log.info("Generic exception", ex);
        return fieldError("unknown", Collections.singletonList(ex.getMessage()));
    }

    public Map fieldError(String field, Object message) {
        return error(Collections.singletonMap(field, Collections.singletonList(message)));
    }

    public Map error(Object message) {
        return Collections.singletonMap("error", message);
    }
}
