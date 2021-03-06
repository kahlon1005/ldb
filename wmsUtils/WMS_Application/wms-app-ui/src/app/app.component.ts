import { Component } from '@angular/core';
import { Title } from '@angular/platform-browser';
import { Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']

})
export class AppComponent {
  title = 'WMS Utils';
  year = 2020;
  
  public constructor(private titleService : Title, private router: Router){
    this.titleService.setTitle(this.title);
    this.router.navigate(['transaction-list']);
    this.year = new Date().getFullYear();
  }

}
