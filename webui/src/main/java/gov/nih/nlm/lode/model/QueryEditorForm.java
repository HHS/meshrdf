package gov.nih.nlm.lode.model;

import javax.validation.constraints.Positive;
import javax.validation.constraints.PositiveOrZero;
import javax.validation.constraints.Max;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;


public class QueryEditorForm {

    private String query;
    private Boolean inference;

    @Positive @Max(1000)
    private Integer limit;

    @PositiveOrZero
    private Integer offset;

    @FormatConstraint
    private String format;

    /**
     * Year has already been applied to the query and does not need seperate validation
     * or to be part of equals or toString.
     */
    @MeshYear
    private String year;

    public String getQuery() {
        return query;
    }
    public void setQuery(String query) {
        this.query = query;
    }
    public Boolean getInference() {
        return inference;
    }
    public void setInference(Boolean inference) {
        this.inference = inference;
    }
    public Integer getLimit() {
        return limit;
    }
    public void setLimit(Integer limit) {
        this.limit = limit;
    }
    public Integer getOffset() {
        return offset;
    }
    public void setOffset(Integer offset) {
        this.offset = offset;
    }
    public String getFormat() {
        return format;
    }
    public void setFormat(String format) {
        this.format = format;
    }
    public String getYear() {
        return year;
    }
    public void setYear(String year) {
        this.year = year;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        QueryEditorForm rhs = (QueryEditorForm) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(rhs))
                .append(query, rhs.query)
                .append(inference, rhs.inference)
                .append(limit, rhs.limit)
                .append(offset, rhs.offset)
                .append(format, rhs.format)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("query", query)
                .append("inference", inference)
                .append("limit", limit)
                .append("offset", offset)
                .append("format", format)
                .toString();
    }
}
