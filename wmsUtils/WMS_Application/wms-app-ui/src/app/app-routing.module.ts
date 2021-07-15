import { Component, NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { TransactionListComponent } from './component/transaction-list/transaction-list.component';
import { TransactionUpdateComponent } from './component/transaction-update/transaction-update.component';
import { ReprintDocumentsComponent} from './component/reprint-documents/reprint-documents.component'
const routes: Routes = [ 
  {path : '', component : TransactionListComponent },  
  {path : 'transaction-list', component : TransactionListComponent },
  {path : 'reprint-documents', component : ReprintDocumentsComponent },
  {path : 'update-transaction/:type/:name/:warehouse/:message/:incidentnumber/:username', component : TransactionUpdateComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
