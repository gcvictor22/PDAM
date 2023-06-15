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
import { GetAttendedEventsDto } from '../interfaces/user/GetBuys.interface';

const TOKEN_KEY = 'user_token';
const REFRESHTOKEN_KEY = 'user_refresh_token';

const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json'
  })
};

const httpAuthOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    'Authorization': 'Bearer' + localStorage.getItem(TOKEN_KEY),
  })
};

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

  public getUsers(page: number, name: string):Observable<PageUsers> {
    return this.http.get<PageUsers>(`${environment.API_BASE_URL}/user/?page=${page}&s=userName:${name}`, httpAuthOptions);
  }

  public getProfile():Observable<GetProfileDto> {
    return this.http.get<GetProfileDto>(`${environment.API_BASE_URL}/user/profile/?page=0`, httpAuthOptions);
  }

  public getAttendedEvents(page: number):Observable<GetAttendedEventsDto> {
    return this.http.get<GetAttendedEventsDto>(`${environment.API_BASE_URL}/user/buys/event?page=${page}`, httpAuthOptions);
  }

  public isAuth():Observable<boolean>{
    return this.http.get<boolean>(`${environment.API_BASE_URL}/user/isAuth`, httpAuthOptions);
  }

  public isAdmin():Observable<boolean>{
    return this.http.get<boolean>(`${environment.API_BASE_URL}/user/isAdmin`, httpAuthOptions);
  }

  public convertToAdmin(id:string):Observable<GetUserDto>{
    return this.http.put<GetUserDto>(`${environment.API_BASE_URL}/admin/convert/admin/${id}`, httpAuthOptions);
  }

  public banUser(id:string):Observable<GetUserDto>{
    return this.http.put<GetUserDto>(`${environment.API_BASE_URL}/admin/convert/ban/${id}`, httpAuthOptions);
  }

  signOut(): void {
    localStorage.clear();
  }

  public saveToken(token: string): void {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.setItem(TOKEN_KEY, token);
  }

  public getToken(): string | null {
    return localStorage.getItem(TOKEN_KEY);
  }

  public saveRefreshToken(token: string): void {
    localStorage.removeItem(REFRESHTOKEN_KEY);
    localStorage.setItem(REFRESHTOKEN_KEY, token);
  }

  public getRefreshToken(): string | null {
    return localStorage.getItem(REFRESHTOKEN_KEY);
  }
}