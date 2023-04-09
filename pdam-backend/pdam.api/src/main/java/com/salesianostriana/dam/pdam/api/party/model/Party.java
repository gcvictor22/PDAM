package com.salesianostriana.dam.pdam.api.party.model;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Party {

    @Id
    @GeneratedValue
    private Long id;

    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "discotheque", foreignKey = @ForeignKey(name = "FK_PARTY_DISCOTHEQUE"))
    private Discotheque discotheque;

    private LocalDateTime startAt;
    private LocalDateTime endsAt;

    @ManyToMany(mappedBy = "parties", fetch = FetchType.LAZY)
    @Builder.Default
    private List<User> clients = new ArrayList<>();

    private boolean adult;
    private double price;
    private boolean drinkIncluded;
    private int numberOfDrinks;
    private String imgPath;

}
