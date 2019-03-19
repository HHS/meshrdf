package gov.nih.nlm.lode.model;

import javax.validation.constraints.Max;
import javax.validation.constraints.Positive;

public class LabelCriteria {
    private String resource;

    private String identifier;

    @Positive
    @Max(50)
    private int limit = 10;

    public String getResource() {
        return resource;
    }

    public void setResource(String resource) {
        this.resource = resource;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public int getLimit() {
        return limit;
    }

    public void setLimit(int limit) {
        this.limit = limit;
    }
}
