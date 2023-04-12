package com.salesianostriana.dam.pdam.api.festival.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.event.model.EventType;
import com.salesianostriana.dam.pdam.api.exception.notfound.CityNotFoundException;
import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.festival.repository.FestivalRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.EnumSet;

@Service
@AllArgsConstructor
public class FestivalService {

    private final FestivalRepository festivalRepository;
    private final CityRepository cityRepository;

    public GetFestivalDto save(NewFestivalDto newFestivalDto) {

        Festival festival = Festival.builder()
                .name(newFestivalDto.getName())
                .location(newFestivalDto.getLocation())
                .city(cityRepository.findById(newFestivalDto.getCityId()).orElseThrow(() -> new CityNotFoundException(newFestivalDto.getCityId())))
                .capacity(newFestivalDto.getCapacity())
                .date(newFestivalDto.getDate())
                .duration(newFestivalDto.getDuration())
                .price(newFestivalDto.getPrice())
                .drinkIncluded(newFestivalDto.isDrinkIncluded())
                .numberOfDrinks(newFestivalDto.getNumberOfDrinks())
                .adult(newFestivalDto.isAdult())
                .type(EnumSet.of(EventType.FESTIVAL))
                .build();

        return GetFestivalDto.of(festivalRepository.save(festival));
    }
}