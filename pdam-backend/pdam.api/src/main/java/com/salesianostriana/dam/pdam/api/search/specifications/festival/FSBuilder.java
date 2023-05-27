package com.salesianostriana.dam.pdam.api.search.specifications.festival;

import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class FSBuilder extends GSBuilder<Festival> {

    public FSBuilder(List<SearchCriteria> params) {super(params, Festival.class);}

}
