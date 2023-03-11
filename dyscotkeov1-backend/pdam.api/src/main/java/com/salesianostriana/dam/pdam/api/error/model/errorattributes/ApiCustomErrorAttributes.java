package com.salesianostriana.dam.pdam.api.error.model.errorattributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.salesianostriana.dam.pdam.api.error.model.ApiError;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.web.error.ErrorAttributeOptions;
import org.springframework.boot.web.servlet.error.DefaultErrorAttributes;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.WebRequest;

import java.util.Map;

@Order(value = Ordered.HIGHEST_PRECEDENCE)
@Component
@RequiredArgsConstructor
public class ApiCustomErrorAttributes extends DefaultErrorAttributes {

    private final ObjectMapper objectMapper;

    @Override
    public Map<String, Object> getErrorAttributes(WebRequest webRequest, ErrorAttributeOptions options) {
        Map<String,Object> defaultErrorAttributes = super.getErrorAttributes(webRequest, options);
        ApiError apiError = ApiError.fromErrorAttributes(defaultErrorAttributes);
        return objectMapper.convertValue(apiError, Map.class);
    }
}
