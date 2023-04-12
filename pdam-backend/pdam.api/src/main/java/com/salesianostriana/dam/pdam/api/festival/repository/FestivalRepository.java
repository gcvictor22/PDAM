package com.salesianostriana.dam.pdam.api.festival.repository;

import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FestivalRepository extends JpaRepository<Festival, Long> {
}
