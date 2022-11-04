// import { LightningElement } from 'lwc';


// export default class BikeCard extends LightningElement {

//    name = 'Electra X4';
//    description = 'A sweet bike built for comfort.';
//    category = 'Mountain';
//    material = 'Steel';
//    price = '$2,700';
//    pictureUrl = 'https://s3-us-west-1.amazonaws.com/sfdc-demo/ebikes/electrax4.jpg';

//    ready = false;
//    connectedCallback() {
//        setTimeout(() => {
//            this.ready = true;
//        }, 5000);
//    }
//  }

import { LightningElement, api } from 'lwc';
export default class Bike extends LightningElement {
    @api bike;
}