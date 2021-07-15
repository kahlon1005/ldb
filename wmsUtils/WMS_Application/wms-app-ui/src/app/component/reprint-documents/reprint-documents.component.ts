import { Component, OnInit } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';

@Component({
  selector: 'app-reprint-documents',
  templateUrl: './reprint-documents.component.html',
  styleUrls: ['./reprint-documents.component.css']
})
export class ReprintDocumentsComponent implements OnInit {

  transactionForm: FormGroup;
  submitted = false;
  
  constructor(private router: Router) { }

  ngOnInit(): void {
    this.transactionForm = new FormGroup({
      name: new FormControl(null, [Validators.required, Validators.minLength(4)]),
      type: new FormControl('DOC'),
      warehouse: new FormControl('VDC'),      
      message: new FormControl('Re-print shipping documents.'),
      incidentNumber: new FormControl(null, [Validators.required, Validators.minLength(4)]),
      username: new FormControl(null, [Validators.required, Validators.minLength(4)])
    });   
  }

  get f() { return this.transactionForm.controls; }
 
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

  updateTransaction(form: FormGroup){    
    this.router.navigate(['update-transaction', form.get('type').value.toLowerCase(), form.get('name').value, form.get('warehouse').value, form.get('message').value, form.get('incidentNumber').value, form.get('username').value]);
  }

  onSubmit(){
    this.submitted = true;
    if (this.transactionForm.valid) {
      this.updateTransaction(this.transactionForm);           
    } else {
      this.validateAllFormFields(this.transactionForm);
    }
  }
  
  onReset(){
    this.submitted = false;
  }

}
