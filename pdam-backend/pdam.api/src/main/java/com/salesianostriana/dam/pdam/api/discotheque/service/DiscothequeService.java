package com.salesianostriana.dam.pdam.api.discotheque.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.discotheque.dto.GetDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.dto.NewDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.discotheque.repository.DiscothequeRepository;
import com.salesianostriana.dam.pdam.api.event.model.EventType;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyDiscothequeListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.CityNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.search.specifications.dicotheque.DSBuilder;
import com.salesianostriana.dam.pdam.api.search.specifications.post.PSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.EnumSet;
import java.util.List;

@Service
@AllArgsConstructor
public class DiscothequeService {

    private final DiscothequeRepository discothequeRepository;
    private final UserRepository userRepository;
    private final CityRepository cityRepository;

    public GetPageDto<GetDiscothequeDto> findAll(List<SearchCriteria> params, Pageable pageable) {

        if (discothequeRepository.findAll().isEmpty())
            throw new EmptyDiscothequeListException();

        DSBuilder psBuilder = new DSBuilder(params);

        Specification<Discotheque> spec = psBuilder.build();
        Page<GetDiscothequeDto> pageGetDiscothequeDto = discothequeRepository.findAll(spec, pageable).map(GetDiscothequeDto::of);

        return new GetPageDto<>(pageGetDiscothequeDto);

    }

    public GetDiscothequeDto save(NewDiscothequeDto newDiscothequeDto){
        Discotheque discotheque = Discotheque.builder()
                .name(newDiscothequeDto.getName())
                .city(cityRepository.findById(newDiscothequeDto.getCityId()).orElseThrow(() -> new CityNotFoundException(newDiscothequeDto.getCityId())))
                .location(newDiscothequeDto.getLocation())
                .capacity(newDiscothequeDto.getCapacity())
                .type(EnumSet.of(EventType.DISCOTHEQUE))
                .imgPath("default-events.png")
                .build();

        return GetDiscothequeDto.of(discothequeRepository.save(discotheque));
    }
}
