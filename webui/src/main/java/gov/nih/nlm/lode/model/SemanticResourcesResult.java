package gov.nih.nlm.lode.model;

import java.util.Collection;
import java.util.Collections;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder({"params", "total", "results"})
@JsonInclude(Include.NON_NULL)
public class SemanticResourcesResult {
    private SemanticSearchParams params;
    private int total;
    private Collection<ResourceAndLabel> results;

    public SemanticResourcesResult(SemanticSearchParams params, Collection<ResourceAndLabel> results, int total) {
        this.params = params;
        this.results = results;
        this.setTotal(total);
    }
    public SemanticResourcesResult(SemanticSearchParams params, Collection<ResourceAndLabel> results) {
        this(params, results, results.size());
    }
    public SemanticResourcesResult(SemanticSearchParams params) {
        this(params, Collections.<ResourceAndLabel>emptyList());
    }
    public SemanticResourcesResult() {
        this(null);
    }

    public SemanticSearchParams getParams() {
        return params;
    }
    public void setParams(SemanticSearchParams params) {
        this.params = params;
    }

    public int getTotal() {
        return total;
    }
    public void setTotal(int total) {
        this.total = total;
    }

    public Collection<ResourceAndLabel> getResults() {
        return results;
    }
    public void setResults(Collection<ResourceAndLabel> results) {
        this.results = results;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        SemanticResourcesResult rhs = (SemanticResourcesResult) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(obj))
                .append(params, rhs.params)
                .append(total, rhs.params)
                .append(results, rhs.results)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("params", params)
                .append("total", total)
                .append("results", results)
                .toString();
    }
}
