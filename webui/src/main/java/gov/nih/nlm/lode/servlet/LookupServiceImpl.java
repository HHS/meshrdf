package gov.nih.nlm.lode.servlet;

import java.util.Arrays;
import java.util.Collection;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import gov.nih.nlm.lode.model.LookupCriteria;
import gov.nih.nlm.lode.model.LookupService;
import uk.ac.ebi.fgpt.lode.utils.SparqlQueryReader;


/**
 * Responsible for looking up the URIs of descriptors, DQPairs, etc.
 *
 * @author davisda4
 */
@Service
public class LookupServiceImpl implements LookupService {

    private Resource extraQueries;
    private SparqlQueryReader queryReader;

    @Override
    public Collection<String> lookupDescriptors(LookupCriteria criteria) {
        return Arrays.asList(new String[] {
            "http://id.nlm.nih.gov/mesh/D01882",
            "http://id.nlm.nih.gov/mesh/D01883",
        });
    }

    @Override
    public Collection<String> lookupPairs(LookupCriteria criteria) {
        return Arrays.asList(new String[] {
            "http://id.nlm.nih.gov/mesh/Q01882",
            "http://id.nlm.nih.gov/mesh/Q01883",
        });
    }

    @Override
    public Resource getExtraQueries() {
        return extraQueries;
    }

    @Value("${lode.lookup.extra.queries:classpath:extra-queries.txt}")
    public void setExtraQueries(Resource extraQueries) {
        this.extraQueries = extraQueries;
    }

    @Override
    public synchronized SparqlQueryReader getQueryReader() {
        if (queryReader == null) {
            queryReader = new SparqlQueryReader();
            queryReader.setSparqlQueryResource(extraQueries);
            queryReader.init();
        }
        return queryReader;
    }
 }
