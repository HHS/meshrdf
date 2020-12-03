package gov.nih.nlm.lode.model;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ValidYears {
    private Integer current;
    private Integer interim;
    private Integer[] years;

    /* Constructors */
    public ValidYears(Integer current, Integer interim) {
        this.current = current;
        this.interim = interim;
    }
    public ValidYears(Integer current) {
        this(current, null);
    }
    public ValidYears() {
        this(null, null);
    }

    /* Getters and setters */
    public Integer getCurrent() {
        return current;
    }
    public void setCurrent(Integer current) {
        this.current = current;
    }
    public Integer getInterim() {
        return interim;
    }
    public void setInterim(Integer interim) {
        this.interim = interim;
    }
    public Integer[] getYears() {
        return years;
    }
    public void setYears(Integer[] years) {
        this.years = years;
    }

    /* overrides */
    @Override
    public boolean equals(Object obj) {
        if (obj == null) { return false; }
        if (obj == this) { return true; }
        if (obj.getClass() != this.getClass()) {
            return false;
        }
        ValidYears rhs = (ValidYears) obj;
        return new EqualsBuilder()
                .appendSuper(super.equals(rhs))
                .append(current, rhs.current)
                .append(interim, rhs.interim)
                .append(years, rhs.years)
                .isEquals();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.SHORT_PREFIX_STYLE)
                .append("current", current)
                .append("interim", interim)
                .append("years", years)
                .toString();
    }
}
