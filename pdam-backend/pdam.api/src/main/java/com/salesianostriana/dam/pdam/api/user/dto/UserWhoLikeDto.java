package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserWhoLikeDto {

    private String userName;
    private String imgPath;
    private boolean verified;
    private boolean followedByUser;
    private boolean loggedUser;

    public static UserWhoLikeDto of(User user, User loggedUser){
        return UserWhoLikeDto.builder()
                .userName(user.getUsername())
                .imgPath(user.getImgPath())
                .verified(user.isVerified())
                .followedByUser(user.getFollowers().stream().filter(u -> Objects.equals(u.getId(), loggedUser.getId())).toList().size() > 0)
                .loggedUser(Objects.equals(user.getId(), loggedUser.getId()))
                .build();
    }

}
