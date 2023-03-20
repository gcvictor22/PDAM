package com.salesianostriana.dam.pdam.api.user.model;

import javax.persistence.AttributeConverter;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.stream.Collectors;

public class EnumRoleConverter implements AttributeConverter<EnumSet<UserRole>, String> {

    private final String SEPARADOR = ", ";


    @Override
    public String convertToDatabaseColumn(EnumSet<UserRole> attribute) {

        if (!attribute.isEmpty()) {
            return attribute.stream()
                    .map(UserRole::name)
                    .collect(Collectors.joining(SEPARADOR));
        }
        return null;
    }

    @Override
    public EnumSet<UserRole> convertToEntityAttribute(String dbData) {
        if (dbData != null) {
            if (!dbData.isBlank()) {
                return Arrays.stream(dbData.split(SEPARADOR))
                        .map(UserRole::valueOf)
                        .collect(Collectors.toCollection(() -> EnumSet.noneOf(UserRole.class)));
            }
        }
        return EnumSet.noneOf(UserRole.class);
    }

}
