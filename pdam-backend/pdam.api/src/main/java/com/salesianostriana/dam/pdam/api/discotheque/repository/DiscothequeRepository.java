package com.salesianostriana.dam.pdam.api.discotheque.repository;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.lang.Nullable;

public interface DiscothequeRepository extends JpaRepository<Discotheque, Long> {

    @Query("""
            SELECT d
            FROM Event e
            JOIN Discotheque d ON e.id = d.id
            WHERE TYPE(e) = Discotheque
            ORDER BY d.popularity DESC
            """)
    Page<Discotheque> findAll(@Nullable Specification<Post> spec, Pageable pageable);


}
