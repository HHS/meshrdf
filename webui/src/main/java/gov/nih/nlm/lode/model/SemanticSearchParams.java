package gov.nih.nlm.lode.model;


import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Positive;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;


@JsonInclude(Include.NON_NULL)
public class SemanticSearchParams {

    @NotEmpty()
    private String label;

    private String type;

    private String graph;

    private String descriptor;

    private LabelMatch match = LabelMatch.EXACT;

    @Positive
    @Max(50)
    private int limit = 10;

    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
    public LabelMatch getMatch() {
        return match;
    }
    public void setMatch(LabelMatch match) {
        this.match = match;
    }
    public void setMatch(String match) {
        setMatch(LabelMatch.valueOf(match.toUpperCase()));
    }

    public int getLimit() {
        return limit;
    }
    public void setLimit(int limit) {
        this.limit = limit;
    }
    public String getGraph() {
        return graph;
    }
    public void setGraph(String graph) {
        this.graph = graph;
    }
    public String getDescriptor() {
        return descriptor;
    }
    public void setDescriptor(String descriptor) {
        this.descriptor = descriptor;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        SemanticSearchParams rhs = (SemanticSearchParams) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(rhs))
                .append(label, rhs.label)
                .append(type, rhs.type)
                .append(graph, rhs.graph)
                .append(descriptor, rhs.descriptor)
                .append(match, rhs.match)
                .append(limit, rhs.limit)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("label", label)
                .append("type", type)
                .append("graph", graph)
                .append("descriptor", descriptor)
                .append("relation", match)
                .append("limit", limit)
                .toString();
    }
}
