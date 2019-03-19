package gov.nih.nlm.lode.model;

import java.util.Collection;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

public interface LookupService {
    public Collection<ResourceAndLabel> lookupDescriptors(DescriptorCriteria criteria) throws LodeException;
    public Collection<ResourceAndLabel> lookupPairs(PairCriteria criteria) throws LodeException;
}
