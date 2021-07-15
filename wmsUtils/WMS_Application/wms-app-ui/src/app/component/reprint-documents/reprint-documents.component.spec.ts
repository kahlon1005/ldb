import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReprintDocumentsComponent } from './reprint-documents.component';

describe('ReprintDocumentsComponent', () => {
  let component: ReprintDocumentsComponent;
  let fixture: ComponentFixture<ReprintDocumentsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReprintDocumentsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReprintDocumentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
