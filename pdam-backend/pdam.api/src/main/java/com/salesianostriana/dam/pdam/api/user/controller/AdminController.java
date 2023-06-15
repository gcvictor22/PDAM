package com.salesianostriana.dam.pdam.api.user.controller;

import com.salesianostriana.dam.pdam.api.user.dto.GetUserDto;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.UUID;

@RequestMapping("/admin")
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final UserService userService;

    @PutMapping("/convert/admin/{id}")
    public GetUserDto convertToAdmin(@PathVariable UUID id){
        return userService.convertToAdmin(id);
    }

    @PutMapping("/convert/ban/{id}")
    public GetUserDto banUser(@PathVariable UUID id){
        return userService.banUser(id);
    }

}
