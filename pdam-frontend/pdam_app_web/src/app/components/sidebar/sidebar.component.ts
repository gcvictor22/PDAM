import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent {
  showMyEvent !: boolean;
  showCreateAndBan !: boolean;

  constructor (private router : Router, private userService : UserService) {}

  ngOnInit():void {
    this.userService.isAuth().subscribe((resp) => {
      this.showMyEvent = resp;
    });

    this.userService.isAdmin().subscribe((resp) => {
      this.showCreateAndBan = resp;
    });
  }

  isCurrentPage() {
    switch (this.router.url) {
      case "/landing/dashboard":
        return 1;
        break;
      case "/landing/buys":
        return 2;
      case "/landing/users":
        return 3;
      case "/landing/create":
        return 4;
      default:
        return 5;
        break;
    }
  }

  navigateProfile() {
    this.router.navigate(['/landing/dashboard']);
  }

  navigateBuys(){
    this.router.navigate(['/landing/buys']);
  }

  navigateUsers(){
    this.router.navigate(['/landing/users']);
  }

  navigateCreate(){
    this.router.navigate(['/landing/create']);
  }

  logOut() {
    this.userService.signOut();
    this.router.navigate(['login']);
  }
}
