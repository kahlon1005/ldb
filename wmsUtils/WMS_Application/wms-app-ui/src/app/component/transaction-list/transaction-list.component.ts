import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormControl, FormGroup, ValidatorFn, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { Transaction } from 'src/app/domain/transaction';
import { Poc } from 'src/app/domain/poc';
import { LoaderService } from 'src/app/service/loader.service';
import { TransactionService } from 'src/app/service/transaction.service';

@Component({
  selector: 'app-transaction-list',
  templateUrl: './transaction-list.component.html',
  styleUrls: ['./transaction-list.component.css']
})
export class TransactionListComponent implements OnInit {

  poclist : Poc[];
  transactions : Transaction[];   
  selected: boolean;
  message:string;  
  transactionExists = true;  
  
  transactionForm: FormGroup;
  submitted = false;

  timeout=3000;
  mode= 'indeterminate';
  value= 50;
  color= 'primary';
  displayProgressSpinner: boolean = true;
  loading$ = this.loaderService.loading$;
  
  constructor(private transactionService:TransactionService, private router: Router, private loaderService: LoaderService) {
    
   }

  ngOnInit(): void {    
    this.getTransactions();     
    this.getPocList();   
    this.selected= false;                              
  }

  get f() { return this.transactionForm.controls; }
  
  isFieldValid(field: string) {
    return !this.transactionForm.get(field).valid && this.transactionForm.get(field).touched;
  }

  displayFieldCss(field: string) {
    return {
      'has-error': this.isFieldValid(field),
      'has-feedback': this.isFieldValid(field)
    };
  }

  validateAllFormFields(formGroup: FormGroup) {
    Object.keys(formGroup.controls).forEach(field => {
      const control = formGroup.get(field);
      if (control instanceof FormControl) {
        control.markAsTouched({ onlySelf: true });
      } else if (control instanceof FormGroup) {
        this.validateAllFormFields(control);
      }
    });
  }

  private getTransactions(){
    console.log('get transaction list ...')
    this.transactionService.getTransactionList().subscribe(data => {
      this.transactions = data;
      if(this.transactions.length == 0){
        this.transactionExists = false;        
      }else{        
        this.transactionExists = true;       
      }      
    })
  }

  private getPocList(){
    console.log('get poc list ...')
    this.transactionService.getPocList().subscribe(data => {
      this.poclist = data;
    })
    console.log('poc list: ' + this.poclist)
  }

  setTransaction(name: string, type: string, warehouse: string, message: string){
    this.loaderService.show();
    setTimeout(() => {
      this.startTransaction(name, type, warehouse, message);
      this.loaderService.hide();
    }, this.timeout)
    
  }

  startTransaction(name: string, type: string, warehouse: string, message: string){   
    this.transactionForm = new FormGroup({      
      name: new FormControl(name),
      type: new FormControl(type),      
      warehouse: new FormControl(warehouse),
      message: new FormControl(message),
      incidentNumber: new FormControl(null, [Validators.required, Validators.minLength(10)]),
      username: new FormControl(null, [Validators.required, Validators.minLength(4)])
    });   
    this.selected= true;    
  }

  updateTransaction(form: FormGroup){    
    this.router.navigate(['update-transaction', form.get('type').value.toLowerCase(), form.get('name').value, form.get('warehouse').value, form.get('message').value, form.get('incidentNumber').value, form.get('username').value]);
  }

  onSubmit() {   
      this.submitted = true;
      if (this.transactionForm.valid) {                
        this.updateTransaction(this.transactionForm);
      } else {
        this.validateAllFormFields(this.transactionForm);
      }      
  }

  onReset(){
    this.transactions = [];
    this.selected= false;
    this.onRefresh();    
  }

  onRefresh(){
    window.location.reload();
  }
}
