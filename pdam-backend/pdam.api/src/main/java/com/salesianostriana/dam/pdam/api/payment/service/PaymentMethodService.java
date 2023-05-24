package com.salesianostriana.dam.pdam.api.payment.service;

import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.payment.dto.GetPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.dto.NewPaymentMethodDto;
import com.salesianostriana.dam.pdam.api.payment.model.CardType;
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

        String sanitizedCardNumber = newPaymentMethodDto.getNumber().replaceAll("\\s", "").replaceAll("-", "");

        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));

        PaymentMethod paymentMethod = paymentMethodRepository.save(
                PaymentMethod.builder()
                        .number(sanitizedCardNumber)
                        .holder(newPaymentMethodDto.getHolder())
                        .expiredDate(newPaymentMethodDto.getExpiredDate())
                        .cvv(newPaymentMethodDto.getCvv())
                        .activeMethod(user.getPaymentMethods().isEmpty())
                        .type(identifyCardType(newPaymentMethodDto.getNumber()))
                        .build()
        );

        user.addPaymentMethod(paymentMethod);
        userRepository.save(user);
        return paymentMethod;

    }

    public static CardType identifyCardType(String cardNumber) {
        if (cardNumber.startsWith("4")) {
            return CardType.VISA;
        } else if (cardNumber.startsWith("5")) {
            char secondDigit = cardNumber.charAt(1);
            if (secondDigit >= '1' && secondDigit <= '5') {
                return CardType.MASTERCARD;
            }
        } else if (cardNumber.startsWith("34") || cardNumber.startsWith("37")) {
            return CardType.AMERICAN_EXPRESS;
        } else if (cardNumber.startsWith("6011") || cardNumber.startsWith("65")) {
            return CardType.DISCOVER;
        }
        return CardType.OTHER;
    }

    public PaymentMethod getActiveMethod(User loggedUser) {
        return loggedUser.getPaymentMethods().stream().filter(PaymentMethod::isActiveMethod).toList().get(0);
    }

    public PaymentMethod activateMethod(User loggedUser, Long id) {
        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));
        PaymentMethod paymentMethod = paymentMethodRepository.findById(id).orElseThrow(EntityNotFoundException::new);

        if (user.getPaymentMethods().stream().filter(p -> Objects.equals(p.getId(), paymentMethod.getId())).toList().size() > 0){
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
        return user.getPaymentMethods().stream().map(u -> {
            if (u.getType().equals(CardType.AMERICAN_EXPRESS) || u.getNumber().length() == 15){
                u.setNumber("**** ****** "+u.getNumber().substring(10, 15));
            }else {
                u.setNumber("**** **** **** "+u.getNumber().substring(12, 16));
            }
            return GetPaymentMethodDto.of(u);
        }).toList();
    }
}
