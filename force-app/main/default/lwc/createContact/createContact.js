import { LightningElement,api } from 'lwc';

export default class CreateContact extends LightningElement {

    greeting = 'World';
  changeHandler(event) {
    this.greeting = event.target.value;
  }

  @api recordId;
  handleSubmit(event) {
      console.log('onsubmit event recordEditForm'+ event.detail.fields);
  }
  handleSuccess(event) {
      console.log('onsuccess event recordEditForm', event.detail.id);
  }



//   handleSuccess(event) {
//     console.log('onsuccess event recordEditForm',event.detail.id)
// }
// handleSubmit(event) {
//     console.log('onsubmit event recordEditForm'+ event.detail.fields);
// }



}