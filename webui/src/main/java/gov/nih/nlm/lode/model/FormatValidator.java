package gov.nih.nlm.lode.model;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import uk.ac.ebi.fgpt.lode.utils.GraphQueryFormats;
import uk.ac.ebi.fgpt.lode.utils.TupleQueryFormats;


public class FormatValidator implements
  ConstraintValidator<FormatConstraint, String> {

    @Override
    public void initialize(FormatConstraint constraint) {
    }

    @Override
    public boolean isValid(String format,
      ConstraintValidatorContext cxt) {
        if (format == null || format.equals("HTML"))
          return true;       
        for (GraphQueryFormats aformat : GraphQueryFormats.class.getEnumConstants()) {
          if (format.equals(aformat.toString()))
            return true;
        }
        for (TupleQueryFormats aformat : TupleQueryFormats.class.getEnumConstants()) {
          if (format.equals(aformat.toString()))
            return true;
        }
        return false;
    }
}