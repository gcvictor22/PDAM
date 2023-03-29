package com.salesianostriana.dam.pdam.api.verificationtoken.model;

import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class VerificationToken {

    @Id
    @GeneratedValue
    private Long id;

    private int verificationNumber;
    private LocalDateTime expirationTime;

    @OneToOne
    @JoinColumn(name = "userToVerify")
    private User userToVerify;

    /******************************/
    /*           HELPERS           /
    /******************************/

    public void addToUser(User user){
        this.userToVerify = user;
        user.setVerificationToken(this);
    }

    @PreRemove
    public void deleteFromUser(){
        this.userToVerify = null;
    }

}
