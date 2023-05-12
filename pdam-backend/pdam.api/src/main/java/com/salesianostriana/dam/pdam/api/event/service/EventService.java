package com.salesianostriana.dam.pdam.api.event.service;

import com.salesianostriana.dam.pdam.api.event.dto.GetEventAllDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.event.repository.EventRepository;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyEventListException;
import com.salesianostriana.dam.pdam.api.exception.notfound.DiscothequeNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.EventNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
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

import java.util.List;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class EventService {

    private final UserRepository userRepository;
    private final EventRepository eventRepository;

    public GetPageDto<GetEventAllDto> findAll(List<SearchCriteria> params, Pageable pageable) {
        if (eventRepository.findAll().isEmpty())
            throw new EmptyEventListException();

        PSBuilder psBuilder = new PSBuilder(params);

        Specification<Post> spec = psBuilder.build();
        Page<GetEventAllDto> pageGetEventDto = eventRepository.findAll(spec, pageable).map(GetEventAllDto::of);

        return new GetPageDto<>(pageGetEventDto);
    }

    public List<User> authorizeUsers(List<String> userNames, Event event) {
        return userNames.stream()
                .map(userName -> {
                    User user = userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
                    user.setAuthorized(true);
                    user.setAuthEvent(event);
                    return userRepository.save(user);
                })
                .collect(Collectors.toList());
    }

    public GetEventAllDto addAuthUsers(Long id, List<String> newAuthUsersDto) {
        Event event = eventRepository.findById(id).orElseThrow(() -> new DiscothequeNotFoundException(id));

        List<User> users = authorizeUsers(newAuthUsersDto, event);
        users.forEach(u -> {
            u.getRoles().add(UserRole.AUTH);
        });
        event.getAuthUsers().addAll(users);

        return GetEventAllDto.of(eventRepository.save(event));
    }

    public Event findById(Long id){
        return eventRepository.findById(id).orElseThrow(() -> new EventNotFoundException(id));
    }

    public boolean authUser(User user){
        return user.isAuthorized();
    }
}
