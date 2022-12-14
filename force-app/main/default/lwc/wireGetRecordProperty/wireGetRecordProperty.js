import { api, LightningElement, wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi'
import Account_Name from '@salesforce/schema/Account.Name'

export default class WireGetRecordProperty extends LightningElement 
{
@api recordId;
data;
error;
@wire (getRecord ,{recordId: '$recordId' ,fields: [Account_Name]})
//account;
  wireAccount({data,error})
  {
     console.log('Execute logic each time a new value is provisioned');

     if (data) {
        this.data = data;
        this.error = undefined;
    } else if (error) {
        this.error = error;
        this.data = undefined;
    }

  }  
}