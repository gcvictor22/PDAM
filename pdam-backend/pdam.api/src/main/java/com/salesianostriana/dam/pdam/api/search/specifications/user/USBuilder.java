package com.salesianostriana.dam.pdam.api.search.specifications.user;

import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class USBuilder extends GSBuilder<User> {
    public USBuilder(List<SearchCriteria> params) {
        super(params, User.class);
    }
}
