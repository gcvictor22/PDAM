package com.salesianostriana.dam.pdam.api.payment.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.YearMonth;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
public class PaymentMethod {

    @Id
    @GeneratedValue
    private Long id;

    private String number;
    private String holder;

    private String expiredDate;

    private String cvv;
    private boolean activeMethod;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "userHolder", foreignKey = @ForeignKey(name = "FK_USER_PAYMENT_METHOD"))
    private User userHolder;

    private String type;

}
