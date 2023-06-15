import { Component, Input } from '@angular/core';
import { MatSnackBar, MatSnackBarDismiss, MatSnackBarHorizontalPosition, MatSnackBarVerticalPosition } from '@angular/material/snack-bar';
import { PageUsers } from 'src/app/interfaces/page/Page.interface';
import { GetProfileDto, Post, PublishedPosts } from 'src/app/interfaces/user/GetProfileDto.interface';
import { PostService } from 'src/app/services/post.service';
import { UserService } from 'src/app/services/user.service';
import { environment } from 'src/environments/environment.prod';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-landing',
  templateUrl: './landing.component.html',
  styleUrls: ['./landing.component.css']
})
export class LandingComponent {

  constructor(private userService: UserService, private _snackBar: MatSnackBar, private postService : PostService) { }

  loggedUser: GetProfileDto = {} as GetProfileDto;
  baseUrl = environment.API_BASE_URL;
  loading: boolean = true;
  postsPage: PublishedPosts = {} as PublishedPosts;

  ngOnInit(): void {
    this.userService.getProfile().subscribe((resp) => {
      this.loggedUser = resp;
      this.postsPage = resp.publishedPosts;
      this.loading = false;
    })
  }

  horizontalPosition: MatSnackBarHorizontalPosition = 'start';
  verticalPosition: MatSnackBarVerticalPosition = 'bottom';

  openSnackBar(post: HTMLElement, postId: number) {
    let deletePost = true; // Bandera para controlar si se debe eliminar el post o no
  
    const sb = this._snackBar.open("Se ha eliminado el post", "Deshacer", {
      horizontalPosition: this.horizontalPosition,
      verticalPosition: this.verticalPosition,
      duration: 3000
    });
  
    sb.onAction().subscribe(() => {
      post.style.display = "flex";
      deletePost = false; // Se cancela la eliminación del post
    });
  
    sb.afterDismissed().subscribe(() => {
      if (deletePost) {
        this.postService.delete(postId).subscribe();
      }
    });
  }
  

  openAlert(id: number, postId : number) {
    Swal.fire({
      icon: "warning",
      title: "¡Alerta!",
      text: "¿Estás seguro que quieres eliminar el post?",
      showCancelButton: true
    }).then((value) => {
      if (value.isConfirmed) {
        let post = window.document.getElementById(id.toString());
        if (post) {
          post.style.display = "none";
          this.openSnackBar(post, postId)
        }
      }
    })
  }

  like(id : string, post : Post, numberId: string) {
    let button = window.document.getElementById(id.toString());
    let number = window.document.getElementById(numberId.toString());
    
    if(button && number){
      if (button.style.color === "red"){
        var currentValue = parseInt(number.innerHTML);
        var newValue = currentValue - 1;
        number.innerHTML = newValue.toString(); 
        button.style.color = "black";
      }else{
        var currentValue = parseInt(number.innerHTML);
        var newValue = currentValue + 1;
        number.innerHTML = newValue.toString(); 
        button.style.color = "red";
      }
      this.postService.likePost(post.id).subscribe();
    }
  }
}
