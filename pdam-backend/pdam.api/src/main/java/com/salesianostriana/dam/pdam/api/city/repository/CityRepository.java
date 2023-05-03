package com.salesianostriana.dam.pdam.api.city.repository;

import com.salesianostriana.dam.pdam.api.city.model.City;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface CityRepository extends JpaRepository<City, Long>, JpaSpecificationExecutor<City> {

}
