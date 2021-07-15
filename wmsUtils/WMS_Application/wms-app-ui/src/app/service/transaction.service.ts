import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { Transaction } from '../domain/transaction';
import { Poc } from '../domain/poc';

@Injectable({
  providedIn: 'root'
})
export class TransactionService {

  baseUrl: string;  
  pocurl: string = 'https://apimgm-realtimeinventory-poc-01.azure-api.net/V1/api/Retail/availability/sum';
  
  constructor(private httpClient: HttpClient) {
    this.setBaseUrl();    
    console.log('from transaction service ' + this.baseUrl);
  }

  getTransactionList():Observable<Transaction[]>{    
    return this.httpClient.get<Transaction[]>(`${this.baseUrl}`);
  }

  getPocList():Observable<Poc[]>{    
    const headers = new HttpHeaders({'Ocp-Apim-Subscription-Key': 'f883b5ade78443a2a29fad78bd4a8220'});
    return this.httpClient.get<Poc[]>(`${this.pocurl}`, {headers});
  }

  updateTransaction(transaction:Transaction):Observable<Object>{    
    return  this.httpClient.put<Object>(`${this.baseUrl}/${transaction.name}`,transaction);
  }

  setBaseUrl() {
    if (environment.production){
      const parsedUrl = new URL(window.location.href);    
      this.baseUrl =   parsedUrl.origin + environment.apiUrl;
    }  else{
      this.baseUrl =   environment.apiUrl;
    }
  }
}
