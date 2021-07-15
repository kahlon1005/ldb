import { BrowserModule, Title } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TransactionListComponent } from './component/transaction-list/transaction-list.component';
import { TransactionUpdateComponent } from './component/transaction-update/transaction-update.component';
import { FieldErrorDisplayComponent } from './component/field-error-display/field-error-display.component';
import { ReprintDocumentsComponent } from './component/reprint-documents/reprint-documents.component';
import { ProgressSpinnerComponent } from './component/progress-spinner/progress-spinner.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { InterceptorService } from './service/interceptor.service';


@NgModule({
  declarations: [
    AppComponent,
    TransactionListComponent,
    TransactionUpdateComponent,
    FieldErrorDisplayComponent,
    ReprintDocumentsComponent,
    ProgressSpinnerComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    BrowserAnimationsModule,
    MatProgressSpinnerModule,
    
  ],
  providers: [
    Title,
    {provide: HTTP_INTERCEPTORS, useClass: InterceptorService, multi: true }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
