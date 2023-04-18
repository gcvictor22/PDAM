package com.salesianostriana.dam.pdam.api.festival.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.festival.model.Festival;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetFestivalDto {

    private Long id;
    private String name;
    private String description;
    private String location;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime date;

    private int duration;
    private int remainingTickets;
    private String city;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private boolean adult;

    public static GetFestivalDto of(Festival festival) {

        return GetFestivalDto.builder()
                .id(festival.getId())
                .description(festival.getDescription())
                .name(festival.getName())
                .location(festival.getLocation())
                .date(festival.getDate())
                .duration(festival.getDuration())
                .remainingTickets(festival.getCapacity()-festival.getClients().size())
                .city(festival.getCity().getName())
                .price(festival.getPrice())
                .drinkIncluded(festival.isDrinkIncluded())
                .numberOfDrinks(festival.getNumberOfDrinks())
                .adult(festival.isAdult())
                .build();
    }
}