import { Component, Inject } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialog, MatDialogRef } from '@angular/material/dialog';
import { Router, RouterLink } from '@angular/router';
import { Observable, map, startWith, timer } from 'rxjs';
import { GetCityDto } from 'src/app/interfaces/city/GetCityDto.interface';
import { CaptureError, Error } from 'src/app/interfaces/error/Error.interface';
import { NewLoginDto } from 'src/app/interfaces/user/NewLoginDto.interface';
import { NewUserDto } from 'src/app/interfaces/user/NewUserDto.interface';
import { VerifyToken } from 'src/app/interfaces/user/VerifyToken.interface';
import { UserService } from 'src/app/services/user.service';
import Swal, { } from 'sweetalert2'
import { VerifyDialogComponent } from '../verify-dialog/verify-dialog.component';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  userName !: string;
  password !: string;
  textObscured: boolean = true;
  cities: GetCityDto[] = [];
  textObscuredR: boolean = true;
  textObscuredConfirmR: boolean = true;
  searchCity !: string;
  filteredOptions !: Observable<GetCityDto[]>;
  myControl = new FormControl();
  submiting = false;

  registerForm = new FormGroup({
    fullNameR: new FormControl('', [Validators.required]),
    genderR: new FormControl(63, [Validators.required]),
    userNameR: new FormControl('', [Validators.required]),
    passwordR: new FormControl('', [Validators.required]),
    confirmPasswordR: new FormControl('', [Validators.required]),
    emailR: new FormControl('', [Validators.required, Validators.email]),
    phoneNumberR: new FormControl('', [Validators.required]),
    cityR: new FormControl(this.myControl, [Validators.required]),
  });
  selectedCity: GetCityDto = {} as GetCityDto;

  constructor(private userService: UserService, private router: Router, public dialog: MatDialog) { }

  ngOnInit(): void {
    this.userService.getCities().subscribe((resp) => {
      this.cities = resp;
      this.registerForm.controls.cityR.setValue("");
    });

    this.filteredOptions = this.registerForm.controls.cityR.valueChanges.pipe(
      startWith(''),
      map(value => this._filter(value))
    );
  }

  private _filter(value: string): GetCityDto[] {
    const filterValue = value.toLowerCase();

    return this.cities.filter(option => option.name.toLowerCase().indexOf(filterValue) === 0);
  }

  doLogin() {
    var newLoginDto: NewLoginDto = {
      username: this.userName,
      password: this.password
    };
    return this.userService.login(newLoginDto).subscribe((resp) => {
      this.userService.saveToken(resp.token);
      this.userService.saveRefreshToken(resp.refreshToken);
      this.router.navigate(['landing']);
    }, (error) => {
      CaptureError.catchError(error);
    });
  }

  doRegister() {
    this.submiting = true;
    var newUserDto: NewUserDto = {
      fullName: this.registerForm.controls.fullNameR.value!,
      username: this.registerForm.controls.userNameR.value!,
      password: this.registerForm.controls.passwordR.value!,
      verifyPassword: this.registerForm.controls.confirmPasswordR.value!,
      email: this.registerForm.controls.emailR.value!,
      phoneNumber: this.registerForm.controls.phoneNumberR.value!,
      cityId: this.selectedCity.id,
      genderId: this.registerForm.controls.genderR.value!,
    }

    this.userService.register(newUserDto).subscribe((resp) => {
      this.submiting = false;
      console.log(resp);
      localStorage.setItem("userName", resp.userName);
      this.openDialog();
    }, (error) => {
      this.submiting = false;
      console.log(error.error);
      CaptureError.catchError(error);
    })
  }

  openDialog(): void {
    this.dialog.open(VerifyDialogComponent);
  }

  updateCityValue() {
    this.registerForm.controls.cityR.valueChanges.subscribe((value) => {
      for (const city of this.cities) {
        if (city.name == value) {
          this.selectedCity = city;
        }
      }
    });
  }

  printCity(city: GetCityDto) {
    console.log(city);
  }
}
