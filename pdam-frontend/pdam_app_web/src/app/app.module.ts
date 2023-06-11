import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MaterialImportsModule } from 'src/modules/material-imports.module';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';
import { NotFoundComponent } from './components/not-found/not-found.component';
import { LoginComponent } from './components/login/login.component';
import { FormsModule } from '@angular/forms';
import { LandingComponent } from './components/landing/landing.component';
import { VerifyDialogComponent } from './components/verify-dialog/verify-dialog.component';
import { TokenInterceptor } from './services/request.interceptor';
import { SidebarComponent } from './components/sidebar/sidebar.component';

@NgModule({
  declarations: [
    AppComponent,
    NotFoundComponent,
    LoginComponent,
    LandingComponent,
    VerifyDialogComponent,
    SidebarComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    MaterialImportsModule,
    BrowserAnimationsModule,
    HttpClientModule,
    FormsModule
  ],
  providers: [{
    provide : HTTP_INTERCEPTORS, useClass: TokenInterceptor, multi:true
  }],
  bootstrap: [AppComponent]
})
export class AppModule { }
