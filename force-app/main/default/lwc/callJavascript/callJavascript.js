import { LightningElement } from 'lwc';
import Test from "@salesforce/resourceUrl/Test";
import { loadScript } from "lightning/platformResourceLoader";
//import BearLogoURL from '@salesforce/resourceUrl/trailheadbadge';
import TrailHead_Image from '@salesforce/resourceUrl/TestImage';
import Image from '@salesforce/resourceUrl/Image';
//import utility from '@salesforce/resourceUrl/utility';


export default class CallJavascript extends LightningElement {

    salesforceBear   =  TrailHead_Image;
   // newImage =  Image;

   // newImage = Image + '/sun.jpg';
    spring20Logo = Image + '/sun.jpg';

    d3Initialized = false;

    renderedCallback() {
        if (this.d3Initialized) {
            return;
        }
        this.d3Initialized = true;

        Promise.all([
            loadScript(this, Test + '/cti-connector.js'),
           // loadStyle(this, D3 + '/style.css')
        ])
            .then(() => {
                alert("Hello World 9");
                alert("Hello World 8"+ Test);
                alert("property1 "+ property1 );
                alert("property2 "+ property2 );
                alert("property3 "+ Test.property2 );
                alert("property5 "+ this.property2 );
               // this.initializeD3();
            })
            .catch(error => {
                alert("Hello World 2"+ error);
                
            });
    }
}