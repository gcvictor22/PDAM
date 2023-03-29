package com.salesianostriana.dam.pdam.api.user.controller;

import com.salesianostriana.dam.pdam.api.exception.file.NotAllowedCountFilesException;
import com.salesianostriana.dam.pdam.api.files.dto.FileResponse;
import com.salesianostriana.dam.pdam.api.files.service.FIleService;
import com.salesianostriana.dam.pdam.api.files.service.StorageService;
import com.salesianostriana.dam.pdam.api.files.utils.MediaTypeUrlResource;
import com.salesianostriana.dam.pdam.api.security.jwt.JwtProvider;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.dto.*;
import com.salesianostriana.dam.pdam.api.verificationtoken.dto.GetVerificationTokenDto;
import com.salesianostriana.dam.pdam.api.verificationtoken.service.VerificationTokenService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
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
import org.springframework.web.multipart.MultipartFile;

import javax.mail.MessagingException;
import javax.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final FIleService fIleService;
    private final StorageService storageService;
    private final VerificationTokenService verificationTokenService;
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

    @GetMapping("/profileImg")
    public ResponseEntity<Resource> getProfileImg(@AuthenticationPrincipal User user){

        if (user.getImgPath() != null){
            MediaTypeUrlResource resource =
                    (MediaTypeUrlResource) storageService.loadAsResource(user.getImgPath());

            return ResponseEntity.status(HttpStatus.OK)
                    .header("Content-Type", resource.getType())
                    .body(resource);
        }else{
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }
    }

    @GetMapping("userImg/{userName}")
    public ResponseEntity<Resource> getUserImg(@PathVariable String userName){
        User user = userService.findByUserName(userName);

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(user.getImgPath());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
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
        verificationTokenService.generateVerificationToken(user);
        userService.emailSender(newUserDto.getEmail(), user);

        return ResponseEntity.status(HttpStatus.CREATED).body(GetUserDto.of(user));
    }

    @PostMapping("/follow/{username}")
    public ResponseEntity<GetUserDto> follow(@AuthenticationPrincipal User loggedUser, @PathVariable String username){

        User user = userService.follow(loggedUser, username);

        return ResponseEntity.status(HttpStatus.CREATED).body(GetUserDto.ofs(user, loggedUser));
    }

    @PostMapping("/upload")
    public ResponseEntity<?> upload(@RequestPart("file") MultipartFile file, @AuthenticationPrincipal User user) {

        if (file.isEmpty())
            throw new NotAllowedCountFilesException();

        FileResponse response = fIleService.uploadFile(file);
        userService.setImg(response.getName(), user);

        return ResponseEntity.created(URI.create(response.getUri())).body(response);
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

    @PutMapping("/verification")
    public GetUserDto accountverification(@RequestBody GetVerificationTokenDto verificationTokenDto){
        User user = verificationTokenService.activateAccount(verificationTokenDto);
        return GetUserDto.of(user);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> delete(@AuthenticationPrincipal User loggedUser){

        userService.deleteById(loggedUser.getId());

        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
