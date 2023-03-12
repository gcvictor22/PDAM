package com.salesianostriana.dam.pdam.api.post.model;

import com.salesianostriana.dam.pdam.api.comment.model.Comment;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class)
public class Post implements Serializable{

    @Id
    @GeneratedValue
    private Long id;

    private String affair;
    private String content;

    @Convert(converter = ImgPathConverter.class)
    @Builder.Default
    private List<String> imgPaths = new ArrayList<>();

    @ManyToOne
    @JoinColumn(name = "userWhoPost", foreignKey = @ForeignKey(name = "FK_USER_COMMENT"))
    private User userWhoPost;

    @ManyToMany(mappedBy = "likedPosts", fetch = FetchType.LAZY)
    @Builder.Default
    private List<User> usersWhoLiked = new ArrayList<>();

    @OneToMany(mappedBy = "commentedPost", orphanRemoval = true, cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @Builder.Default
    private List<Comment> comments = new ArrayList<>();

    private LocalDateTime postDate;

    /******************************/
    /*           HELPERS           /
    /******************************/

    public void addUser(User user){
        this.setUserWhoPost(user);
        List<Post> aux = user.getPublishedPosts();
        aux.add(this);
    }

    @PreRemove
    public void preRemove(){
        if (this.userWhoPost != null)
            this.userWhoPost.getPublishedPosts().remove(this);
        this.getUsersWhoLiked().forEach(u -> {
            u.getLikedPosts().remove(this);
        });
        this.comments.clear();
        this.usersWhoLiked.clear();
    }

    public void like(User user, boolean b){
        List<Post> aux1 = user.getLikedPosts();
        List<User> aux2 = this.getUsersWhoLiked();
        if (b){
            aux1.remove(user.getLikedPosts().indexOf(this)+1);
            aux2.remove(this.getUsersWhoLiked().indexOf(user)+1);
        }else {
            aux1.add(this);
            aux2.add(user);
        }
        this.setUsersWhoLiked(aux2);
        user.setLikedPosts(aux1);
    }

}
