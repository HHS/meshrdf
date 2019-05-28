package gov.nih.nlm.lode.model;

import java.util.Collection;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

public interface LookupService {
    public Collection<ResourceResult> lookupDescriptors(DescriptorParams criteria) throws LodeException;
    public Collection<ResourceResult> lookupDescriptorConcepts(String descriptorUri) throws LodeException;
    public Collection<ResourceResult> lookupDescriptorTerms(String descriptorUri) throws LodeException;
    public Collection<ResourceResult> lookupDescriptorSeeAlso(String descriptorUri) throws LodeException;
    public Collection<ResourceResult> lookupPairs(PairParams criteria) throws LodeException;
    public Collection<ResourceResult> lookupTerms(DescriptorParams criteria) throws LodeException;
    public Collection<ResourceResult> allowedQualifiers(String descriptorUri) throws LodeException;
    public Collection<String> lookupLabel(String resoureUri) throws LodeException;
}

