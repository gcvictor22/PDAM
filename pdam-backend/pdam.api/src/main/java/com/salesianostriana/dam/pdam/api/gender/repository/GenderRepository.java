package com.salesianostriana.dam.pdam.api.gender.repository;

import com.salesianostriana.dam.pdam.api.gender.model.Gender;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GenderRepository extends JpaRepository<Gender, Long> {
}
