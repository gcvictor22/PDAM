package com.salesianostriana.dam.pdam.api.validation.validator.user;

import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniqueEmail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String e, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(e) && !userService.existsByEmail(e);
    }
}
