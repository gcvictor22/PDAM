import { Component } from '@angular/core';
import { PageEvent } from '@angular/material/paginator';
import { GetAttendedEventsDto, GetEventDto } from 'src/app/interfaces/user/GetBuys.interface';
import { UserService } from 'src/app/services/user.service';
import { environment } from 'src/environments/environment.prod';


@Component({
  selector: 'app-buys',
  templateUrl: './buys.component.html',
  styleUrls: ['./buys.component.css']
})
export class BuysComponent {

  page: number = 0;
  attendedEvents : GetAttendedEventsDto = {} as GetAttendedEventsDto;
  aux : GetEventDto[] = [];
  baseUrl = environment.API_BASE_URL;

  constructor(private userService: UserService) {}

  ngOnInit(): void{
    this.userService.getAttendedEvents(this.page).subscribe((resp) => {
      this.attendedEvents = resp;
    })
  }

  cambiarPagina(page:PageEvent){
    this.userService.getAttendedEvents(page.pageIndex).subscribe((resp) => {
      this.attendedEvents = resp;
    })
  }

  abrirGoogleMaps(event: GetEventDto) {
    let latitud = event.location.split("/")[0];
    let longitud = event.location.split("/")[1];
    const url = `https://www.google.com/maps?q=${latitud},${longitud}`;
    window.open(url, '_blank');
  }
  

}
