package com.salesianostriana.dam.pdam.api.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserProfileDto {

    private String userName;
    private String fullName;
    private String imgPath;
    private String email;
    private String phoneNumber;
    private List<GetUserDto> follows;
    private List<GetUserDto> followers;
    private List<GetPostDto> publishedPosts;
    private List<GetPostDto> likedPosts;
    private boolean followedByUser;
    private boolean verified;
    private String city;
    private GetEventDto authEvent;
    private boolean authorized;
    private List<Event> events;
    private List<GetPartyDto> parties;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    private LocalDateTime createdAt;

    public static UserProfileDto of(User user, User loggedUser){
        return UserProfileDto.builder()
                .userName(user.getUsername())
                .fullName(user.getFullName())
                .imgPath(user.getImgPath())
                .createdAt(user.getCreatedAt())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .follows(user.getFollows().stream().map(GetUserDto::of).collect(Collectors.toList()))
                .followers(user.getFollowers().stream().map(GetUserDto::of).collect(Collectors.toList()))
                .publishedPosts(user.getPublishedPosts().stream().map(p -> GetPostDto.of(p, user)).toList())
                .likedPosts(user.getLikedPosts().stream().map(p -> GetPostDto.of(p, user)).toList())
                .verified(user.isVerified())
                .followedByUser(user.getFollowers().stream().filter(u -> Objects.equals(u.getId(), loggedUser.getId())).toList().size() > 0)
                .city(user.getCity().getName())
                .authEvent(GetEventDto.of(user.getAuthEvent()))
                .authorized(user.isAuthorized())
                .events(user.getEvents())
                .parties(user.getParties().stream().map(GetPartyDto::of).collect(Collectors.toList()))
                .build();
    }

}
