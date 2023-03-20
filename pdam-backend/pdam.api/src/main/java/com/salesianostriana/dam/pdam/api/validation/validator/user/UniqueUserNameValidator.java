package com.salesianostriana.dam.pdam.api.validation.validator.user;

import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.UniqueUserName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniqueUserNameValidator implements ConstraintValidator<UniqueUserName, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userService.existsByUserName(s);
    }
}
