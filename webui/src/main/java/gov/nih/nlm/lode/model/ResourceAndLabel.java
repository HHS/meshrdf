package gov.nih.nlm.lode.model;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder("resource,label")
public class ResourceAndLabel {

    private String resource;
    private String label;

    public ResourceAndLabel() {
        this(null, null);
    }
    public ResourceAndLabel(String resource, String label) {
        this.resource = resource;
        this.label = label;
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

    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        ResourceAndLabel rhs = (ResourceAndLabel) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(obj))
                .append(resource, rhs.resource)
                .append(label, rhs.label)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("resource", resource)
                .append("label", label)
                .toString();
    }
}
