import { LightningElement,wire } from 'lwc';
import FirstName_FIELD from '@salesforce/schema/Contact.FirstName';
import LastName_FIELD from '@salesforce/schema/Contact.LastName';
import Email_FIELD from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils';

const COLUMNS= [
    { label: 'FirstName', fieldName:FirstName_FIELD.fieldApiName , type: 'text' },
    { label: 'LastName', fieldName:LastName_FIELD.fieldApiName , type: 'text' },
    { label: 'Email', fieldName: Email_FIELD.fieldApiName , type: 'email' }
];

export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts)
    Contacts;
    get errors() {
        
        console.log('Test 2222'+ this.Contacts.error);
        return (this.Contacts.error) ?
            reduceErrors(this.Contacts.error) : [];
            
    }
}