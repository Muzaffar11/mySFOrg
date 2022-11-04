import { api, LightningElement } from 'lwc';
import getRelatedContacts from '@salesforce/apex/AccountController.getRelatedContacts';



export default class CallApexImperative extends LightningElement {
 @api recordId;

 handleButtonClick()
 {
     getRelatedContacts({
         accountId: '$recordId'
     })
    .then(contact =>
        {
            //code to execute if related contacts are returned successfully
        })
        .catch(error =>
            {
                this.errors = reduceErrors(error);  // code to execute if the promise is rejected
            });
 }

}