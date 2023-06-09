package com.salesianostriana.dam.pdam.api.files.service;

import com.salesianostriana.dam.pdam.api.exception.accesdenied.PostAccessDeniedExeption;
import com.salesianostriana.dam.pdam.api.exception.badrequest.FileInPostBadRequestException;
import com.salesianostriana.dam.pdam.api.exception.file.NotAllowedCountFilesException;
import com.salesianostriana.dam.pdam.api.exception.notfound.PostNotFoundException;
import com.salesianostriana.dam.pdam.api.files.dto.FileResponse;
import com.salesianostriana.dam.pdam.api.post.model.Post;
import com.salesianostriana.dam.pdam.api.post.repository.PostRepository;
import com.salesianostriana.dam.pdam.api.user.model.User;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.Arrays;
import java.util.List;
import java.util.Objects;

@Service
@AllArgsConstructor
public class FIleService {

    private final StorageService storageService;
    private final PostRepository postRepository;

    public FileResponse uploadFile(MultipartFile file) {
        String name = storageService.store(file);

        String uri = ServletUriComponentsBuilder.fromCurrentContextPath()
                .path("/file/")
                .path(name)
                .toUriString();

        return FileResponse.builder()
                .name(name)
                .size(file.getSize())
                .type(file.getContentType())
                .uri(uri)
                .build();
    }

    public List<FileResponse> addToPost(Long id, MultipartFile[] files) {
        Post post = postRepository.findById(id).orElseThrow(() -> new PostNotFoundException(id));
        List<FileResponse> result = Arrays.stream(files)
                .map(this::uploadFile)
                .toList();

        if (post.getImgPaths().size() == 1 && Objects.equals(post.getImgPaths().get(0), "VACIO")){
            if (result.size() > 4){
                throw new NotAllowedCountFilesException();
            }
            post.getImgPaths().remove("VACIO");
        } else if (post.getImgPaths().size() >= 1 && !Objects.equals(post.getImgPaths().get(0), "VACIO")) {
            if (post.getImgPaths().size() + result.size() > 4){
                throw new NotAllowedCountFilesException();
            }
        }

        result.forEach(r -> {
            post.getImgPaths().add(r.getName());
        });
        postRepository.save(post);

        return result;
    }

    public void deleteImgFromPost(Long idPost, String imgName) {
        Post post = postRepository.findById(idPost).orElseThrow(() -> new PostNotFoundException(idPost));

        if (!post.getImgPaths().contains(imgName))
            throw new FileInPostBadRequestException(imgName);

        post.getImgPaths().remove(imgName);

        if (post.getImgPaths().isEmpty())
            post.getImgPaths().add("VACIO");

        postRepository.save(post);
    }
}
