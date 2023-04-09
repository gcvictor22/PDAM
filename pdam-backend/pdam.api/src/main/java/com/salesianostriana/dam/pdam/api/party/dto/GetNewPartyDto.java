package com.salesianostriana.dam.pdam.api.party.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.user.dto.UserWhoLikeDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class GetNewPartyDto {

    private Long id;
    private String name;
    private String discotheque;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startAt;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime endsAt;
    private boolean adult;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;

    public static GetNewPartyDto of(Party party){
        return GetNewPartyDto.builder()
                .id(party.getId())
                .name(party.getName())
                .discotheque(party.getDiscotheque().getName())
                .startAt(party.getStartAt())
                .endsAt(party.getEndsAt())
                .adult(party.isAdult())
                .price(party.getPrice())
                .drinkIncluded(party.isDrinkIncluded())
                .numberOfDrinks(party.getNumberOfDrinks())
                .build();
    }

}
