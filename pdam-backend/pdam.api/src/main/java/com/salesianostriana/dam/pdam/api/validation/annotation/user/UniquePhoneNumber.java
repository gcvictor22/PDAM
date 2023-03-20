package com.salesianostriana.dam.pdam.api.validation.annotation.user;

import com.salesianostriana.dam.pdam.api.validation.validator.user.UniquePhoneNumberValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniquePhoneNumberValidator.class)
@Documented
public @interface UniquePhoneNumber {

    String message() default "El numero de teléfono ya existe";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}


