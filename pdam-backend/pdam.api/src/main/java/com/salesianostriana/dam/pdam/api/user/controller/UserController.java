package com.salesianostriana.dam.pdam.api.user.controller;

import com.salesianostriana.dam.pdam.api.exception.file.NotAllowedCountFilesException;
import com.salesianostriana.dam.pdam.api.exception.token.RefreshTokenException;
import com.salesianostriana.dam.pdam.api.files.dto.FileResponse;
import com.salesianostriana.dam.pdam.api.files.service.FIleService;
import com.salesianostriana.dam.pdam.api.files.service.StorageService;
import com.salesianostriana.dam.pdam.api.files.utils.MediaTypeUrlResource;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.security.jwt.access.JwtProvider;
import com.salesianostriana.dam.pdam.api.security.jwt.refresh.RefreshToken;
import com.salesianostriana.dam.pdam.api.security.jwt.refresh.RefreshTokenRequest;
import com.salesianostriana.dam.pdam.api.security.jwt.refresh.RefreshTokenService;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.service.UserService;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.util.Extractor;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.dto.*;
import com.salesianostriana.dam.pdam.api.verificationtoken.dto.GetVerificationTokenDto;
import com.salesianostriana.dam.pdam.api.verificationtoken.service.VerificationTokenService;
import com.stripe.model.Customer;
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
import javax.validation.constraints.NotEmpty;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
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
    private final RefreshTokenService refreshTokenService;


    @GetMapping("/")
    public GetPageDto<GetUserDto> findAll(
            @RequestParam(value = "s", defaultValue = "") String search,
            @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User user){

        List<SearchCriteria> params = Extractor.extractSearchCriteriaList(search);
        return userService.findAll(params, pageable, user);
    }

    @GetMapping("/profile/")
    public UserProfileDto viewProfile(@AuthenticationPrincipal User loggedUser, @PageableDefault(size = 20, page = 0) Pageable pageable){
        User user = userService.getProfile(loggedUser.getId());
        GetPageDto<GetPostDto> publishedPosts = userService.getPublishedPosts(user, pageable);
        return UserProfileDto.of(userService.getProfileByUserName(user.getUsername()), user, publishedPosts);
    }

    @GetMapping("/{id}")
    public UserProfileDto viewUser(@PathVariable UUID id, @AuthenticationPrincipal User loggedUser, @PageableDefault(size = 20, page = 0) Pageable pageable){
        User user = userService.getProfile(loggedUser.getId());
        GetPageDto<GetPostDto> publishedPosts = userService.getPublishedPosts(user, pageable);
        return UserProfileDto.of(userService.getProfile(id), user, publishedPosts);
    }

    @GetMapping("/userName/{userName}")
    public UserProfileDto viewUserProfile(@PathVariable String userName, @AuthenticationPrincipal User loggedUser, @PageableDefault(size = 20, page = 0) Pageable pageable){
        User user = userService.getProfile(loggedUser.getId());
        User userToGet = userService.getProfileByUserName(userName);
        GetPageDto<GetPostDto> publishedPosts = userService.getPublishedPostsFromUser(userToGet, user, pageable);
        return UserProfileDto.of(userToGet, user, publishedPosts);
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

    @GetMapping("/userImg/{userName}")
    public ResponseEntity<Resource> getUserImg(@PathVariable String userName){
        User user = userService.findByUserName(userName);

        MediaTypeUrlResource resource =
                (MediaTypeUrlResource) storageService.loadAsResource(user.getImgPath());

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @GetMapping("/follows/{id}")
    public GetPageDto<UserWhoLikeDto> getFollows (@PathVariable UUID id, @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User loggedUser){
        User user = userService.getProfile(id);
        return userService.getFollows(user, pageable, loggedUser);
    }

    @GetMapping("/followers/{id}")
    public GetPageDto<UserWhoLikeDto> getFollowers(@PathVariable UUID id, @PageableDefault(size = 20, page = 0) Pageable pageable, @AuthenticationPrincipal User loggedUser){
        User user = userService.getProfile(id);
        return userService.getFollowers(user, pageable, loggedUser);
    }

    @GetMapping("/likedPosts/{id}")
    public GetPageDto<GetPostDto> getLikedPosts(@PathVariable UUID id, @PageableDefault(size = 20, page = 0) Pageable pageable){
        User user = userService.getProfile(id);
        return userService.getLikedPosts(user, pageable);
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

        refreshTokenService.deleteByUser(user);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(JwtUserResponse.of(user, token, refreshToken.getToken()));
    }

    @PostMapping("/register")
    public ResponseEntity<?> createUser(@Valid @RequestBody NewUserDto newUserDto) throws MessagingException, IOException {
        Customer customer = userService.stripeCustomer(newUserDto);
        User user = userService.createUser(newUserDto, customer.getId());
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

    @PostMapping("/refreshtoken")
    public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest refreshTokenRequest) {
        String refreshToken = refreshTokenRequest.getRefreshToken();

        return refreshTokenService.findByToken(refreshToken)
                .map(refreshTokenService::verify)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = jwtProvider.generateToken(user);
                    refreshTokenService.deleteByUser(user);
                    RefreshToken refreshToken2 = refreshTokenService.createRefreshToken(user);
                    return ResponseEntity.status(HttpStatus.CREATED)
                            .body(JwtUserResponse.of(user, token, refreshToken2.getToken()));
                })
                .orElseThrow(() -> new RefreshTokenException("Refresh token not found"));
    }

    @PostMapping("/forgotPassword/")
    public ResponseEntity<GetUserDto> forgotPassword(@Valid @RequestBody ForgotPasswordDto forgotPasswordDto) throws MessagingException {
        User user = userService.getProfileByUserName(forgotPasswordDto.getUserName());
        verificationTokenService.generateVerificationToken(user);
        userService.forgotPassword(user);
        return ResponseEntity.status(HttpStatus.CREATED).body(GetUserDto.of(user));
    }

    @PutMapping("/edit/password")
    public GetUserDto changePassword(@Valid @RequestBody EditPasswordDto editPasswordDto,
                                                       @AuthenticationPrincipal User loggedUser) {

        User updateUser = userService.changePassword(loggedUser, editPasswordDto);

        return GetUserDto.of(updateUser);
    }

    @PutMapping("/edit/fullName")
    public GetUserDto changeFullName(@Valid
            @RequestBody EditFullNameDto editFullNameDto, @AuthenticationPrincipal User loggedUser){
        User user = userService.editFullName(editFullNameDto.getFullName(), loggedUser);
        return GetUserDto.of(user);
    }

    @PutMapping("/edit/userName")
    public GetUserDto changeUserName(@Valid
            @RequestBody EditUserNameDto editUserNameDto, @AuthenticationPrincipal User loggedUser){
        User user = userService.editUserName(editUserNameDto.getUserName(), loggedUser);
        return GetUserDto.of(user);
    }

    @PutMapping("/edit/email")
    public GetUserDto changeEmail(@Valid
            @RequestBody EditEmailDto editEmailDto, @AuthenticationPrincipal User loggedUser) throws MessagingException, IOException {
        User user = userService.editEmail(editEmailDto.getEmail(), loggedUser);
        verificationTokenService.generateVerificationToken(user);
        userService.emailSender(user.getEmail(), user);
        return GetUserDto.of(user);
    }

    @PutMapping("/edit/phoneNumber")
    public GetUserDto changePhoneNumber(@Valid
            @RequestBody EditPhoneNumberDto editPhoneNumberDto, @AuthenticationPrincipal User loggedUser){
        User user = userService.editPhoneNumber(editPhoneNumberDto.getPhoneNumber(), loggedUser);
        return GetUserDto.of(user);
    }

    @PutMapping("/verification")
    public GetUserDto accountverification(@Valid @RequestBody GetVerificationTokenDto verificationTokenDto){
        User user = verificationTokenService.activateAccount(verificationTokenDto);
        return GetUserDto.of(user);
    }

    @PutMapping("/forgotPassword/{userName}")
    public GetUserDto changeForgotPassword(@PathVariable String userName, @Valid @RequestBody ForgotPasswordChangeDto forgotPasswordChangeDto){
        User user = userService.changeForgotPassword(forgotPasswordChangeDto, userName);
        return GetUserDto.of(user);
    }

    @DeleteMapping("/delete")
    public ResponseEntity<?> delete(@AuthenticationPrincipal User loggedUser){
        userService.deleteById(loggedUser.getId());
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

}
