package com.salesianostriana.dam.pdam.api.festival.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.discotheque.dto.GetDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.event.model.EventType;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyFestivalListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.CityNotFoundException;
import com.salesianostriana.dam.pdam.api.festival.dto.GetFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.dto.NewFestivalDto;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import com.salesianostriana.dam.pdam.api.festival.repository.FestivalRepository;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.specifications.dicotheque.DSBuilder;
import com.salesianostriana.dam.pdam.api.search.specifications.festival.FSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.EnumSet;
import java.util.List;

@Service
@AllArgsConstructor
public class FestivalService {

    private final FestivalRepository festivalRepository;
    private final CityRepository cityRepository;

    public GetPageDto<GetFestivalDto> findAll(List<SearchCriteria> params, Pageable pageable) {
        if (festivalRepository.findAll().isEmpty()){
            throw new EmptyFestivalListException();
        }

        FSBuilder psBuilder = new FSBuilder(params);

        Specification<Festival> spec = psBuilder.build();
        Page<GetFestivalDto> pageGetDiscothequeDto = festivalRepository.findAll(spec, pageable).map(GetFestivalDto::of);

        return new GetPageDto<>(pageGetDiscothequeDto);
    }

    public GetFestivalDto save(NewFestivalDto newFestivalDto) {

        Festival festival = Festival.builder()
                .name(newFestivalDto.getName())
                .location(newFestivalDto.getLocation())
                .city(cityRepository.findById(newFestivalDto.getCityId()).orElseThrow(() -> new CityNotFoundException(newFestivalDto.getCityId())))
                .capacity(newFestivalDto.getCapacity())
                .dateTime(newFestivalDto.getDate())
                .duration(newFestivalDto.getDuration())
                .price(newFestivalDto.getPrice())
                .drinkIncluded(newFestivalDto.isDrinkIncluded())
                .numberOfDrinks(newFestivalDto.getNumberOfDrinks())
                .adult(newFestivalDto.isAdult())
                .type(EnumSet.of(EventType.FESTIVAL))
                .imgPath("default-events.png")
                .build();

        return GetFestivalDto.of(festivalRepository.save(festival));
    }
}