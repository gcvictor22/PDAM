package com.salesianostriana.dam.pdam.api.validation.validator.user;

import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniquePhoneNumber;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniquePhoneNumberValidator implements ConstraintValidator<UniquePhoneNumber, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String p, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(p) && !userService.existsByPhoneNumber(p);
    }
}
