package com.salesianostriana.dam.pdam.api.search.specifications.post;

import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.search.specifications.GSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;

import java.util.List;

public class PSBuilder extends GSBuilder<Post> {
    public PSBuilder(List<SearchCriteria> params) {
        super(params, Post.class);
    }
}
