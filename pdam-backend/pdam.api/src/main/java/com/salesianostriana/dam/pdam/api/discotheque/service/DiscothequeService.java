package com.salesianostriana.dam.pdam.api.discotheque.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.discotheque.dto.GetDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.dto.NewAuthUsersDto;
import com.salesianostriana.dam.pdam.api.discotheque.dto.NewDiscothequeDto;
import com.salesianostriana.dam.pdam.api.discotheque.model.Discotheque;
import com.salesianostriana.dam.pdam.api.discotheque.repository.DiscothequeRepository;
import com.salesianostriana.dam.pdam.api.event.model.EventType;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyDiscothequeListException;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyPostListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.DiscothequeNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.search.specifications.post.PSBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.model.UserRole;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import javax.persistence.EntityNotFoundException;
import java.util.ArrayList;
import java.util.EnumSet;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class DiscothequeService {

    private final DiscothequeRepository discothequeRepository;
    private final UserRepository userRepository;
    private final CityRepository cityRepository;

    public GetPageDto<GetDiscothequeDto> findAll(List<SearchCriteria> params, Pageable pageable, User loggedUser) {

        User user = userRepository.userWithPostsById(loggedUser.getId()).orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));

        if (discothequeRepository.findAll().isEmpty())
            throw new EmptyDiscothequeListException();

        PSBuilder psBuilder = new PSBuilder(params);

        Specification<Post> spec = psBuilder.build();
        Page<GetDiscothequeDto> pageGetDiscothequeDto = discothequeRepository.findAll(spec, pageable).map(GetDiscothequeDto::of);

        return new GetPageDto<>(pageGetDiscothequeDto);

    }

    public GetDiscothequeDto save(NewDiscothequeDto newDiscothequeDto){
        Discotheque discotheque = Discotheque.builder()
                .name(newDiscothequeDto.getName())
                .city(cityRepository.findById(newDiscothequeDto.getCityId()).orElseThrow(EntityNotFoundException::new))
                .location(newDiscothequeDto.getLocation())
                .capacity(newDiscothequeDto.getCapacity())
                .type(EnumSet.of(EventType.DISCOTHEQUE))
                .build();

        return GetDiscothequeDto.of(discothequeRepository.save(discotheque));
    }

    public List<User> authorizeUsers(List<UUID> uuids, Discotheque discotheque) {
        return uuids.stream()
                .map(uuid -> {
                    User user = userRepository.findById(uuid).orElseThrow(() -> new UserNotFoundException(uuid));
                    user.setAuthorized(true);
                    user.setAuthEvent(discotheque);
                    return userRepository.save(user);
                })
                .collect(Collectors.toList());
    }

    public GetDiscothequeDto addAuthUsers(NewAuthUsersDto newAuthUsersDto) {
        Discotheque discotheque = discothequeRepository.findById(newAuthUsersDto.getDiscothequeId()).orElseThrow(() -> new DiscothequeNotFoundException(newAuthUsersDto.getDiscothequeId()));

        List<User> users = authorizeUsers(newAuthUsersDto.getAuthUsers(), discotheque);
        users.forEach(u -> {
            u.getRoles().add(UserRole.AUTH);
        });
        discotheque.getAuthUsers().addAll(users);

        return GetDiscothequeDto.of(discothequeRepository.save(discotheque));
    }
}
