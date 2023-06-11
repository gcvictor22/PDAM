import { Component } from '@angular/core';
import { Router } from '@angular/router';
import { UserService } from 'src/app/services/user.service';

@Component({
  selector: 'app-sidebar',
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent {
  showSide = false;

  constructor (private router : Router, private userService : UserService) {}

  isCurrentPage() {
    switch (this.router.url) {
      case "/landing/dashboard":
        return 1;
        break;
    
      default:
        return 4;
        break;
    }
  }

  navigateProfile() {
    this.router.navigate(['/landing/dashboard']);
  }

  logOut() {
    this.userService.signOut();
    this.router.navigate(['login']);
  }

  ngOnInit(): void {
    console.log(this.isCurrentPage() == 1);
    
  }
}
