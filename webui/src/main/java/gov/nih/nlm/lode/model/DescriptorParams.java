package gov.nih.nlm.lode.model;


import javax.validation.constraints.Max;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Positive;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;


@JsonInclude(Include.NON_NULL)
public class DescriptorParams {

    @NotEmpty()
    private String label;

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

    @JsonProperty("query")
    public void setQuery(String query) {
        this.label = query;
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

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        DescriptorParams rhs = (DescriptorParams) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(rhs))
                .append(label, rhs.label)
                .append(match, rhs.match)
                .append(limit, rhs.limit)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("label", label)
                .append("relation", match)
                .append("limit", limit)
                .toString();
    }
}
