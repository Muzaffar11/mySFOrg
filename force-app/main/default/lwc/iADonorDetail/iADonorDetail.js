import { LightningElement,api,wire,track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { registerListener,unregisterListener} from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import getContactById from "@salesforce/apex/ContactController.getContactById";


export default class IADonorDetail extends LightningElement {

    //BindData;
    recordId ;
    @wire(CurrentPageReference) pageRef;
   // @track FirstName;
    contactDetail = [];

    
    connectedCallback() {
      // From workzone Component
      registerListener("searchContact", this.handleDonorSearch, this);
    }
    disconnectedCallback() {
      unregisterListener(this);
       // this.closeModal();
      }


    handleDonorSearch(searchKey_From_Other_Component) {
      
     getContactById(
        {
            recordId : searchKey_From_Other_Component, 
            //paymentGateway : selectPG            
        }
    )
    .then(result => {
      if(result.length > 0){
         
          alert(' :: true result ' +JSON.stringify(result[0]) );
          // this.isModalOpen = true;
          this.contactDetail = result[0];
          var title  = 'Success';
          var message = 'Data Fetch';
          var variant = 'success';
         // alert(' :: true data ' +JSON.stringify(this.contactDetail) );
      }
      else{
          alert(' :: false rsult ' + result);
          var title   = 'Error';
          var message = 'Cannot update'; 
          var variant = 'error';
      }
  
       this.dispatchEvent(
      
          new ShowToastEvent({
              title: title,
              message: message,
              variant: variant,
          }),
      );
  })
  
  .catch(error => {
     console.log(':: Error' +  error.message);
      this.dispatchEvent(
          new ShowToastEvent({
              title: 'Error in updating2222 ',
              message: 'Error22222',
              variant: 'error', 
          }),
      );
  }) 



     
    }


    // @wire(getContactById, { ConId:"$recordId"})
    // wiredResult(result) 
    // {
    //     this.RefreshData = result;

    //     if (result.error) {
    //         this.dispatchEvent(
    //           new ShowToastEvent({
    //             title: "Error In Getting Contact Details",
    //             message: result.error.body.message,
    //             variant: "error"
    //           })
    //         );
    //       //  this.SpinLoader = false;
    //       }
    //       else if (result.data){
    //        // if (result.data.length > 0) {
    //         this.contactDetail = result.data[0];
    //         //}
    //         console.log(":: result test"+ JSON.stringify(this.contactDetail));
    //       }
    //       else {
    //         this.dispatchEvent(
    //           new ShowToastEvent({
    //             title: "Information",
    //             message: "No Contact Found For This Id => " + this.recordId,
    //             variant: "info"
    //           })
    //         );
           
    //       }

    // }

}