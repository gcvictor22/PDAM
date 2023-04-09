package com.salesianostriana.dam.pdam.api.discotheque.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.UUID;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NewAuthUsersDto {

    private List<UUID> authUsers;
    private Long discothequeId;

}
