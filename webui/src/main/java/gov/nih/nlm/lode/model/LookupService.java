package gov.nih.nlm.lode.model;

import java.util.Collection;

import org.springframework.core.io.Resource;

import uk.ac.ebi.fgpt.lode.utils.SparqlQueryReader;

public interface LookupService {
    public static final String DESCRIPTOR_QUERY_PREFIX = "LOOKUP.DESCRIPTORS.";
    public static final String PAIR_QUERY_PREFIX = "LOOKUP.PAIRS.";
    public static final String ALLOWED_QUALIFERS_ID = "LOOKUP.ALLOWED.QUALIFIERS";

    public Collection<String> lookupDescriptors(LookupCriteria criteria);
    public Collection<String> lookupPairs(LookupCriteria criteria);

    public Resource getExtraQueries();
    public SparqlQueryReader getQueryReader();
}
