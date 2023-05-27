package com.salesianostriana.dam.pdam.api.payment.repository;

import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.user.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Arrays;
import java.util.List;

@Repository
public interface PaymentMethodRepository extends JpaRepository<PaymentMethod, Long> {

    @Query("""
            SELECT p
            FROM User u JOIN u.paymentMethods p
            """)
    List<PaymentMethod> findAllUserPaymentMethod(User loggedUser);
}
