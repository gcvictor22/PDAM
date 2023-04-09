package com.salesianostriana.dam.pdam.api.party.dto;

import com.salesianostriana.dam.pdam.api.party.model.Party;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class GetPartyListDto {

    private Long id;
    private String name;
    private int remainingTickets;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private double price;
    private String imgPath;

    public static GetPartyListDto of(Party party){
        return GetPartyListDto.builder()
                .id(party.getId())
                .name(party.getName())
                .remainingTickets(party.getDiscotheque().getCapacity()-party.getClients().size())
                .drinkIncluded(party.isDrinkIncluded())
                .numberOfDrinks(party.getNumberOfDrinks())
                .price(party.getPrice())
                .imgPath(party.getImgPath())
                .build();
    }

}
