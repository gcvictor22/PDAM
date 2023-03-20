package com.salesianostriana.dam.pdam.api.error.model;

import com.salesianostriana.dam.pdam.api.error.model.impl.ApiErrorImpl;
import com.salesianostriana.dam.pdam.api.error.model.impl.ApiValidationSubError;
import org.springframework.http.HttpStatus;
import org.springframework.validation.ObjectError;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;


public interface ApiError {

    HttpStatus getStatus();
    int getStatusCode();
    String getMessage();
    String getPath();
    LocalDateTime getDate();
    List<ApiSubError> getSubErrors();


    static ApiError fromErrorAttributes(Map<String, Object> defaultErrorAttributesMap) {

        int statusCode = ((Integer)defaultErrorAttributesMap.get("status")).intValue();


        ApiErrorImpl result =
                ApiErrorImpl.builder()
                        .status(HttpStatus.valueOf(statusCode))
                        .statusCode(statusCode)
                        .message((String) defaultErrorAttributesMap.getOrDefault("message", "No message available"))
                        .path((String) defaultErrorAttributesMap.getOrDefault("path", "No path available"))
                        .build();

        if (defaultErrorAttributesMap.containsKey("errors")) {

            List<ObjectError> errors = (List<ObjectError>) defaultErrorAttributesMap.get("errors");

            List<ApiSubError> subErrors = errors.stream()
                    .map(ApiValidationSubError::fromObjectError)
                    .collect(Collectors.toList());

            result.setSubErrors(subErrors);

        }

        return result;
    }


}