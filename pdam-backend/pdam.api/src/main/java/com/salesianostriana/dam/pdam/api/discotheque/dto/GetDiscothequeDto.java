package com.salesianostriana.dam.pdam.api.discotheque.dto;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetDiscothequeDto {

    private Long id;
    private String name;
    private String location;
    private String city;
    private String imgPath;
    private int popularity;

    public static GetDiscothequeDto of(Event discotheque){
        return GetDiscothequeDto.builder()
                .id(discotheque.getId())
                .name(discotheque.getName())
                .location(discotheque.getLocation())
                .city(discotheque.getCity().getName())
                .imgPath(discotheque.getImgPath())
                .popularity(discotheque.getPopularity())
                .build();
    }

}
