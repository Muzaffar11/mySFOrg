import { LightningElement,api } from 'lwc';

export default class Numerator extends LightningElement {

    // @api counter = 0;
   
    _currentCount = 0;
    priorCount = 0;
    @api
    get counter2() {
        console.log('get' + this._currentCount );
      return this._currentCount;
    }
    set counter2(value) {
        console.log('set' + value);
      this.priorCount = this._currentCount;
      this._currentCount = value;
    }
   
    handleIncrement() {
      this.counter2++;
    }
    handleDecrement() {
      this.counter2--;
    }
    handleMultiply(event) {
       // console.log('Event detail' +event.detail);
        const factor = event.detail;
        this.counter2 *= factor;
      }
      @api
      maximizeCounter() {
        this.counter2 += 1000000;
      }
}