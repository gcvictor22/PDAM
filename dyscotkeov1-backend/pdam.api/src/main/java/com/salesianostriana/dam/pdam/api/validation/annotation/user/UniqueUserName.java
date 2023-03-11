package com.salesianostriana.dam.pdam.api.validation.annotation.user;

import com.salesianostriana.dam.pdam.api.validation.validator.user.UniqueUserNameValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueUserNameValidator.class)
@Documented
public @interface UniqueUserName {

    String message() default "El nombre de usuario ya existe";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}


