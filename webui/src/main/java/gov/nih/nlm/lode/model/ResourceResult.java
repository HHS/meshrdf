package gov.nih.nlm.lode.model;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder("resource,label,preferred")
@JsonInclude(Include.NON_NULL)
public class ResourceResult {

    private String resource;
    private String label;
    private Boolean preferred;

    public ResourceResult() {
        this(null, null);
    }
    public ResourceResult(String resource, String label) {
        this(resource, label, null);
    }
    public ResourceResult(String resource, String label, Boolean preferred) {
        this.resource = resource;
        this.label = label;
        this.preferred = preferred;
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

    @JsonProperty
    public Boolean getPreferred() {
        return preferred;
    }
    public void setPreferred(Boolean preferred) {
        this.preferred = preferred;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        ResourceResult rhs = (ResourceResult) obj;
        return new EqualsBuilder()
                 .append(resource, rhs.resource)
                .append(label, rhs.label)
                .append(preferred, rhs.preferred)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("resource", resource)
                .append("label", label)
                .append("preferred", preferred)
                .toString();
    }
}
