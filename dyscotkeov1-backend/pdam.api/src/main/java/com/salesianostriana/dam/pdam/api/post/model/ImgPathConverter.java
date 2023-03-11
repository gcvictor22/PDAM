package com.salesianostriana.dam.pdam.api.post.model;

import javax.persistence.AttributeConverter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.EnumSet;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ImgPathConverter implements AttributeConverter<List<String>, String> {

    private final String SEPARADOR = ", ";

    @Override
    public String convertToDatabaseColumn(List<String> imgPaths) {

        if (!imgPaths.isEmpty()) {
            return String.join(SEPARADOR, imgPaths);
        }

        return "VACIO";
    }

    @Override
    public List<String> convertToEntityAttribute(String dbData) {
        if (dbData != null) {
            if (!dbData.isBlank()) {
                return new ArrayList<>(Arrays.asList(dbData.split(SEPARADOR)));
            }
        }
        assert dbData != null;
        return List.of(dbData);
    }

}
