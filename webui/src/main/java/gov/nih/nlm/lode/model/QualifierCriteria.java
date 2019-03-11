package gov.nih.nlm.lode.model;

public class QualifierCriteria {
    private String allowedFor;
    private String name;
    private Relation relation;

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public Relation getRelation() {
        return relation;
    }
    public void setRelation(Relation relation) {
        this.relation = relation;
    }

    public String getAllowedFor() {
        return allowedFor;
    }
    public void setAllowedFor(String allowedFor) {
        this.allowedFor = allowedFor;
    }
}
