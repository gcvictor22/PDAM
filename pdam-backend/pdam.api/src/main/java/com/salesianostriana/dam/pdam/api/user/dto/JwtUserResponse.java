package com.salesianostriana.dam.pdam.api.user.dto;

import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class JwtUserResponse extends GetUserDto{

    private String token;
    private String refreshToken;

    public JwtUserResponse(GetUserDto user) {
        id = user.getId();
        userName = user.getUserName();
        fullName = user.getFullName();
        imgPath = user.getImgPath();
        createdAt = user.getCreatedAt();
        followers = user.getFollowers();
        countOfPosts = user.getCountOfPosts();
        verified = user.isVerified();
    }

    public static JwtUserResponse of (User user, String token, String refreshToken) {
        JwtUserResponse result = new JwtUserResponse(GetUserDto.of(user));
        result.setToken(token);
        result.setRefreshToken(refreshToken);

        return result;
    }

}
