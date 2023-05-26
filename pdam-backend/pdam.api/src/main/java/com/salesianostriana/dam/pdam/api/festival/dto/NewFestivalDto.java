package com.salesianostriana.dam.pdam.api.festival.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NewFestivalDto {

    private String name;
    private String description;
    private String location;
    private Long cityId;
    private int capacity;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime dateTime;

    private int duration;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private boolean adult;

}
