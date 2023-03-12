package com.salesianostriana.dam.pdam.api.user.controller;

import com.salesianostriana.dam.pdam.api.security.jwt.JwtProvider;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.mail.MessagingException;
import javax.validation.Valid;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final AuthenticationManager authManager;

    private final JwtProvider jwtProvider;


    @GetMapping("/")
    public GetPageDto<GetUserDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User user){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return userService.findAll(params, pageable, user);
    }

    @GetMapping("/profile")
    public UserProfileDto viewProfile(@AuthenticationPrincipal User loggedUser){
        return UserProfileDto.of(userService.getProfileByUserName(loggedUser.getUsername()), loggedUser);
    }

    @GetMapping("/{id}")
    public UserProfileDto viewUser(@PathVariable UUID id, @AuthenticationPrincipal User user){
        return UserProfileDto.of(userService.getProfile(id), user);
    }

    @GetMapping("userName/{userName}")
    public UserProfileDto viewUserProfile(@PathVariable String userName, @AuthenticationPrincipal User user){
        return UserProfileDto.of(userService.getProfileByUserName(userName), user);
    }

    @PostMapping("/login")
    public ResponseEntity<JwtUserResponse> login(@RequestBody LoginDto loginRequest) {

        Authentication authentication =
                authManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                loginRequest.getUsername(),
                                loginRequest.getPassword()
                        )
                );

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);
        User user = (User) authentication.getPrincipal();

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.of(user, token));
    }

    @PostMapping("/register")
    public ResponseEntity<GetUserDto> createUser(@Valid @RequestBody NewUserDto newUserDto) throws MessagingException {
        User user = userService.createUser(newUserDto);
        userService.emailSender(newUserDto.getEmail(), newUserDto.getUsername());

        return ResponseEntity.status(HttpStatus.CREATED).body(GetUserDto.of(user));
    }

    @PostMapping("/follow/{username}")
    public ResponseEntity<GetUserDto> follow(@AuthenticationPrincipal User loggedUser, @PathVariable String username){

        User user = userService.follow(loggedUser, username);

        return ResponseEntity.status(HttpStatus.CREATED).body(GetUserDto.ofs(user, loggedUser));
    }

    @PutMapping("/edit/password")
    public GetUserDto changePassword(@Valid @RequestBody EditPasswordDto editPasswordDto,
                                                       @AuthenticationPrincipal User loggedUser) {

        User updateUser = userService.changePassword(loggedUser, editPasswordDto);

        return GetUserDto.of(updateUser);
    }

    @PutMapping("/edit/profile")
    public GetUserDto changeProfile(@Valid @RequestBody EditProfileDto editProfile,
                                    @AuthenticationPrincipal User loggedUser){

        User updatedUser =  userService.changeProfile(editProfile, loggedUser);

        return GetUserDto.of(updatedUser);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> delete(@AuthenticationPrincipal User loggedUser){

        userService.deleteById(loggedUser.getId());

        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
