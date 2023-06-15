import { Component } from '@angular/core';
import { PageEvent } from '@angular/material/paginator';
import { PageUsers } from 'src/app/interfaces/page/Page.interface';
import { GetUserDto } from 'src/app/interfaces/user/GetUserDto.interface';
import { UserService } from 'src/app/services/user.service';
import { environment } from 'src/environments/environment.prod';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-users',
  templateUrl: './users.component.html',
  styleUrls: ['./users.component.css']
})
export class UsersComponent {

  constructor(private userService: UserService) {}

  fetchedUsers: PageUsers = {} as PageUsers;
  page: number = 0;
  userName: string = "";
  displayedColumns: string[] = ['usuario', 'nombreCompleto', 'social', 'acciones'];
  baseUrl = environment.API_BASE_URL;
  loggedUser = localStorage.getItem("userId");

  ngOnInit():void {
    this.userService.getUsers(this.page, this.userName).subscribe((resp) => {
      this.fetchedUsers = resp;
    })
  }

  cambiarPagina(page:PageEvent){
    this.userService.getUsers(page.pageIndex, "").subscribe((resp) => {
      this.fetchedUsers = resp;
    })
  }

  buscarNombre(userName: string){
    this.userService.getUsers(0, userName).subscribe((resp) => {
      this.fetchedUsers = resp;
    })
  }

  openAdminSwal(userName: string, id:string){
    Swal.fire({
      icon : 'question',
      title : `¿Estas seguro que quieres cambiar el admin a ${userName}?`,
      showCancelButton: true
    }).then((value) => {
      if (value.isConfirmed) {
        this.convertToAdmin(id);
      }
    })
  }

  openBanSwal(userName: string, id:string){
    Swal.fire({
      icon : 'question',
      title : `¿Estas seguro que quieres cambiar el baneo a ${userName}?`,
      showCancelButton: true
    }).then((value) => {
      if (value.isConfirmed) {
        this.banUser(id);
      }
    })
  }

  convertToAdmin(id:string){
    this.userService.convertToAdmin(id).subscribe();
    window.location.reload();
  }

  banUser(id:string){
    this.userService.banUser(id).subscribe();
    window.location.reload();
  }

}
