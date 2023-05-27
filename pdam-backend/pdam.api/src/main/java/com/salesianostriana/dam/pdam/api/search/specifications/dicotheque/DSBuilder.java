package com.salesianostriana.dam.pdam.api.search.specifications.dicotheque;

import com.salesianostriana.dam.pdam.api.city.model.City;
import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class DSBuilder extends GSBuilder<Discotheque> {

    public DSBuilder(List<SearchCriteria> params) {super(params, Discotheque.class);}

}
