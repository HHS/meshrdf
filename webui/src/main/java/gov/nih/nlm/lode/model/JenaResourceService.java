package gov.nih.nlm.lode.model;

import java.util.Collection;

import uk.ac.ebi.fgpt.lode.exception.LodeException;

public interface JenaResourceService {
    public Collection<String> getResourcesFromLabel(String query, String label, int limit) throws LodeException;
    public Collection<String> getLabelsFromResource(String query, String resourceUri);
}
