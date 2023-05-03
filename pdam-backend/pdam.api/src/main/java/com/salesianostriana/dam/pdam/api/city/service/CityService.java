package com.salesianostriana.dam.pdam.api.city.service;

import com.salesianostriana.dam.pdam.api.city.dto.GetCityDto;
import com.salesianostriana.dam.pdam.api.city.model.City;
import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.search.specifications.city.CSBuilder;
import com.salesianostriana.dam.pdam.api.search.specifications.user.USBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class CityService {

    private final CityRepository cityRepository;

    public List<GetCityDto> findAll(List<SearchCriteria> params) {

        CSBuilder csBuilder = new CSBuilder(params);

        Specification<City> spec = csBuilder.build();

        return cityRepository.findAll(spec).stream().map(GetCityDto::of).toList();
    }
}
