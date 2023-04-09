package com.salesianostriana.dam.pdam.api.party.repository;

import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.lang.Nullable;

import java.util.Optional;

public interface PartyRepository extends JpaRepository<Party, Long> {
    Page<Party> findAll(@Nullable Specification<Post> spec, Pageable pageable);
}
