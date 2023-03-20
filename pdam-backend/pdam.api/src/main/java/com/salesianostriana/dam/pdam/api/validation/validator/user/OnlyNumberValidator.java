package com.salesianostriana.dam.pdam.api.validation.validator.user;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.OnlyNumber;
import org.passay.*;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.ArrayList;
import java.util.List;

public class OnlyNumberValidator implements ConstraintValidator<OnlyNumber, String> {

    int min, max;
    boolean hasNumber;

    @Override
    public void initialize(OnlyNumber constraintAnnotation) {
        min = constraintAnnotation.min();
        max = constraintAnnotation.max();
        hasNumber = constraintAnnotation.hasNumber();
    }

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {

        List<Rule> rules = new ArrayList<>();

        rules.add(new LengthRule(min, max));

        if (hasNumber)
            rules.add(new CharacterRule(EnglishCharacterData.Digit, 1));

        PasswordValidator validator = new PasswordValidator(rules);

        RuleResult result = validator.validate(new PasswordData(s));

        return result.isValid();

    }
}
