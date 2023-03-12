package com.salesianostriana.dam.pdam.api.user.service;

import com.salesianostriana.dam.pdam.api.exception.notfound.UserNotFoundException;
import com.salesianostriana.dam.pdam.api.exception.password.EqualOldNewPasswordException;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.user.dto.EditProfileDto;
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
import org.springframework.mail.SimpleMailMessage;
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
                .build();

        return userRepository.save(user);
    }

    public User createUser(NewUserDto createUserRequest) {
        return save(createUserRequest, EnumSet.of(UserRole.USER));
    }

    public void emailSender(String toEmail, String userName) throws MessagingException {
        MimeMessage message = javaMailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);

        helper.setFrom("dyscotkeo@gmail.com");
        helper.setTo(toEmail);
        message.setSubject("¡Bienvenido a DiscoTkeo "+userName+"!");
        message.setContent("<!DOCTYPE html>\n" +
                "<html lang=\"es\">\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" +
                "    <title>Document</title>\n" +
                "</head>\n" +
                "<body>\n" +
                "    <img src=\"https://document-export.canva.com/ltxVQ/DAFZbRltxVQ/6/thumbnail/0001.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAQYCGKMUHWDTJW6UD%2F20230311%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230311T231101Z&X-Amz-Expires=50165&X-Amz-Signature=aea9dacb8c71a84307d2e9fc344113fcfa210d0d31d0602e657057d76d70f12c&X-Amz-SignedHeaders=host&response-expires=Sun%2C%2012%20Mar%202023%2013%3A07%3A06%20GMT\">\n" +
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

    public User changeProfile(EditProfileDto editProfileDto, User loggedUser) {
        return userRepository.findById(loggedUser.getId())
                .map(old -> {
                    old.setFullName(editProfileDto.getFullName());
                    old.setUserName(editProfileDto.getUsername());
                    old.setEmail(editProfileDto.getEmail());
                    old.setPhoneNumber(editProfileDto.getPhoneNumber());
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

    public Optional<User> findById(UUID userId) {
        return userRepository.findById(userId);
    }

    public void setImg(String imgPath, User user) {
        user.setImgPath(imgPath);
        userRepository.save(user);
    }
}
