package gov.nih.nlm.lode.model;

import java.util.Collection;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

public interface JenaResourceService {
    public Collection<ResourceResult> getResources(String query, String label, int limit) throws LodeException;
    public Collection<ResourceResult> getResources(String query, String label, int limit, String parentUri) throws LodeException;
    public Collection<ResourceResult> getChildResources(String query, String parentUri) throws LodeException;
    public Collection<String> getResourceLabels(String query, String resourceUri) throws LodeException;
}
