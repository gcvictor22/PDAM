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

const TOKEN_HEADER_KEY = 'Authorization';

@Injectable()
export class TokenInterceptor implements HttpInterceptor {

  constructor(private userService: UserService) {}

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    if (req.url != 'http://localhost:8080/user/login') {

      req = req.clone({
        setHeaders: {
          'Access-Control-Allow-Origin': 'http://localhost:4200',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
          'Access-Control-Allow-Headers': 'X-Requested-With, Content-Type, Authorization'
        }
      });

      let authReq = req;
      const token = this.userService.getToken()
      if (token != null) {
        authReq = req.clone({ headers: req.headers.set(TOKEN_HEADER_KEY, 'Bearer ' + token) });
      }

      return next.handle(authReq);
    } return next.handle(req);
  }
}