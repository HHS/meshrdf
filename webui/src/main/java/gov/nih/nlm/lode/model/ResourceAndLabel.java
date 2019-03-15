package gov.nih.nlm.lode.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder("resource,label")
public class ResourceAndLabel {

    private String resource;
    private String label;

    public ResourceAndLabel() {
        this(null, null);
    }
    public ResourceAndLabel(String resource, String label) {
        this.resource = resource;
        this.label = label;
    }

    @JsonProperty
    public String getResource() {
        return resource;
    }
    public void setResource(String resource) {
        this.resource = resource;
    }

    @JsonProperty
    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }
}
