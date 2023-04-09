package com.salesianostriana.dam.pdam.api.discotheque.dto;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.user.dto.UserWhoLikeDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetDiscothequeDto {

    private Long id;
    private String name;
    private String location;
    private String city;
    private List<UserWhoLikeDto> authUsers;
    private int popularity;

    public static GetDiscothequeDto of(Discotheque discotheque){
        return GetDiscothequeDto.builder()
                .id(discotheque.getId())
                .name(discotheque.getName())
                .location(discotheque.getLocation())
                .city(discotheque.getCity().getName())
                .authUsers(discotheque.getAuthUsers().stream().map(UserWhoLikeDto::of).collect(Collectors.toList()))
                .popularity(discotheque.getPopularity())
                .build();
    }

}
