package com.salesianostriana.dam.pdam.api.validation.annotation.user;


import com.salesianostriana.dam.pdam.api.validation.validator.user.OnlyNumberValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = OnlyNumberValidator.class)
@Documented
public @interface OnlyNumber {

    String message() default "Solo se aceptan teléfonos de ESPAÑA";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    int min() default 9;
    int max() default 9;

    boolean hasNumber() default true;
}
