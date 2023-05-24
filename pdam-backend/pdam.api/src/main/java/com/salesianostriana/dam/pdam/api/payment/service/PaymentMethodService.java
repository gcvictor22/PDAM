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
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.param.PaymentMethodCreateParams;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PaymentMethodService {

    private final PaymentMethodRepository paymentMethodRepository;
    private final UserRepository userRepository;

    @Value("${secret.stripe.key}")
    private String stripeSecret;


    public PaymentMethod create(NewPaymentMethodDto newPaymentMethodDto, User loggedUser, String stripe_id) {

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
                        .stripe_id(stripe_id)
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

    public com.stripe.model.PaymentMethod createPMStripe(NewPaymentMethodDto paymentMethod, User loggedUser) {
        try {
            Stripe.apiKey = stripeSecret;

/*
            Map<String, Object> card = new HashMap<>();
            card.put("number", paymentMethod.getNumber());
            card.put("exp_month", Integer.parseInt(paymentMethod.getExpiredDate().split("/")[0]));
            card.put("exp_year", Integer.parseInt(paymentMethod.getExpiredDate().split("/")[1]));
            card.put("cvc", paymentMethod.getCvv());
            card.put("customer", loggedUser.getStripeCustomer_id());
            Map<String, Object> params = new HashMap<>();
            params.put("type", "card");
            params.put("card", card);

            return com.stripe.model.PaymentMethod.create(params);
 */
            PaymentMethodCreateParams.Builder builder = new PaymentMethodCreateParams.Builder()
                    .setType(PaymentMethodCreateParams.Type.CARD)
                    .setCard(PaymentMethodCreateParams.CardDetails.builder()
                            .setNumber(paymentMethod.getNumber())
                            .setExpMonth(Long.parseLong(paymentMethod.getExpiredDate().split("/")[0]))
                            .setExpYear(Long.parseLong(paymentMethod.getExpiredDate().split("/")[1]))
                            .setCvc(paymentMethod.getCvv())
                            .build());

            return com.stripe.model.PaymentMethod.create(builder.build());

        }catch (StripeException e) {
            System.out.println(e.toString());
            throw new RuntimeException();
        }
    }
}
