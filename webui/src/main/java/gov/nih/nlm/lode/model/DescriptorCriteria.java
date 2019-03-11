package gov.nih.nlm.lode.model;


import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Positive;


public class DescriptorCriteria {

    @NotEmpty()
    private String name;

    private String relation = "exact";

    @Positive
    @Max(100)
    private int limit = 10;

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getRelation() {
        return relation;
    }
    public void setRelation(String relation) {
        this.relation = relation;
    }

    public int getLimit() {
        return limit;
    }
    public void setLimit(int limit) {
        this.limit = limit;
    }
}
