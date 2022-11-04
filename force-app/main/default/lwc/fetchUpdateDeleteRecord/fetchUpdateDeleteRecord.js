import { LightningElement, wire, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { refreshApex } from "@salesforce/apex";
import { deleteRecord } from "lightning/uiRecordApi";
import { updateRecord } from "lightning/uiRecordApi";
import getAccountRecordWithRelatedContactList from "@salesforce/apex/AccountController.getAccountRecordWithRelatedContactList";
import contactObject from "@salesforce/schema/Contact";
import Id from "@salesforce/schema/Contact.Id";
import contactFirstName from "@salesforce/schema/Contact.FirstName";
import contactLastName from "@salesforce/schema/Contact.LastName";

export default class FetchUpdateDeleteRecord extends LightningElement {
  @track accountList;
  @track error;
  @track contactId;
  @track firstName;
  @track lastName;

  // get the current parent recordId
  @api recordId;

  /** Wired Apex result so it can be refreshed programmatically */
    //wiredContactsResult;

    // pass the recordId to Apex Controller
    @wire(getAccountRecordWithRelatedContactList, { recordId: '$recordId' })
    wiredContacts(result) {
        // Hold on to the provisioned value so we can refresh it later.
        this.wiredContactsResult = result;

        if (result.data) {
            this.accountList = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.accountList = undefined;
        }

    }

    //   update the related Contact Record


    // Event occur at change the name of Contact
    onFirstNameChange(event){
        this.firstName = event.target.value;
    }

    onLastNameChange(event){
        this.lastName = event.target.value;
    }

    // Update the Contact
    updateContact(event){
       this.contactId = event.target.dataset.recordid;
        const recordInput = {
            fields: {
                [Id.fieldApiName]: this.contactId,
                [contactFirstName.fieldApiName]: this.firstName,
                [contactLastName.fieldApiName]: this.lastName,
            }
        };

        // Show Toast at Record Update
        updateRecord(recordInput).then((resolve) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record Updated',
                    variant: 'success',
                }),
            );
            return refreshApex(this.wiredContactsResult);
        }, (reason) => {
            console.log("Reason-->",reason);
        })

        //Show error when record does not updated
        .catch(error => {
          console.log("Error:--->  ",error);
        });

    }


    //  delete the Related Contact Record
    deleteContact(event) {
        const contactId = event.target.dataset.recordid;

        // Show Toast at Record Delete
        deleteRecord(contactId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record Deleted',
                        variant: 'success'
                    })
                );
                return refreshApex(this.wiredContactsResult);
            })

            //Show error when record does not deleted
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: reduceErrors(error).join(', '),
                        variant: 'error'
                    })
                );
            });
    }


}