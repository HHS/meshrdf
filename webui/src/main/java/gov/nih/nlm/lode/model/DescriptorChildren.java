package gov.nih.nlm.lode.model;

import java.util.Collection;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder("descriptor,seealso,terms,qualifiers")
@JsonInclude(Include.NON_NULL)
public class DescriptorChildren {

    private String descriptor;
    private Collection<ResourceResult> seealso;
    private Collection<ResourceResult> terms;
    private Collection<ResourceResult> qualifiers;

    public DescriptorChildren() {
        this(null);
    }
    public DescriptorChildren(String descriptor) {
        this.descriptor = descriptor;
        qualifiers = null;
        terms = null;
        seealso = null;
    }

    public String getDescriptor() {
        return descriptor;
    }
    public void setDescriptor(String descriptor) {
        this.descriptor = descriptor;
    }

    public Collection<ResourceResult> getQualifiers() {
        return qualifiers;
    }
    public void setQualifiers(Collection<ResourceResult> qualifiers) {
        this.qualifiers = qualifiers;
    }

    public Collection<ResourceResult> getTerms() {
        return terms;
    }
    public void setTerms(Collection<ResourceResult> terms) {
        this.terms = terms;
    }

    @JsonProperty("seealso")
    public Collection<ResourceResult> getSeeAlso() {
        return seealso;
    }
    @JsonProperty("seealso")
    public void setSeeAlso(Collection<ResourceResult> seealso) {
        this.seealso = seealso;
    }
}
