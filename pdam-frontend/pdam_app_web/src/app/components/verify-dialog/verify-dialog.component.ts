import { Component } from '@angular/core';
import { MatDialogRef } from '@angular/material/dialog';
import { CaptureError } from 'src/app/interfaces/error/Error.interface';
import { VerifyToken } from 'src/app/interfaces/user/VerifyToken.interface';
import { UserService } from 'src/app/services/user.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-verify-dialog',
  templateUrl: './verify-dialog.component.html',
  styleUrls: ['./verify-dialog.component.css'],
})
export class VerifyDialogComponent {

  constructor(
    private userService : UserService,
    public dialogRef: MatDialogRef<VerifyDialogComponent>,
  ) {}

  verifyToken !: number;
  userName !: string;

  ngOnInit(){
    this.userName = localStorage.getItem("userName")!;
  }

  doVerify() {
    var verifyToken: VerifyToken = {
      userName: this.userName,
      verificationNumber: this.verifyToken!,
    }

    this.userService.verify(verifyToken).subscribe((resp) => {
      Swal.fire({
        icon: 'success',
        title: '¡Cuenta creada con éxito!',
        timer: 1500,
      }).then(() => window.location.reload())
    }, (error) => {
      CaptureError.catchError(error);
    })
  }

  cancel(): void {
    this.dialogRef.close();
  }

}
