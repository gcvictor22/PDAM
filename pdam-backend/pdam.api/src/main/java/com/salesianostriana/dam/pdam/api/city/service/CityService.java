package com.salesianostriana.dam.pdam.api.city.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class CityService {

    private final CityRepository cityRepository;

}
