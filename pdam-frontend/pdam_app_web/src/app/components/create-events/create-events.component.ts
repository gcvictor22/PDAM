import { Component, Inject } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { DateAdapter, MAT_DATE_LOCALE } from '@angular/material/core';
import { Observable, map, startWith } from 'rxjs';
import { GetCityDto } from 'src/app/interfaces/city/GetCityDto.interface';
import { CaptureError } from 'src/app/interfaces/error/Error.interface';
import { NewDiscothequeDto, NewFestivalDto } from 'src/app/interfaces/event/NewEventDto.interface';
import { EventsService } from 'src/app/services/events.service';
import { UserService } from 'src/app/services/user.service';
import { FechaPipe } from 'src/app/utils/fecha.pipe';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-create-events',
  templateUrl: './create-events.component.html',
  styleUrls: ['./create-events.component.css'],
  providers: [FechaPipe]
})
export class CreateEventsComponent {

  constructor(private userService: UserService, private _adapter: DateAdapter<any>,
    @Inject(MAT_DATE_LOCALE) private _locale: string, private eventService: EventsService) {
  }

  citiesD: GetCityDto[] = [];
  citiesF: GetCityDto[] = [];
  myControlD = new FormControl();
  myControlF = new FormControl();
  selectedCityD: GetCityDto = {} as GetCityDto;
  selectedCityF: GetCityDto = {} as GetCityDto;
  filteredOptionsD !: Observable<GetCityDto[]>;
  filteredOptionsF !: Observable<GetCityDto[]>;
  submitingDicotheque = false;
  submitingFestival = false;

  ngOnInit(): void {
    this.userService.getCities().subscribe((resp) => {
      this.citiesD = resp;
      this.citiesF = resp;
      this.newDiscotheque.controls.cityD.setValue("");
      this.newFestival.controls.cityF.setValue("");
    });

    this.filteredOptionsD = this.newDiscotheque.controls.cityD.valueChanges.pipe(
      startWith(''),
      map(value => this._filterD(value))
    );

    this.filteredOptionsF = this.newFestival.controls.cityF.valueChanges.pipe(
      startWith(''),
      map(value => this._filterF(value))
    );


    this._locale = 'fr';
    this._adapter.setLocale(this._locale);
  }

  newDiscotheque = new FormGroup({
    name: new FormControl('', [Validators.required]),
    cityD: new FormControl(this.myControlD, [Validators.required]),
    location: new FormControl('', [Validators.required]),
    capacity: new FormControl(1, [Validators.required]),
  });

  updateCityValueD() {
    this.newDiscotheque.controls.cityD.valueChanges.subscribe((value) => {
      for (const city of this.citiesD) {
        if (city.name == value) {
          this.selectedCityD = city;
        }
      }
    });
  }

  private _filterD(value: string): GetCityDto[] {
    const filterValue = value.toLowerCase();

    return this.citiesD.filter(option => option.name.toLowerCase().indexOf(filterValue) === 0);
  }

  updateCityValueF() {
    this.newFestival.controls.cityF.valueChanges.subscribe((value) => {
      for (const city of this.citiesF) {
        if (city.name == value) {
          this.selectedCityF = city;
        }
      }
    });
  }

  private _filterF(value: string): GetCityDto[] {
    const filterValue = value.toLowerCase();

    return this.citiesF.filter(option => option.name.toLowerCase().indexOf(filterValue) === 0);
  }

  newFestival = new FormGroup({
    name: new FormControl('', [Validators.required]),
    description: new FormControl('', [Validators.required]),
    location: new FormControl('', [Validators.required]),
    cityF: new FormControl(this.myControlF, [Validators.required]),
    capacity: new FormControl(1, [Validators.required]),
    dateTime: new FormControl('', [Validators.required]),
    duration: new FormControl(1, [Validators.required]),
    price: new FormControl(0.0, [Validators.required]),
    drinkIncluded: new FormControl(false, [Validators.required]),
    numberOfDrinks: new FormControl(0, [Validators.required]),
    adult: new FormControl(false, [Validators.required]),
  });

  createDiscotheque() {
    let c = this.newDiscotheque.controls;

    let newDiscotheque: NewDiscothequeDto = {
      name: c.name.value!,
      cityId: this.selectedCityD.id,
      location: c.location.value!,
      capacity: c.capacity.value!,
    }

    this.eventService.crfeateDiscotheque(newDiscotheque).subscribe(() => {
      Swal.fire({
        icon: 'success',
        title: '¡La discoteca se ha publicado con éxito!',
        timer: 1500,
        showConfirmButton: false
      }).then(() => {
        window.location.reload()
      })
    }, (er) => CaptureError.catchError(er))
  }

  createFestival() {
    let c = this.newFestival.controls;

    let newFestival: NewFestivalDto = {
      name: c.name.value!,
      description: c.description.value!,
      location: c.location.value!,
      cityId: this.selectedCityF.id,
      capacity: c.capacity.value!,
      dateTime: this.formatFecha(c.dateTime.value)+" 00:00:00",
      duration: c.duration.value!,
      price: c.price.value!,
      drinkIncluded: c.drinkIncluded.value!,
      numberOfDrinks: c.numberOfDrinks.value!,
      adult: c.adult.value!
    }

    this.eventService.crateFestival(newFestival).subscribe(() => {
      Swal.fire({
        icon: 'success',
        title: '¡El festival se ha publicado con éxito!',
        showConfirmButton: false,
        timer: 1500
      }).then(() => {
        window.location.reload()
      })
    }, (er) => CaptureError.catchError(er))
  }

  formatFecha(date: any): string {
    // Convierte el valor en un objeto Date
    const fecha = new Date(date);

    // Obtén los componentes de fecha individuales (día, mes, año)
    const dia = fecha.getDate();
    const mes = fecha.getMonth() + 1; // Los meses en JavaScript se indexan desde 0, por lo que se suma 1
    const anio = fecha.getFullYear();

    // Formatea la fecha en el formato deseado (dd/MM/yyyy)
    const fechaFormateada = `${dia.toString().padStart(2, '0')}/${mes.toString().padStart(2, '0')}/${anio}`;

    // Utiliza el valor formateado como desees (por ejemplo, muestra en la consola)
    console.log(fechaFormateada);

    return fechaFormateada;
  }
}
