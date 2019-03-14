package gov.nih.nlm.lode.model;

import java.beans.PropertyEditorSupport;

public class RelationEditor extends PropertyEditorSupport {

    @Override
    public void setAsText(String text) {
        setValue(Relation.valueOf(text.toUpperCase()));
    }

    @Override
    public String getAsText() {
        return getValue().toString().toLowerCase();
    }
}
