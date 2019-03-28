package gov.nih.nlm.lode.model;

import javax.validation.constraints.NotEmpty;

public class LabelParams {
    @NotEmpty
    private String resource;

    public String getResource() {
        return resource;
    }
    public void setResource(String resource) {
        this.resource = resource;
    }
}
