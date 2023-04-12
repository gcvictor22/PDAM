package com.salesianostriana.dam.pdam.api.error;

import com.salesianostriana.dam.pdam.api.error.model.impl.ApiErrorImpl;
import com.salesianostriana.dam.pdam.api.error.model.impl.ApiValidationSubError;
import com.salesianostriana.dam.pdam.api.exception.accesdenied.CommentDeniedAccessException;
import com.salesianostriana.dam.pdam.api.exception.accesdenied.EventDeniedAccessException;
import com.salesianostriana.dam.pdam.api.exception.accesdenied.PostAccessDeniedExeption;
import com.salesianostriana.dam.pdam.api.exception.badrequest.*;
import com.salesianostriana.dam.pdam.api.exception.file.NotAllowedCountFilesException;
import com.salesianostriana.dam.pdam.api.exception.password.EqualOldNewPasswordException;
import com.salesianostriana.dam.pdam.api.exception.token.JwtTokenException;
import org.hibernate.validator.internal.engine.path.PathImpl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import javax.persistence.EntityNotFoundException;
import javax.validation.ConstraintViolationException;
import java.util.List;
import java.util.stream.Collectors;




@RestControllerAdvice
public class GlobalRestControllerAdvice extends ResponseEntityExceptionHandler {

    @Override
    protected ResponseEntity<Object> handleExceptionInternal(Exception ex, Object body, HttpHeaders headers, HttpStatus status, WebRequest request) {
        return buildApiError(ex.getMessage(), request, status);
    }


    @ExceptionHandler({EntityNotFoundException.class})
    public ResponseEntity<?> handleNotFoundException(EntityNotFoundException exception, WebRequest request) {
        return buildApiError(exception.getMessage(), request, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler({
            PostBadRequestToDeleteException.class,
            VerifiactionTokenBadRequestException.class,
            CommentBadRequestToDeleteException.class,
            EqualOldNewPasswordException.class,
            NotAllowedCountFilesException.class,
            FileInPostBadRequestException.class,
            VerificationTokenExpirationTimeBadRequestException.class})
    public ResponseEntity<?> handleBadRequestException(EntityNotFoundException exception, WebRequest request) {
        return buildApiError(exception.getMessage(), request, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler({ AuthenticationException.class, UsernameNotFoundException.class })
    public ResponseEntity<?> handleAuthenticationException(AuthenticationException ex, WebRequest request) {
        return buildApiError(ex.getMessage(), request, HttpStatus.UNAUTHORIZED);

    }

    @ExceptionHandler({
            AccessDeniedException.class,
            JwtTokenException.class,
            PostAccessDeniedExeption.class,
            CommentDeniedAccessException.class,
            EventDeniedAccessException.class})
    public ResponseEntity<?> handleAccessDeniedException(AccessDeniedException ex, WebRequest request) {
        return buildApiError(ex.getMessage(), request, HttpStatus.FORBIDDEN);

    }



    @ExceptionHandler({ConstraintViolationException.class})
    public ResponseEntity<?> handleConstraintViolationException(ConstraintViolationException exception, WebRequest request) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(
                        ApiErrorImpl.builder()
                                .status(HttpStatus.BAD_REQUEST)
                                .message("Constraint Validation error. Please check the sublist.")
                                .path(((ServletWebRequest) request).getRequest().getRequestURI())
                                .subErrors(exception.getConstraintViolations().stream()
                                        .map(v -> {
                                            return ApiValidationSubError.builder()
                                                    .message(v.getMessage())
                                                    .rejectedValue(v.getInvalidValue())
                                                    .object(v.getRootBean().getClass().getSimpleName())
                                                    .field( ((PathImpl)v.getPropertyPath()).getLeafNode().asString())
                                                    .build();
                                        })
                                        .collect(Collectors.toList())
                                )
                                .build()
                );
    }



    @Override
    protected ResponseEntity<Object> handleMethodArgumentNotValid(MethodArgumentNotValidException ex, HttpHeaders headers, HttpStatus status, WebRequest request) {
        return buildApiErrorWithSubErrors("Validation error. Please check the sublist.", request, status, ex.getAllErrors());
    }

    private final ResponseEntity<Object> buildApiError(String message, WebRequest request, HttpStatus status) {
        return ResponseEntity
                .status(status)
                .body(
                        ApiErrorImpl.builder()
                                .status(status)
                                .message(message)
                                .path(((ServletWebRequest) request).getRequest().getRequestURI())
                                .build()
                );
    }

    private final ResponseEntity<Object> buildApiErrorWithSubErrors(String message, WebRequest request, HttpStatus status, List<ObjectError> subErrors) {
        return ResponseEntity
                .status(status)
                .body(
                        ApiErrorImpl.builder()
                                .status(status)
                                .message(message)
                                .path(((ServletWebRequest) request).getRequest().getRequestURI())
                                .subErrors(subErrors.stream()
                                            .map(ApiValidationSubError::fromObjectError)
                                            .collect(Collectors.toList())
                                )
                                .build()
                );

    }

}
