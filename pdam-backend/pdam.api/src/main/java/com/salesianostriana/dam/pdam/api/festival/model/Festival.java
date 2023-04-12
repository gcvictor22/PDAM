package com.salesianostriana.dam.pdam.api.festival.model;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import lombok.*;
import lombok.experimental.SuperBuilder;

import javax.persistence.Entity;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Festival extends Event {

    private String description;
    private LocalDateTime date;
    private int duration;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private boolean adult;

}