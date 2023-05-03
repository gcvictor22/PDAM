package com.salesianostriana.dam.pdam.api.event.dto;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetEventDto{

    private Long id;
    private String name;
    private String location;
    private String city;
    private int popularity;
    private String imgPath;
    private String type;

    public static GetEventDto of(Event event){
        return GetEventDto.builder()
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
