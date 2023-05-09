package com.salesianostriana.dam.pdam.api.festival.repository;

import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface FestivalRepository extends JpaRepository<Festival, Long>, JpaSpecificationExecutor<Festival> {

    @Query("""
            SELECT d
            FROM Event e
            JOIN Discotheque d ON e.id = d.id
            WHERE TYPE(e) = Festival
            ORDER BY d.popularity DESC
            """)
    Page<Festival> findAll(Specification<Festival> spec, Pageable pageable);
}
