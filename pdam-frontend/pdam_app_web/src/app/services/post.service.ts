import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Post } from '../interfaces/user/GetProfileDto.interface';
import { environment } from 'src/environments/environment.prod';

const httpAuthOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    'Authorization': 'Bearer' + window.sessionStorage.getItem("user_token"),
  })
};

@Injectable({
  providedIn: 'root'
})
export class PostService {

  constructor(private http: HttpClient) { }

  public likePost(id : number):Observable<Post>{
    return this.http.post<Post>(`${environment.API_BASE_URL}/post/like/${id}`, null, httpAuthOptions)
  }

  public delete(id : number):Observable<any>{
    return this.http.delete(`${environment.API_BASE_URL}/post/${id}`, httpAuthOptions);
  }
}
