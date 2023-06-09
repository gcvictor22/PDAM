package com.salesianostriana.dam.pdam.api.user.service;

import com.salesianostriana.dam.pdam.api.city.repository.CityRepository;
import com.salesianostriana.dam.pdam.api.event.dto.GetEventDto;
import com.salesianostriana.dam.pdam.api.exception.badrequest.VerifiactionTokenBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.badrequest.VerificationTokenExpirationTimeBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.notfound.CityNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.GenderNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.password.EqualOldNewPasswordException;
import com.salesianostriana.dam.pdam.api.gender.repository.GenderRepository;
import com.salesianostriana.dam.pdam.api.party.dto.GetPartyDto;
import com.salesianostriana.dam.pdam.api.post.dto.GetPostDto;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.security.jwt.refresh.RefreshToken;
import com.salesianostriana.dam.pdam.api.security.jwt.refresh.RefreshTokenRepository;
import com.salesianostriana.dam.pdam.api.user.dto.*;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.model.UserRole;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyUserListException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.specifications.user.USBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.verificationtoken.dto.GetVerificationTokenDto;
import com.stripe.Stripe;
import com.stripe.exception.StripeException;
import com.stripe.model.Customer;
import com.stripe.param.CustomerCreateParams;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.transaction.Transactional;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final CityRepository cityRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final GenderRepository genderRepository;
    private final PasswordEncoder passwordEncoder;
    private final PostRepository postRepository;
    private final JavaMailSender javaMailSender;

    @Value("${secret.stripe.key}")
    private String stripeSecret;

    public GetPageDto<GetUserDto> findAll(List<SearchCriteria> params, Pageable pageable, User user){
        if (userRepository.findAll().isEmpty())
            throw new EmptyUserListException();

        USBuilder usBuilder = new USBuilder(params);

        Specification<User> spec = usBuilder.build();
        Page<GetUserDto> pageGetClientDto = userRepository.findAll(spec, pageable).map(u -> GetUserDto.ofs(u, user));

        return new GetPageDto<>(pageGetClientDto);
    }

    public User save(NewUserDto createUser, EnumSet<UserRole> roles, String customer_id) {

        User user =  User.builder()
                .userName(createUser.getUsername())
                .password(passwordEncoder.encode(createUser.getPassword()))
                .email(createUser.getEmail())
                .phoneNumber(createUser.getPhoneNumber())
                .imgPath("default.jpeg")
                .fullName(createUser.getFullName())
                .roles(roles)
                .city(cityRepository.findById(createUser.getCityId()).orElseThrow(() -> new CityNotFoundException(createUser.getCityId())))
                .gender(genderRepository.findById(createUser.getGenderId()).orElseThrow(() -> new GenderNotFoundException(createUser.getGenderId())))
                .createdAt(createUser.getCreatedAt())
                .enabled(false)
                .stripeCustomerId(customer_id)
                .build();

        return userRepository.save(user);
    }

    public User createUser(NewUserDto createUserRequest, String customer_id) {
        return save(createUserRequest, EnumSet.of(UserRole.USER), customer_id);
    }

    public Customer stripeCustomer(NewUserDto createUser) {
        try {
            Stripe.apiKey = stripeSecret;

            CustomerCreateParams.Builder customer = new CustomerCreateParams.Builder()
                    .setEmail(createUser.getEmail());

            return Customer.create(customer.build());

        }catch (StripeException e){
            System.out.println(e.toString());
            throw new RuntimeException();
        }
    }

    public void emailSender(String toEmail, User user) throws MessagingException, IOException {
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setFrom("no.reply.dyscotkeo@gmail.com");
        helper.setTo(toEmail);
        message.setSubject("¡Bienvenido a DiscoTkeo "+user.getUsername()+"!");

        Resource resource = new ClassPathResource("templates/welcome.html");
        File file = resource.getFile();
        String content = new String(Files.readAllBytes(file.toPath()));
        content = content.replace("${verificationNumber}", String.valueOf(user.getVerificationToken().getVerificationNumber()));

        message.setContent(content, "text/html");

        javaMailSender.send(message);
    }

    public User changePassword(User loggedUser, EditPasswordDto changePasswordDto) {

        if (! passwordEncoder.matches(changePasswordDto.getOldPassword(), loggedUser.getPassword())){
            System.out.println(loggedUser.getPassword()+" "+passwordEncoder.encode(changePasswordDto.getOldPassword()));
            throw new EqualOldNewPasswordException();
        }

        return userRepository.findById(loggedUser.getId())
                .map(old -> {
                    old.setLastPasswordChangeAt(LocalDateTime.now());
                    old.setPassword(passwordEncoder.encode(changePasswordDto.getNewPassword()));
                    return userRepository.save(old);
                })
                .orElseThrow(() -> new UserNotFoundException(loggedUser.getId()));

    }

    public User follow(User loggedUser, String userToFollow) {
        User user = userRepository.userWithPostsByUserName(userToFollow).orElseThrow(() -> new UserNotFoundException(userToFollow));
        User userWhoFollows = userRepository.userWithPostsByUserName(loggedUser.getUsername()).orElseThrow(() -> new UserNotFoundException(loggedUser.getUsername()));

        user.giveAFollow(userWhoFollows, userRepository.checkFollower(loggedUser.getId(), user.getId()));

        userRepository.save(loggedUser);
        userRepository.save(user);

        return user;
    }

    public User findByUserName(String userName){
        return userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
    }

    @Transactional
    public void deleteById(UUID id) {
        User user = userRepository.findById(id).orElseThrow(() -> new UserNotFoundException(id));
        refreshTokenRepository.deleteByUser(user);
        userRepository.deleteById(id);
    }

    @Transactional
    public User getProfile(UUID id) {
        User user = userRepository.userWithPostsById(id).orElseThrow(() -> new UserNotFoundException(id));
        postRepository.postComments();
        return user;
    }

    @Transactional
    public User getProfileByUserName(String userName){
        User user = userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
        postRepository.postComments();
        return user;
    }

    public boolean existsByUserName(String s) {
        return userRepository.existsByUserName(s);
    }

    public boolean existsByEmail(String e) {
        return userRepository.existsByEmail(e);
    }

    public boolean existsByPhoneNumber(String p) {
        return userRepository.existsByPhoneNumber(p);
    }

    public User findById(UUID userId) {
        return userRepository.findById(userId).orElseThrow(() -> new UserNotFoundException(userId));
    }

    public void setImg(String imgPath, User user) {
        user.setImgPath(imgPath);
        userRepository.save(user);
    }

    public User editUserName(String userName, User loggedUser) {
        loggedUser.setUserName(userName);
        return userRepository.save(loggedUser);
    }

    public User editFullName(String fullName, User loggedUser) {
        loggedUser.setFullName(fullName);
        return userRepository.save(loggedUser);
    }

    public User editEmail(String email, User loggedUser) {
        loggedUser.setEmail(email);
        loggedUser.setEnabled(false);
        return userRepository.save(loggedUser);
    }

    public User editPhoneNumber(String phoneNumber, User loggedUser) {
        loggedUser.setPhoneNumber(phoneNumber);
        return userRepository.save(loggedUser);
    }

    public void forgotPassword(User user) throws MessagingException {

        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setFrom("dyscotkeo@gmail.com");
        helper.setTo(user.getEmail());
        message.setSubject("Verifica que eres tu "+user.getUsername());
        message.setContent("<!DOCTYPE html>\n" +
                "<html lang=\"es\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "    <title>Código de verificación</title>\n" +
                "</head>\n" +
                "<body style=\"max-width: 700px;\">\n" +
                "    <div style=\"width: 100%; text-align: center;\">\n" +
                "        <h3>¡Ya casi hemos terminado!</h3>\n" +
                "        <p>Utiliza el siguiente código para obtener tu acceso al cambio de contraseña</p>\n" +
                "    </div>\n" +
                "    <div style=\"width: 100%; background: #a300ff; text-align: center; color: white; padding: 10px 0;\">\n" +
                "        <h3 style=\"font-family: Verdana, Geneva, Tahoma, sans-serif;\">"+user.getVerificationToken().getVerificationNumber()+"</h3>\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>", "text/html");

        javaMailSender.send(message);
    }

    public User forgotPasswordValidator(GetVerificationTokenDto getVerificationTokenDto) {
        User user = userRepository.userWithPostsByUserName(getVerificationTokenDto.getUserName()).orElseThrow(() -> new UserNotFoundException(getVerificationTokenDto.getUserName()));

        if (Objects.equals(getVerificationTokenDto.getVerificationNumber(), user.getVerificationToken().getVerificationNumber())
                && user.getVerificationToken().getExpirationTime().compareTo(LocalDateTime.now()) > 0){
            user.setEnabled(true);
            userRepository.save(user);
        }else {
            if (!Objects.equals(getVerificationTokenDto.getVerificationNumber(), user.getVerificationToken().getVerificationNumber()))
                throw new VerifiactionTokenBadRequestException(getVerificationTokenDto.getVerificationNumber());
            throw new VerificationTokenExpirationTimeBadRequestException();
        }

        return user;
    }

    public User changeForgotPassword(ForgotPasswordChangeDto forgotPasswordChangeDto, String userName) {
        User user = userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));

        user.setPassword(passwordEncoder.encode(forgotPasswordChangeDto.getNewPassword()));
        return userRepository.save(user);
    }

    public GetPageDto<UserWhoLikeDto> getFollows(User user, Pageable pageable, User loggedUser) {

        Page<UserWhoLikeDto> getFollowsDto = userRepository.findFollows(pageable, user.getId()).map(u -> UserWhoLikeDto.of(u, loggedUser));

        return new GetPageDto<>(getFollowsDto);

    }

    public GetPageDto<UserWhoLikeDto> getFollowers(User user, Pageable pageable, User loggedUser) {

        Page<UserWhoLikeDto> getFollowersDto = userRepository.findFollowers(pageable, user.getId()).map(u -> UserWhoLikeDto.of(u, loggedUser));

        return new GetPageDto<>(getFollowersDto);

    }

    public GetPageDto<GetPostDto> getLikedPosts(User user, Pageable pageable, User loggedUser) {
        Page<GetPostDto> getLikedPostsDto = userRepository.getLikedPosts(pageable, user.getId()).map(p -> GetPostDto.of(p, loggedUser));

        return new GetPageDto<>(getLikedPostsDto);
    }

    public GetPageDto<GetPostDto> getPublishedPosts(User loggedUser, Pageable pageable) {

        Page<GetPostDto> getPublishedPosts = userRepository.getPublishedPosts(pageable, loggedUser.getId()).map(p -> GetPostDto.of(p, loggedUser));

        return new GetPageDto<>(getPublishedPosts);
    }

    public GetPageDto<GetPostDto> getPublishedPostsFromUser(User userToGet, User loggedUser, Pageable pageable) {

        Page<GetPostDto> getPublishedPosts = userRepository.getPublishedPosts(pageable, userToGet.getId()).map(p -> GetPostDto.of(p, loggedUser));

        return new GetPageDto<>(getPublishedPosts);
    }

    public GetPageDto<GetEventDto> getBuyedEvents(User user, Pageable pageable) {
        Page<GetEventDto> getBuyedEvents = userRepository.getBuyedEvents(pageable, user.getId()).map(GetEventDto::of);

        return new GetPageDto<>(getBuyedEvents);
    }

    public GetPageDto<GetPartyDto> getBuyedParties(User user, Pageable pageable) {
        Page<GetPartyDto> getBuyedParties = userRepository.getBuyedParties(pageable, user.getId()).map(GetPartyDto::of);

        return new GetPageDto<>(getBuyedParties);
    }

    public boolean isAdmin(User user) {
        return user.getRoles().contains(UserRole.ADMIN);
    }

    public GetUserDto convertToAdmin(UUID userId) {
        User user = userRepository.userWithPostsById(userId).orElseThrow(() -> new UserNotFoundException(userId));

        if (user.getRoles().contains(UserRole.ADMIN)){
            user.getRoles().remove(UserRole.ADMIN);
        }else{
            user.getRoles().add(UserRole.ADMIN);
        }

        return GetUserDto.of(userRepository.save(user));
    }

    public GetUserDto banUser(UUID userId){
        User user = userRepository.userWithPostsById(userId).orElseThrow(() -> new UserNotFoundException(userId));

        user.setEnabled(!user.isEnabled());

        return GetUserDto.of(userRepository.save(user));
    }
}
