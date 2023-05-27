package com.salesianostriana.dam.pdam.api.party.repository;

import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface PartyRepository extends JpaRepository<Party, Long> {
    Page<Party> findAll(@Nullable Specification<Post> spec, Pageable pageable);


    @Query("""
        SELECT p
        FROM Discotheque d JOIN d.parties p
        WHERE d.id = :id
        AND p.startAt > :currentDateTime
        """)
    Page<Party> findAllPartiesByDiscothequeId(@Param("id") Long id, Pageable pageable, @Param("currentDateTime") LocalDateTime currentDateTime);

}
