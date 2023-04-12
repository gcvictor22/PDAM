package com.salesianostriana.dam.pdam.api.party.service;

import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.discotheque.repository.DiscothequeRepository;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.repository.EventRepository;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyDiscothequeListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.DiscothequeNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.PartyNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.party.dto.NewPartyDto;
import com.salesianostriana.dam.pdam.api.party.model.Party;
import com.salesianostriana.dam.pdam.api.party.repository.PartyRepository;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.search.specifications.post.PSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class PartyService {

    private final PartyRepository partyRepository;
    private final DiscothequeRepository discothequeRepository;
    private final UserRepository userRepository;
    private final EventRepository eventRepository;


    public GetPageDto<GetPartyDto> findAll(List<SearchCriteria> params, Pageable pageable) {

        if (discothequeRepository.findAll().isEmpty())
            throw new EmptyDiscothequeListException();

        PSBuilder psBuilder = new PSBuilder(params);

        Specification<Post> spec = psBuilder.build();
        Page<GetPartyDto> getListDto = partyRepository.findAll(spec, pageable).map(GetPartyDto::of);

        return new GetPageDto<>(getListDto);

    }

    public GetPartyDto save(NewPartyDto newPartyDto, User loggedUser){

        Discotheque discotheque = discothequeRepository.findById(loggedUser.getAuthEvent().getId()).orElseThrow(() -> new DiscothequeNotFoundException(loggedUser.getAuthEvent().getId()));

        Party party = Party.builder()
                .name(newPartyDto.getName())
                .description(newPartyDto.getDescription())
                .discotheque(discotheque)
                .startAt(newPartyDto.getStartAt())
                .endsAt(newPartyDto.getEndsAt())
                .adult(newPartyDto.isAdult())
                .price(newPartyDto.getPrice())
                .drinkIncluded(newPartyDto.isDrinkIncluded())
                .numberOfDrinks(newPartyDto.getNumberOfDrinks())
                .build();

        partyRepository.save(party);
        discotheque.getParties().add(party);
        discothequeRepository.save(discotheque);

        return GetPartyDto.of(party);
    }

    public Party buy(Long id, User loggedUser) {
        Party party = partyRepository.findById(id).orElseThrow(() -> new PartyNotFoundException(id));
        Event event = party.getDiscotheque();

        party.getClients().add(loggedUser);
        loggedUser.getParties().add(party);
        event.getClients().add(loggedUser);
        loggedUser.getEvents().add(event);

        eventRepository.save(event);
        userRepository.save(loggedUser);

        return  partyRepository.save(party);
    }

    public void setUpdatedPopularity(Event event){
        event.setPopularity(eventRepository.popularityCityEvent(event.getCity().getId(), event.getId()));
        eventRepository.save(event);
    }
}
