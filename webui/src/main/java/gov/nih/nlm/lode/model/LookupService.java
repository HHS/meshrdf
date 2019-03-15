package gov.nih.nlm.lode.model;

import java.util.Collection;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

public interface LookupService {
    public Collection<String> lookupDescriptors(LookupCriteria criteria) throws LodeException;
    public Collection<String> lookupPairs(LookupCriteria criteria) throws LodeException;
}
