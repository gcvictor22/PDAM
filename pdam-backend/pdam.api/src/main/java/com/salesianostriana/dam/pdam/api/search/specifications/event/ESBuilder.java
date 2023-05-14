package com.salesianostriana.dam.pdam.api.search.specifications.event;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class ESBuilder  extends GSBuilder<Event> {

    public ESBuilder(List<SearchCriteria> params) {super(params, Event.class);}

}
