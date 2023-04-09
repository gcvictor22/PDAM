package com.salesianostriana.dam.pdam.api.festival.service;

import com.salesianostriana.dam.pdam.api.festival.repository.FestivalRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class FestivalService {

    private final FestivalRepository festivalRepository;

}
