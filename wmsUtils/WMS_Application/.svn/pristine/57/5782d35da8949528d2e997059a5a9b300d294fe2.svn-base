import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoaderService {

  private _loading = new BehaviorSubject<boolean>(false);

  public readonly loading$ = this._loading.asObservable();

  show(){
    this._loading.next(true);
    console.log('show loader ...')
  }

  hide(){
    this._loading.next(false);  
    console.log('hide loader ...')
  }

  constructor() { }
}
