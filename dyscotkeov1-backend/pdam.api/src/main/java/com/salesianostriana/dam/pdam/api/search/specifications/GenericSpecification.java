
package com.salesianostriana.dam.pdam.api.search.specifications;

import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.AllArgsConstructor;
import lombok.extern.java.Log;
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

@Log
@AllArgsConstructor
public class GenericSpecification<T> implements Specification<T> {

    private SearchCriteria searchCriteria;

    @Override
    public Predicate toPredicate(Root<T> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
        Class type = root.get(searchCriteria.getKey()).getJavaType();
        String key = searchCriteria.getKey();
        String operator = searchCriteria.getOperator();
        Object value = searchCriteria.getValue();

        if (operator.equalsIgnoreCase(">")){
            if (isTemporal(type)){
                return criteriaBuilder.greaterThanOrEqualTo(root.get(key), getTemporalValue(value, type));
            }
            return criteriaBuilder.greaterThanOrEqualTo(root.<String>get(key), value.toString());
        } else if (operator.equalsIgnoreCase("<")){
            if (isTemporal(type)){
                return criteriaBuilder.lessThanOrEqualTo(root.get(key), getTemporalValue(value, type));
            }
            return criteriaBuilder.lessThanOrEqualTo(root.<String>get(key), value.toString());
        } else if (operator.equalsIgnoreCase(":")) {
            if (isString(type)){
                if (searchCriteria.getValue().toString().charAt(0) == '*') {
                    String newValue = searchCriteria.getValue().toString().substring(1);
                    return criteriaBuilder.like(root.get(searchCriteria.getKey()), newValue + "%");
                }else {
                    return criteriaBuilder.like(
                            root.get(searchCriteria.getKey()), "%" + searchCriteria.getValue().toString() + "%"
                    );
                }
            } else if (isBooleam(type)) {
                if (isValidBooleanValue(value.toString()))
                    return criteriaBuilder.equal(root.get(key), getBooleanValue(value.toString()));
                else
                    return null;
            } else if (isTemporal(type)) {
                return criteriaBuilder.equal(root.get(key), getTemporalValue(value, type));
            }else {
                return criteriaBuilder.equal(root.<String>get(searchCriteria.getKey()), searchCriteria.getValue());
            }
        }

        return null;
    }

    private boolean isBooleam(Class cl){
        return cl.getName().toLowerCase().contains("boolean");
    }

    private boolean isTemporal(Class cl) {
        return Arrays.stream(cl.getInterfaces()).anyMatch(c -> c.getName() == "java.time.temporal.Temporal");
    }

    private boolean isLocalDate(Class cl){
        return cl == LocalDate.class;
    }

    private boolean isLocalDateTime(Class cl){
        return cl == LocalDateTime.class;
    }

    private boolean isLocalTime(Class cl){
        return cl == LocalTime.class;
    }

    private boolean isString(Class cl){
        return cl == String.class;
    }

    private Comparable getTemporalValue(Object val, Class cl){
        Comparable res;

        if (isLocalDate(cl)){
            res = LocalDate.parse(val.toString());
        } else if (isLocalDateTime(cl)) {
            res = LocalDateTime.parse(val.toString(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH_mm_ss"));
        } else if (isLocalTime(cl)) {
            res = LocalTime.parse(val.toString(), DateTimeFormatter.ofPattern("HH_mm_ss"));
        }else {
            return null;
        }

        return res;
    }

    private boolean getBooleanValue(String val){
        return (val.equalsIgnoreCase("true")) || val.equalsIgnoreCase("1");
    }

    private boolean isValidBooleanValue(String val){
        return (val.equalsIgnoreCase("true")) || val.equalsIgnoreCase("1")
                || val.equalsIgnoreCase("false") || val.equalsIgnoreCase("0");
    }


}
