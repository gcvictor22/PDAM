import { DatePipe } from '@angular/common';
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'fecha'
})
export class FechaPipe extends DatePipe implements PipeTransform {
  override transform(value: any, args?: any): any {
    return super.transform(value, 'dd/MM/yyyy');
  }
}
