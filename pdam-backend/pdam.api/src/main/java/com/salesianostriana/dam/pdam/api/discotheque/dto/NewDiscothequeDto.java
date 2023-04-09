package com.salesianostriana.dam.pdam.api.discotheque.dto;

import com.salesianostriana.dam.pdam.api.city.model.City;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NewDiscothequeDto {

    private String name;
    private Long cityId;
    private String location;
    private int capacity;

}
