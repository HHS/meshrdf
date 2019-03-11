package gov.nih.nlm.lode.servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hp.hpl.jena.query.QueryParseException;

import gov.nih.nlm.lode.model.DescriptorCriteria;
import gov.nih.nlm.lode.model.QualifierCriteria;
import uk.ac.ebi.fgpt.lode.exception.LodeException;

@Validated
@RestController
@RequestMapping("lookup")
public class LookupController {

    private Logger log = LoggerFactory.getLogger(getClass());

    @RequestMapping(path="/descriptor", produces="application/json")
    public List<String> descriptor(@Valid DescriptorCriteria criteria,
            HttpServletRequest request,
            HttpServletResponse response) throws QueryParseException, LodeException, IOException {
        log.info(String.format("criteria name=%s, rel=%s, limit=%s", criteria.getName(), criteria.getRelation(), criteria.getLimit()));
        return Arrays.asList(new String[] {
              "http://id.nlm.nih.gov/mesh/D01882",
              "http://id.nlm.nih.gov/mesh/D01883",
        });
    }

    @RequestMapping(path="/qualifier", produces="application/json")
    public List<String> qualifier(@Valid QualifierCriteria criteria) throws IOException {
        log.info(String.format("criteria name=%s", criteria.getName()));
        return Arrays.asList(new String[] {
                "http://id.nlm.nih.gov/mesh/Q01882",
                "http://id.nlm.nih.gov/mesh/Q01883",
          });
    }
}
