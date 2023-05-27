package com.salesianostriana.dam.pdam.api.event.dto;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class GetEventAllDto extends GetEventDto{

    private String type;

    public static GetEventAllDto of(Event event){
        return GetEventAllDto.builder()
                .id(event.getId())
                .name(event.getName())
                .location(event.getLocation())
                .city(event.getCity().getName())
                .popularity(event.getPopularity())
                .imgPath(event.getImgPath())
                .type(event.getType().toString())
                .build();
    }
}
