package gov.nih.nlm.lode.model;

import static java.util.stream.Collectors.toSet;

import java.util.Set;
import java.util.stream.Stream;

import javax.validation.constraints.NotEmpty;


public class DescriptorChildrenParams {

    @NotEmpty
    private String descriptor;

    private Set<String> includes;

    public DescriptorChildrenParams() {
        setIncludes("seealso,qualifiers,terms");
    }

    public String getDescriptor() {
        return descriptor;
    }
    public void setDescriptor(String descriptor) {
        this.descriptor = descriptor;
    }

    public Set<String> getIncludes() {
        return includes;
    }
    public void setIncludes(Set<String> includes) {
        this.includes = includes;
    }
    public void setIncludes(String includes) {
        this.includes = Stream.of(includes.split(",")).collect(toSet());
    }

    public boolean includes(String category) {
        return this.includes.contains(category);
    }
}
