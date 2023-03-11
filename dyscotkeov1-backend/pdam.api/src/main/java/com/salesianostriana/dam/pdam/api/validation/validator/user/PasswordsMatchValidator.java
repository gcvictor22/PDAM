package com.salesianostriana.dam.pdam.api.validation.validator.user;

import com.salesianostriana.dam.pdam.api.validation.annotation.user.PasswodsMatch;
import org.springframework.beans.PropertyAccessorFactory;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class PasswordsMatchValidator implements ConstraintValidator<PasswodsMatch, Object> {

    private String passwordField;
    private String verifyPasswordField;

    @Override
    public void initialize(PasswodsMatch constraintAnnotation) {
        passwordField = constraintAnnotation.passwordField();
        verifyPasswordField  = constraintAnnotation.verifyPasswordField();
    }

    @Override
    public boolean isValid(Object o, ConstraintValidatorContext constraintValidatorContext) {
        String password = (String) PropertyAccessorFactory
                .forBeanPropertyAccess(o)
                .getPropertyValue(passwordField);

        String verifyPassword = (String) PropertyAccessorFactory
                .forBeanPropertyAccess(o)
                .getPropertyValue(verifyPasswordField);

        return StringUtils.hasText(password) && password.contentEquals(verifyPassword);
    }
}
