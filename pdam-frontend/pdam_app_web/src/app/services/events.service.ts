import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { NewDiscothequeDto, NewFestivalDto } from '../interfaces/event/NewEventDto.interface';
import { GetEventDto } from '../interfaces/user/GetBuys.interface';
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
export class EventsService {

  constructor(private http : HttpClient) { }

  public crateFestival(newFestival: NewFestivalDto):Observable<GetEventDto>{
    return this.http.post<GetEventDto>(`${environment.API_BASE_URL}/festival/`, newFestival, httpAuthOptions);
  }

  public crfeateDiscotheque(newDiscotheque: NewDiscothequeDto):Observable<GetEventDto>{
    return this.http.post<GetEventDto>(`${environment.API_BASE_URL}/discotheque/`, newDiscotheque, httpAuthOptions);
  }
}
