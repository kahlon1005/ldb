import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { Outcome } from 'src/app/domain/outcome';
import { Transaction } from 'src/app/domain/transaction';
import { LoaderService } from 'src/app/service/loader.service';
import { TransactionService } from 'src/app/service/transaction.service';

@Component({
  selector: 'app-transaction-update',
  templateUrl: './transaction-update.component.html',
  styleUrls: ['./transaction-update.component.css']
})
export class TransactionUpdateComponent implements OnInit {

  transaction: Transaction;
  message: string;
  error: string;
  outcome: Outcome;
  success:boolean = true;
  isError: boolean = false;
  

  timeout=3000;
  mode= 'indeterminate';
  value= 50;
  color= 'primary';
  displayProgressSpinner: boolean = true;
  

  constructor(private transactionService: TransactionService,
              private route: ActivatedRoute,
              private router: Router,
              public loaderService: LoaderService) { }

  ngOnInit(): void {
    this.transaction = new Transaction();
    this.transaction.name = this.route.snapshot.params.name;
    this.transaction.type = this.route.snapshot.params.type;
    this.transaction.incidentNumber = this.route.snapshot.params.incidentnumber;
    this.transaction.username = this.route.snapshot.params.username;
    this.transaction.warehouse = this.route.snapshot.params.warehouse;
    this.transaction.message = this.route.snapshot.params.message;
    setTimeout(() => {
      this.updateTransaction(this.transaction);
      this.displayProgressSpinner= false; 
    }, this.timeout);
  }

  updateTransaction(transaction: Transaction): void {    
    this.transactionService.updateTransaction(transaction).subscribe(data => {
      this.success = JSON.parse(data['updated'].toLowerCase());
      if(this.success){
        this.message = data['message'];
      }else{
        this.error = data['message'];
        this.isError = true;
      }
    }, error => console.log(error));
    
  }

  goToTransactionList(): void{
    this.router.navigate(['transaction-list']);
  }

}

