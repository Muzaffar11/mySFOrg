import { LightningElement,track } from 'lwc';

export default class SimpleEvent extends LightningElement {

    @track page = 1;
    handleNext(){
        alert(this.page);
        this.page = this.page +1;
    

    }
    handlePrevious(){
       // alert(this.page);
        if(this.page > 1)
             this.page = this.page -1;

    }

}