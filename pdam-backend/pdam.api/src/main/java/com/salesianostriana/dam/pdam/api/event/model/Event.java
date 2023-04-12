package com.salesianostriana.dam.pdam.api.event.model;

import com.salesianostriana.dam.pdam.api.city.model.City;
import com.salesianostriana.dam.pdam.api.user.model.EnumRoleConverter;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;
import lombok.experimental.SuperBuilder;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Event {

    @Id
    @GeneratedValue
    private Long id;

    private String name;
    private String location;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "city", foreignKey = @ForeignKey(name = "FK_EVENT_CITY"))
    private City city;

    private int capacity;

    @ManyToMany(mappedBy = "events", fetch = FetchType.LAZY)
    @Builder.Default
    private List<User> clients = new ArrayList<>();

    private int popularity;

    @OneToMany(mappedBy = "authEvent", fetch = FetchType.LAZY)
    @Builder.Default
    private List<User> authUsers = new ArrayList<>();

    private String imgPath;

    @Convert(converter = EnumTypeConverter.class)
    private EnumSet<EventType> type;

}
