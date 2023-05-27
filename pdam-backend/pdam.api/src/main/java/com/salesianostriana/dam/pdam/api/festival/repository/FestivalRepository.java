package com.salesianostriana.dam.pdam.api.festival.repository;

import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

public interface FestivalRepository extends JpaRepository<Festival, Long>, JpaSpecificationExecutor<Festival> {

    @Query("""
            SELECT d
            FROM Event e
            JOIN Festival d ON e.id = d.id
            WHERE TYPE(e) = Festival
            ORDER BY e.createdAt DESC
            """)
    Page<Festival> findAll(Specification<Festival> spec, Pageable pageable);
}
