package com.salesianostriana.dam.pdam.api.city.dto;

import com.salesianostriana.dam.pdam.api.city.model.City;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetCityDto {

    private Long id;
    private String name;

    public static GetCityDto of(City c){
        return GetCityDto.builder()
                .id(c.getId())
                .name(c.getName())
                .build();
    }

}
