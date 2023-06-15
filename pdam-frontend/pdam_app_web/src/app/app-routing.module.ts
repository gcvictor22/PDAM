import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { NotFoundComponent } from './components/not-found/not-found.component';
import { LoginComponent } from './components/login/login.component';
import { LandingComponent } from './components/landing/landing.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { BuysComponent } from './components/buys/buys.component';
import { UsersComponent } from './components/users/users.component';
import { CreateEventsComponent } from './components/create-events/create-events.component';

const routes: Routes = [
  {path:'login', component:LoginComponent},
  {path:'error', component:NotFoundComponent},
  {path:'landing', component:SidebarComponent, children:[
    {path:'', redirectTo:'dashboard', pathMatch:'full'},
    {path:'dashboard', component:LandingComponent},
    {path:'buys', component:BuysComponent},
    {path:'users', component:UsersComponent},
    {path:'create', component:CreateEventsComponent},
  ]},
  {path:'', redirectTo:'login', pathMatch:'full'},
  {path:'**', redirectTo:'error'},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
