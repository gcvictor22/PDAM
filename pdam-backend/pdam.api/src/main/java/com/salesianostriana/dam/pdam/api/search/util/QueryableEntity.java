package com.salesianostriana.dam.pdam.api.search.util;

import java.lang.reflect.Field;
import java.util.Arrays;

public interface QueryableEntity {

    static boolean checkQueryParams(Class cl, String name){
        return Arrays.stream(cl.getDeclaredFields())
                .map(Field::getName)
                .anyMatch(n -> n.equalsIgnoreCase(name));
    }

}
