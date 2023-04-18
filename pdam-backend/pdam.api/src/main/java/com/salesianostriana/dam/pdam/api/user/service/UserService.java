package com.salesianostriana.dam.pdam.api.user.service;

import com.salesianostriana.dam.pdam.api.exception.badrequest.VerifiactionTokenBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.badrequest.VerificationTokenExpirationTimeBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.password.EqualOldNewPasswordException;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.user.dto.ForgotPasswordChangeDto;
import com.salesianostriana.dam.pdam.api.user.model.User;
import com.salesianostriana.dam.pdam.api.user.model.UserRole;
import com.salesianostriana.dam.pdam.api.user.repository.UserRepository;
import com.salesianostriana.dam.pdam.api.exception.empty.EmptyUserListException;
import com.salesianostriana.dam.pdam.api.page.dto.GetPageDto;
import com.salesianostriana.dam.pdam.api.search.specifications.user.USBuilder;
import com.salesianostriana.dam.pdam.api.search.util.SearchCriteria;
import com.salesianostriana.dam.pdam.api.user.dto.EditPasswordDto;
import com.salesianostriana.dam.pdam.api.user.dto.GetUserDto;
import com.salesianostriana.dam.pdam.api.user.dto.NewUserDto;
import lombok.RequiredArgsConstructor;
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
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final PostRepository postRepository;
    private final JavaMailSender javaMailSender;

    public GetPageDto<GetUserDto> findAll(List<SearchCriteria> params, Pageable pageable, User user){
        if (userRepository.findAll().isEmpty())
            throw new EmptyUserListException();

        USBuilder usBuilder = new USBuilder(params);

        Specification<User> spec = usBuilder.build();
        Page<GetUserDto> pageGetClientDto = userRepository.findAll(spec, pageable).map(u -> GetUserDto.ofs(u, user));

        return new GetPageDto<>(pageGetClientDto);
    }

    public User save(NewUserDto createUser, EnumSet<UserRole> roles) {
        User user =  User.builder()
                .userName(createUser.getUsername())
                .password(passwordEncoder.encode(createUser.getPassword()))
                .email(createUser.getEmail())
                .phoneNumber(createUser.getPhoneNumber())
                .imgPath("default.png")
                .fullName(createUser.getFullName())
                .roles(roles)
                .createdAt(createUser.getCreatedAt())
                .enabled(false)
                .build();

        return userRepository.save(user);
    }

    public User createUser(NewUserDto createUserRequest) {
        return save(createUserRequest, EnumSet.of(UserRole.USER));
    }

    public void emailSender(String toEmail, User user) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setFrom("dyscotkeo@gmail.com");
        helper.setTo(toEmail);
        message.setSubject("¡Bienvenido a DiscoTkeo "+user.getUsername()+"!");
        message.setContent("<!DOCTYPE html>\n" +
                "<html lang=\"es\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "    <title>Código de verificación</title>\n" +
                "</head>\n" +
                "<body style=\"max-width: 700px;\">\n" +
                "    <img src=\"https://i.pinimg.com/originals/ba/34/d4/ba34d4023f8263c2085e5d60706e7900.png\"\n" +
                "        style=\"display: block; margin: auto; max-width: 700px;\">\n" +
                "    <div style=\"width: 100%; text-align: center;\">\n" +
                "        <h3>¡Ya casi hemos terminado!</h3>\n" +
                "        <p>Utiliza el siguiente código para verificar tu cuenta</p>\n" +
                "    </div>\n" +
                "    <div style=\"width: 100%; background: #a300ff; text-align: center; color: white; padding: 10px 0;\">\n" +
                "        <h3 style=\"font-family: Verdana, Geneva, Tahoma, sans-serif;\">"+user.getVerificationToken().getVerificationNumber()+"</h3>\n" +
                "    </div>\n" +
                "</body>\n" +
                "</html>", "text/html");

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

        user.giveAFollow(loggedUser, userRepository.checkFollower(loggedUser.getId(), user.getId()));

        userRepository.save(loggedUser);
        userRepository.save(user);

        return user;
    }

    public User findByUserName(String userName){
        return userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
    }

    public void deleteById(UUID id) {
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

    public User forgotPasswordValidator(String userName, int verificationNumber) {
        User user = userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));

        if (Objects.equals(verificationNumber, user.getVerificationToken().getVerificationNumber())
                && user.getVerificationToken().getExpirationTime().compareTo(LocalDateTime.now()) > 0){
            user.setEnabled(true);
            userRepository.save(user);
        }else {
            if (!Objects.equals(verificationNumber, user.getVerificationToken().getVerificationNumber()))
                throw new VerifiactionTokenBadRequestException(verificationNumber);
            throw new VerificationTokenExpirationTimeBadRequestException();
        }

        return user;
    }

    public User changeForgotPassword(ForgotPasswordChangeDto forgotPasswordChangeDto, String userName) {
        User user = userRepository.userWithPostsByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));

        user.setPassword(passwordEncoder.encode(forgotPasswordChangeDto.getNewPassword()));
        return userRepository.save(user);
    }
}
