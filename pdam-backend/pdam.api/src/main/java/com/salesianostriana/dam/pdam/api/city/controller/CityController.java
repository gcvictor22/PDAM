package com.salesianostriana.dam.pdam.api.city.controller;

import com.salesianostriana.dam.pdam.api.city.dto.GetCityDto;
import com.salesianostriana.dam.pdam.api.city.service.CityService;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/city")
public class CityController {

    private final CityService cityService;

    @GetMapping("/")
    public List<GetCityDto> findAll(@RequestParam(value = "s", defaultValue = "") String search){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return cityService.findAll(params);
    }

}
