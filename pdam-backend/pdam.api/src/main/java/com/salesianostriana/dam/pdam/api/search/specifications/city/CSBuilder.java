package com.salesianostriana.dam.pdam.api.search.specifications.city;

import com.salesianostriana.dam.pdam.api.city.model.City;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class CSBuilder extends GSBuilder<City> {

    public CSBuilder(List<SearchCriteria> params) {
        super(params, City.class);
    }

}
