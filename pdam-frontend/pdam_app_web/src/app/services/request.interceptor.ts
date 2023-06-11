import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
  HttpResponse,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, switchMap } from 'rxjs/operators';
import { UserService } from './user.service';

@Injectable()
export class TokenInterceptor implements HttpInterceptor {

  constructor(private userService: UserService) {}

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return next.handle(request).pipe(
      catchError((error: HttpErrorResponse) => {
        if (error.status === 401 || error.status === 403) {
          // Error de autorización (401) y no es una solicitud de refresco de token
          return this.handleUnauthorizedError(request, next);
        } else {
          // Otro tipo de error, simplemente propagarlo
          return throwError(error);
        }
      })
    );
  }

  private handleUnauthorizedError(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    return this.userService.refreshToken(this.userService.getRefreshToken()!).pipe(
      switchMap((newToken) => {
        // Actualizar el token en el almacenamiento
        this.userService.saveToken(newToken.token);
        this.userService.saveRefreshToken(newToken.refreshToken);

        // Clonar la solicitud original y agregar el nuevo token en el encabezado de autorización
        const newRequest = request.clone({
          setHeaders: {
            Authorization: `Bearer ${newToken.token}`,
          }
        });

        // Volver a intentar la solicitud original con el nuevo token
        return next.handle(newRequest);
      }),
      catchError((error: any) => {
        // Error al refrescar el token, por ejemplo, cierre de sesión del usuario
        // Aquí puedes redirigir a la página de inicio de sesión o mostrar un mensaje de error
        return throwError(error);
      })
    );
  }
}
