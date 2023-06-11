import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { GetLoginDto } from '../interfaces/user/GetLoginDto.interface';
import { NewLoginDto } from '../interfaces/user/NewLoginDto.interface';
import { environment } from 'src/environments/environment.prod';
import { GetCityDto } from '../interfaces/city/GetCityDto.interface';
import { NewUserDto } from '../interfaces/user/NewUserDto.interface';
import { GetUserDto } from '../interfaces/user/GetUserDto.interface';
import { Error } from '../interfaces/error/Error.interface';
import { RefreshToken } from '../interfaces/user/RefeshToken.interface';
import { VerifyToken } from '../interfaces/user/VerifyToken.interface';
import { PageUsers } from '../interfaces/page/Page.interface';
import { GetProfileDto } from '../interfaces/user/GetProfileDto.interface';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json'
  })
};

const httpAuthOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    'Authorization': 'Bearer' + window.sessionStorage.getItem("user_token"),
  })
};

const TOKEN_KEY = 'user_token';
const REFRESHTOKEN_KEY = 'user_refresh_token';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private http: HttpClient) { }

  refreshToken(refreshTokenValue : string):Observable<GetLoginDto> {

    interface RefreshToken{
      refreshToken : string;
    }

    var body : RefreshToken = {
      refreshToken: refreshTokenValue
    }

    return this.http.post<GetLoginDto>(`${environment.API_BASE_URL}/user/refreshtoken`, body, httpOptions);
  }

  public login(newLoginDto: NewLoginDto): Observable<GetLoginDto> {
    return this.http.post<GetLoginDto>(`${environment.API_BASE_URL}/user/login`, newLoginDto, httpOptions);
  }

  public register(newUserDto: NewUserDto):Observable<GetUserDto> {
    return this.http.post<GetUserDto>(`${environment.API_BASE_URL}/user/register`, newUserDto, httpOptions);
  }

  public verify(verifyToken: VerifyToken):Observable<GetUserDto> {
    return this.http.put<GetUserDto>(`${environment.API_BASE_URL}/user/verification`, verifyToken, httpOptions);
  }

  public getCities():Observable<GetCityDto[]> {
    return this.http.get<GetCityDto[]>(`${environment.API_BASE_URL}/city/`, httpOptions);
  }

  public getUsers():Observable<PageUsers> {
    return this.http.get<PageUsers>(`${environment.API_BASE_URL}/user/`, httpAuthOptions);
  }

  public getProfile():Observable<GetProfileDto> {
    return this.http.get<GetProfileDto>(`${environment.API_BASE_URL}/user/profile/?page=0`, httpAuthOptions)
  }

  signOut(): void {
    window.sessionStorage.clear();
  }

  public saveToken(token: string): void {
    window.sessionStorage.removeItem(TOKEN_KEY);
    window.sessionStorage.setItem(TOKEN_KEY, token);
  }

  public getToken(): string | null {
    return window.sessionStorage.getItem(TOKEN_KEY);
  }

  public saveRefreshToken(token: string): void {
    window.sessionStorage.removeItem(REFRESHTOKEN_KEY);
    window.sessionStorage.setItem(REFRESHTOKEN_KEY, token);
  }

  public getRefreshToken(): string | null {
    return window.sessionStorage.getItem(REFRESHTOKEN_KEY);
  }
}