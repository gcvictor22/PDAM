package com.salesianostriana.dam.pdam.api.payment.service;

import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.payment.dto.GetPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.dto.NewPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.model.PaymentMethod;
import com.salesianostriana.dam.pdam.api.payment.repository.PaymentMethodRepository;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PaymentMethodService {

    private final PaymentMethodRepository paymentMethodRepository;
    private final UserRepository userRepository;


    public PaymentMethod create(NewPaymentMethodDto newPaymentMethodDto, User loggedUser) {

        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));

        PaymentMethod paymentMethod = paymentMethodRepository.save(
                PaymentMethod.builder()
                        .number(newPaymentMethodDto.getNumber())
                        .holder(newPaymentMethodDto.getHolder())
                        .expiredDate(newPaymentMethodDto.getExpiredDate())
                        .cvv(newPaymentMethodDto.getCvv())
                        .activeMethod(user.getPaymentMethods().isEmpty())
                        .type(getCardType(newPaymentMethodDto.getNumber()))
                        .build()
        );

        user.addPaymentMethod(paymentMethod);
        userRepository.save(user);
        return paymentMethod;

    }

    public static String getCardType(String cardNumber) {
        // Eliminar espacios en blanco y guiones
        String sanitizedCardNumber = cardNumber.replaceAll("\\s", "").replaceAll("-", "");

        if (sanitizedCardNumber.matches("^(4\\d{12}(?:\\d{3})?)$")) {
            return "Visa";
        } else if (sanitizedCardNumber.matches("^(5[1-5]\\d{14})$")) {
            return "Mastercard";
        }
        else if (sanitizedCardNumber.matches("^(34|37\\d{13})$")) {
             return "American Express";
         }
         else if (sanitizedCardNumber.matches("^(6011\\d{12})$")) {
             return "Discover";
         }

        return "Desconocido";
    }

    public PaymentMethod getActiveMethod(User loggedUser) {
        return loggedUser.getPaymentMethods().stream().filter(PaymentMethod::isActiveMethod).toList().get(0);
    }

    public PaymentMethod activateMethod(User loggedUser, Long id) {
        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));
        PaymentMethod paymentMethod = paymentMethodRepository.findById(id).orElseThrow(EntityNotFoundException::new);

        if (user.getPaymentMethods().stream().filter(p -> Objects.equals(p.getId(), paymentMethod.getId())).toList().size() == 0){
            user.getPaymentMethods().forEach(p -> {
                p.setActiveMethod(false);
                paymentMethodRepository.save(p);
            });
            paymentMethod.setActiveMethod(true);
            paymentMethodRepository.save(paymentMethod);
            return paymentMethod;
        }else {
            throw new EntityNotFoundException();
        }
    }

    public List<GetPaymentMethodDto> findAll(User loggedUser) {
        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));
        if (user.getPaymentMethods().isEmpty()) {
            throw new EntityNotFoundException();
        }else {
            return user.getPaymentMethods().stream().map(u -> {
                u.setNumber("**** **** **** "+u.getNumber().substring(12, 16));
                return GetPaymentMethodDto.of(u);
            }).toList();
        }
    }
}
