package com.salesianostriana.dam.pdam.api.party.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
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

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime startAt;

    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss")
    private LocalDateTime endsAt;

    private boolean adult;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private String imgPath;
    private String paymentId;

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
                .imgPath(party.getImgPath())
                .build();
    }
    public static GetPartyDto ofStripe(Party party, String paymentId){
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
                .imgPath(party.getImgPath())
                .paymentId(paymentId)
                .build();
    }

}
