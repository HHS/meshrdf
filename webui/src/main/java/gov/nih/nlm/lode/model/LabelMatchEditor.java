package gov.nih.nlm.lode.model;

import java.beans.PropertyEditorSupport;

public class LabelMatchEditor extends PropertyEditorSupport {

    public static final String ERROR_MESSAGE = "must be one of \"contains\", \"exact\", or \"startswith\"";

    @Override
    public void setAsText(String text) {
        try {
            setValue(LabelMatch.valueOf(text.toUpperCase()));
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException(ERROR_MESSAGE);
        }
    }

    @Override
    public String getAsText() {
        return getValue().toString().toLowerCase();
    }
}
