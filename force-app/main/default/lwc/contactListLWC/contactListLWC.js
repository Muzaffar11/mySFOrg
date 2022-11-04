import { LightningElement,wire } from 'lwc';
import getContacts from '@salesforce/apex/AccountController.getContacts';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Email', fieldName: 'Email'  , type: 'email' },
    { label: 'Phone', fieldName: 'Phone' , type: 'phone' }
];


export default class ContactListLWC extends LightningElement {

    columns = COLUMNS;
    @wire(getContacts)
    Contacts;

    
}