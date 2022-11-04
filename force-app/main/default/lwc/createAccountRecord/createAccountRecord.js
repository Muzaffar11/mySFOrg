import { LightningElement } from 'lwc';
import accountObject from '@salesforce/schema/Account';
import nameField from '@salesforce/schema/Account.Name';
import websiteField from '@salesforce/schema/Account.Website';
import industryField from '@salesforce/schema/Account.Industry';
import SupportPlanStartDateField from '@salesforce/schema/Account.Support_Plan_Start_Date__c';


export default class CreateAccountRecord extends LightningElement {
  
     // Code for  create the Account Record
     accountObject = accountObject;
     myFields = [nameField, websiteField, industryField,SupportPlanStartDateField];
 
     handleSubmit(){
         
     }
     handleSuccess() {
        
     }
}