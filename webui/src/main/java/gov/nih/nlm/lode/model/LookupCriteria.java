package gov.nih.nlm.lode.model;


import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Positive;


public class LookupCriteria {

    @NotEmpty()
    private String label;

    private Relation relation = Relation.EXACT;

    @Positive
    @Max(50)
    private int limit = 10;

    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }

    public Relation getRelation() {
        return relation;
    }
    public void setRelation(Relation relation) {
        this.relation = relation;
    }
    public void setRelation(String relation) {
        setRelation(Relation.valueOf(relation.toUpperCase()));
    }

    public int getLimit() {
        return limit;
    }
    public void setLimit(int limit) {
        this.limit = limit;
    }
}
