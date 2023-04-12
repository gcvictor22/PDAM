package com.salesianostriana.dam.pdam.api.event.model;

import javax.persistence.AttributeConverter;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.stream.Collectors;

public class EnumTypeConverter implements AttributeConverter<EnumSet<EventType>, String> {

    private final String SEPARADOR = ", ";


    @Override
    public String convertToDatabaseColumn(EnumSet<EventType> attribute) {

        if (!attribute.isEmpty()) {
            return attribute.stream()
                    .map(EventType::name)
                    .collect(Collectors.joining(SEPARADOR));
        }
        return null;
    }

    @Override
    public EnumSet<EventType> convertToEntityAttribute(String dbData) {
        if (dbData != null) {
            if (!dbData.isBlank()) {
                return Arrays.stream(dbData.split(SEPARADOR))
                        .map(EventType::valueOf)
                        .collect(Collectors.toCollection(() -> EnumSet.noneOf(EventType.class)));
            }
        }
        return EnumSet.noneOf(EventType.class);
    }

}
