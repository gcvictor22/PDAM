package com.salesianostriana.dam.pdam.api.verificationtoken.service;

import com.salesianostriana.dam.pdam.api.exception.badrequest.VerifiactionTokenBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.badrequest.VerificationTokenExpirationTimeBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import com.salesianostriana.dam.pdam.api.verificationtoken.dto.GetVerificationTokenDto;
import com.salesianostriana.dam.pdam.api.verificationtoken.model.VerificationToken;
import com.salesianostriana.dam.pdam.api.verificationtoken.repository.VerificationTokenRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Random;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class VerificationTokenService {

    private final VerificationTokenRepository verifiacationTokenRepository;
    private final UserRepository userRepository;

    public User activateAccount(GetVerificationTokenDto verificationTokenDto){
        User user = userRepository.userWithPostsByUserName(verificationTokenDto.getUserName()).orElseThrow(() -> new UserNotFoundException(verificationTokenDto.getUserName()));

        if (Objects.equals(verificationTokenDto.getVerificationNumber(), user.getVerificationToken().getVerificationNumber())
                && user.getVerificationToken().getExpirationTime().compareTo(LocalDateTime.now()) > 0){
            user.setEnabled(true);
            userRepository.save(user);
        }else {
            if (!Objects.equals(verificationTokenDto.getVerificationNumber(), user.getVerificationToken().getVerificationNumber()))
                throw new VerifiactionTokenBadRequestException(verificationTokenDto.getVerificationNumber());
            throw new VerificationTokenExpirationTimeBadRequestException();
        }

        return user;
    }

    public void generateVerificationToken(User user){
        Random numAleatorio = new Random();

        VerificationToken vt = VerificationToken.builder()
                .verificationNumber(numAleatorio.nextInt(999999-100000+1) + 100000)
                .expirationTime(LocalDateTime.now().plusMinutes(3))
                .build();

        vt.addToUser(user);
        userRepository.save(user);

    }

}
