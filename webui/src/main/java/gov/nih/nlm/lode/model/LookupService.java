package gov.nih.nlm.lode.model;

import java.util.Collection;

public interface LookupService {
    public Collection<String> lookupDescriptors(LookupCriteria criteria);
    public Collection<String> lookupPairs(LookupCriteria criteria);
}
