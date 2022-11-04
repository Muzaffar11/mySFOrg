import { LightningElement,api,track, } from 'lwc';

export default class ChildY extends LightningElement {

    @track trackParam = "Test Track";
    @api apiParam =  "api Value";
    noReactiveProp =  "noReactive Value";

    handleparamValues()
    {
        this.trackParam = "Change Track Property";
        this.apiParam = "change API Value";
        this.noReactiveProp = "Change no Recative Prop";

    }
}