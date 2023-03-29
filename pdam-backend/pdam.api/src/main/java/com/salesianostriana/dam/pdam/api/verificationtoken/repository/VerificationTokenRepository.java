package com.salesianostriana.dam.pdam.api.verificationtoken.repository;

import com.salesianostriana.dam.pdam.api.verificationtoken.model.VerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VerificationTokenRepository extends JpaRepository<VerificationToken, Long> {

}
