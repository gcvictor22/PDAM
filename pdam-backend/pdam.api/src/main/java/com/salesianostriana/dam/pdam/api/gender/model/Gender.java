package com.salesianostriana.dam.pdam.api.gender.model;

import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Gender {

    @Id
    @GeneratedValue
    private Long id;

    private String name;

    @OneToMany(mappedBy = "gender", fetch = FetchType.LAZY)
    @Builder.Default
    private List<User> users = new ArrayList<>();

}
