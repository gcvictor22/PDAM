package com.salesianostriana.dam.pdam.api.party.dto;

import com.salesianostriana.dam.pdam.api.party.model.Party;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class GetPartyDto {

    private Long id;
    private String name;
    private String description;
    private String discotheque;
    private int remainingTickets;
    private LocalDateTime startAt;
    private LocalDateTime endsAt;
    private boolean adult;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private String payment_id;

    public static GetPartyDto of(Party party){
        return GetPartyDto.builder()
                .id(party.getId())
                .name(party.getName())
                .description(party.getDescription())
                .discotheque(party.getDiscotheque().getName())
                .remainingTickets(party.getDiscotheque().getCapacity()-party.getClients().size())
                .startAt(party.getStartAt())
                .endsAt(party.getEndsAt())
                .adult(party.isAdult())
                .price(party.getPrice())
                .drinkIncluded(party.isDrinkIncluded())
                .numberOfDrinks(party.getNumberOfDrinks())
                .build();
    }
    public static GetPartyDto ofStripe(Party party, String payment_id){
        return GetPartyDto.builder()
                .id(party.getId())
                .name(party.getName())
                .description(party.getDescription())
                .discotheque(party.getDiscotheque().getName())
                .remainingTickets(party.getDiscotheque().getCapacity()-party.getClients().size())
                .startAt(party.getStartAt())
                .endsAt(party.getEndsAt())
                .adult(party.isAdult())
                .price(party.getPrice())
                .drinkIncluded(party.isDrinkIncluded())
                .numberOfDrinks(party.getNumberOfDrinks())
                .payment_id(payment_id)
                .build();
    }

}
