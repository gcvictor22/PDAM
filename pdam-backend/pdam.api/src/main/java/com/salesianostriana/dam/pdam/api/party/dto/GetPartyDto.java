package com.salesianostriana.dam.pdam.api.party.dto;

import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.user.dto.UserWhoLikeDto;
import com.salesianostriana.dam.pdam.api.validation.annotation.user.FieldsValueMatch;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.util.List;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class GetPartyDto extends GetNewPartyDto{

    private List<UserWhoLikeDto> clients;

    public static GetPartyDto of(Party party){
        return GetPartyDto.builder()
                .name(party.getName())
                .discotheque(party.getDiscotheque().getName())
                .startAt(party.getStartAt())
                .endsAt(party.getEndsAt())
                .adult(party.isAdult())
                .price(party.getPrice())
                .drinkIncluded(party.isDrinkIncluded())
                .numberOfDrinks(party.getNumberOfDrinks())
                .clients(party.getClients().stream().map(UserWhoLikeDto::of).collect(Collectors.toList()))
                .build();
    }

}
