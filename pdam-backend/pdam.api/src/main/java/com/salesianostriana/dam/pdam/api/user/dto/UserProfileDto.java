package com.salesianostriana.dam.pdam.api.user.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventAllDto;
import com.salesianostriana.dam.pdam.api.event.model.Event;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
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
import java.util.UUID;
import java.util.stream.Collectors;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserProfileDto {

    private UUID id;
    private String userName;
    private String fullName;
    private String imgPath;
    private String email;
    private String phoneNumber;
    private int follows;
    private int followers;
    private GetPageDto<GetPostDto> publishedPosts;
    private boolean followedByUser;
    private boolean verified;
    private String city;
    private GetEventAllDto authEvent;
    private boolean authorized;
    private boolean isLoggedUser;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy")
    private LocalDateTime createdAt;

    public static UserProfileDto of(User user, User loggedUser, GetPageDto<GetPostDto> publishedPosts){
        return UserProfileDto.builder()
                .id(user.getId())
                .userName(user.getUsername())
                .fullName(user.getFullName())
                .imgPath(user.getImgPath())
                .createdAt(user.getCreatedAt())
                .email(user.getEmail())
                .phoneNumber(user.getPhoneNumber())
                .follows(user.getFollows().size())
                .followers(user.getFollowers().size())
                .publishedPosts(publishedPosts)
                .verified(user.isVerified())
                .followedByUser(user.getFollowers().stream().filter(u -> Objects.equals(u.getId(), loggedUser.getId())).toList().size() > 0)
                .city(user.getCity().getName())
                .authEvent(user.getAuthEvent() == null ? null : GetEventAllDto.of(user.getAuthEvent()))
                .authorized(user.isAuthorized())
                .isLoggedUser(user.getId() == loggedUser.getId())
                .build();
    }

}
