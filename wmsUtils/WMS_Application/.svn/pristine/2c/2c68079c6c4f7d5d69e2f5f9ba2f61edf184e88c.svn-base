import { Component, Input, OnInit } from '@angular/core';
import { ThemePalette } from '@angular/material/core';
import { ProgressSpinnerMode } from '@angular/material/progress-spinner';

@Component({
  selector: 'app-progress-spinner',
  templateUrl: './progress-spinner.component.html',
  styleUrls: ['./progress-spinner.component.css']
})
export class ProgressSpinnerComponent{
  
  @Input() color?: ThemePalette;
  @Input() diameter?: number = 100;
  @Input() mode?: ProgressSpinnerMode;
  @Input() strokeWidth: number;
  @Input() value: number;

}
