package gov.nih.nlm.lode.model;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;



public class MeshYearValidator implements
  ConstraintValidator<MeshYear, String> {

    @Override
    public void initialize(MeshYear constraint) {
    }

    @Override
    public boolean isValid(String meshYear,
      ConstraintValidatorContext cxt) {
        if (meshYear == null)
            return true;
        return meshYear.matches("[0-9]+") ||
               meshYear.equals("current") ||
               meshYear.equals("interim");
    }
}
