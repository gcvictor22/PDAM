package com.salesianostriana.dam.pdam.api.validation.annotation.user;

import com.salesianostriana.dam.pdam.api.validation.validator.user.DontFieldsValueMatchValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ ElementType.TYPE })
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = DontFieldsValueMatchValidator.class)
@Documented
public @interface DontFieldsValueMatch {

    String message() default "Los valores de los campos coinciden";

    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};

    String field();
    String fieldMatch();

    @Target({ ElementType.TYPE })
    @Retention(RetentionPolicy.RUNTIME)
    @interface List {
        DontFieldsValueMatch[] value();
    }


}