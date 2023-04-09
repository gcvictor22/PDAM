package com.salesianostriana.dam.pdam.api.discotheque.model;

import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.SQLUpdate;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Discotheque extends Event {

    @OneToMany(mappedBy = "discotheque", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Party> parties = new ArrayList<>();

}
