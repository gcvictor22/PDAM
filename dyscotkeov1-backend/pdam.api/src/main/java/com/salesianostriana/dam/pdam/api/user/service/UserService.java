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
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final PostRepository postRepository;

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
        User user = userRepository.findDistinctByUserName(userToFollow).orElseThrow(() -> new UserNotFoundException(userToFollow));

        user.giveAFollow(loggedUser, userRepository.checkFollower(loggedUser.getId(), user.getId()));

        userRepository.save(loggedUser);
        userRepository.save(user);

        return user;
    }

    public User findByUserName(String userName){
        return userRepository.findDistinctByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
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
        User user = userRepository.findDistinctByUserName(userName).orElseThrow(() -> new UserNotFoundException(userName));
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
