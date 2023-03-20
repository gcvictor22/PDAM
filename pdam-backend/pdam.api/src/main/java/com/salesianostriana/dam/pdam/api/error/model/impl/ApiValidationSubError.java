package com.salesianostriana.dam.pdam.api.error.model.impl;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianostriana.dam.pdam.api.error.model.ApiSubError;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.validation.FieldError;
import org.springframework.validation.ObjectError;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApiValidationSubError extends ApiSubError {

    private String object;
    private String message;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private String field;

    @JsonInclude(JsonInclude.Include.NON_NULL)
    private Object rejectedValue;



    public static ApiValidationSubError fromObjectError(ObjectError objectError) {
        if (objectError instanceof FieldError) {
            FieldError fieldError = (FieldError) objectError;

            return
                    ApiValidationSubError.builder()
                            .object(fieldError.getObjectName())
                            .field(fieldError.getField())
                            .rejectedValue(fieldError.getRejectedValue())
                            .message(fieldError.getDefaultMessage())
                            .build();

        }
        else
        {
            return
                    ApiValidationSubError.builder()
                            .object(objectError.getObjectName())
                            .message(objectError.getDefaultMessage())
                            .build();

        }
    }

}
