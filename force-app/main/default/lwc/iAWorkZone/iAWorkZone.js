import { LightningElement, api, track, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import getContacts from "@salesforce/apex/AccountController.getContactsByName";
import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";

//For All PickList
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";

//Opportunity Fields
import LEADSOURCE from "@salesforce/schema/Opportunity.LeadSource";
//import PAYMENT_METHOD from "@salesforce/schema/Opportunity.Payment_Method__c";
import findRecords from "@salesforce/apex/AccountController.findRecords";

//Product Fields
import DONATION_TYPE from "@salesforce/schema/Product2.Donation_Type__c";
import GetAllPriceBookEnteriesByDonTypeAndCountry from "@salesforce/apex/AccountController.GetAllPriceBookEnteriesByDonTypeAndCountry";
import CreateDonation from "@salesforce/apex/AccountController.CreateDonation";
import GetDefaultProjects from "@salesforce/apex/AccountController.GetDefaultProjects";

let i = 0;
const COLUMNS = [
  { label: "ContactId", fieldName: "Id", type: "text" },
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Phone", fieldName: "Phone", type: "phone" }
];

export default class IAWorkZone extends LightningElement {
  data = [];
  @track isModalOpen = false;
  @api recordName;

  @track SelectedPaymentType;
  @track IsRequired = true;
  @wire(CurrentPageReference) pageRef;

  //Payment Information Templates
  @track ShowCardDetails = false;
  @track ShowDDDetails = false;
  @track ShowCAFDetails = false;
  @track ShowChequeDetails = false;
  @track ShowDefaultPGDetails = false;
  @track isDonorSelected = true;

  //For Showing Recurring Option in Card Donation
  //when Stripe is Activate)
  @track isWorldPayActive = false;
  @track txtIsRecurring = false;

  @track Amount = 0;
  @track DonorDetail = null;
  @track BatchId = null;
  @track SelectedPaidBy;
  @track SelectedDonationDate;
  @track Email;

   //Card Details
   @track CreditCardNumber;
   @track SelectedExpMonth;
   @track SelectedExpYear;


     //DD Details
  @track DDSortCode;
  @track DDAccNo;
  @track DDSelectedFrequency;
  @track DDSelectedDate;

  @wire(getObjectInfo, { objectApiName: "Opportunity" })
  Opportunity;

  @track PaidByOptions = [];
  @track items = []; //this will hold key, value pair
  @track value = ""; //initialize combo box value
  @track FAProgramOptions = [];
  @track SelectedPBE = "";
  @track chosenValue = "";
  @track DonationTypeOptions = [];

  //PriceBookEnteries
  @api AllPriceBookEnteries = [];
  @api DefaultProjects = [];
  @api SelectedFundAllocationId;
  @track FundAllocation_SNo = 1;
  @track FundAllocationList = [];

  @wire(getPicklistValues, {
    recordTypeId: "$Opportunity.data.defaultRecordTypeId",
    fieldApiName: LEADSOURCE
  })
  PaidByValues({ error, data }) {
    this.SpinLoader = true;
    // reset values to handle eg data provisioned then error provisioned
    //this.DonationTypeOptions = undefined;

    if (data) {
      this.PaidByOptions = data.values;
      this.SpinLoader = false;
    } else if (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error In Getting Donation Type Values",
          message: error.body.message,
          variant: "error"
        })
      );
      this.SpinLoader = false;
    }
  }

  @wire(findRecords)
  CampaignValues({ error, data }) {
    this.SpinLoader = true;
    // reset values to handle eg data provisioned then error provisioned

    if (data) {
      //create array with elements which has been retrieved controller
      //here value will be Id and label of combobox will be Name
      for (i = 0; i < data.length; i++) {
        this.items = [
          ...this.items,
          { value: data[i].Id, label: data[i].Name }
        ];
      }
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.contacts = undefined;
    }
  }

  @wire(getObjectInfo, { objectApiName: "Product2" })
  Product2;
  @wire(getPicklistValues, {
    recordTypeId: "$Product2.data.defaultRecordTypeId",
    fieldApiName: DONATION_TYPE
  })
  DonationTypeValues({ error, data }) {
    this.SpinLoader = true;
    // reset values to handle eg data provisioned then error provisioned
    if (data) {
     // alert("DonationType" + JSON.stringify(data.values));
      this.DonationTypeOptions = data.values;
      this.SpinLoader = false;
    } else if (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error In Getting Donation Type Values",
          message: error.body.message,
          variant: "error"
        })
      );
      this.SpinLoader = false;
    }
  }

  @wire(GetAllPriceBookEnteriesByDonTypeAndCountry, {
    ProjectCurrency: "PKR",
    DonationType: "Zakah"
  })
  ProgramValue({ error, data }) {
    this.SpinLoader = true;
    // reset values to handle eg data provisioned then error provisioned

    if (data) {
      //create array with elements which has been retrieved controller
      //here value will be Id and label of combobox will be Name
      for (i = 0; i < data.length; i++) {
        this.FAProgramOptions = [
          ...this.FAProgramOptions,
          { SelectedPBE: data[i].Id, label: data[i].Name }
        ];
      }
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.contacts = undefined;
    }
  }

  //  //gettter to return items which is mapped with options attribute
  //  get roleOptions() {
  //   return this.items;
  // }

  SetCurrencyForDD() {
    if (this.SelectedPaymentType == "Direct Debit") {
      this.SelectedCurrency = "GBP";

      if (this.template.querySelector('[data-id="txtCurrency"]'))
        this.template.querySelector('[data-id="txtCurrency"]').disabled = true;

      // this.UpdateFAOnCurrencyChange();
    } else {
      if (this.template.querySelector('[data-id="txtCurrency"]'))
        this.template.querySelector('[data-id="txtCurrency"]').disabled = false;
    }
  }

  //@api recordName;
  columns = COLUMNS;
  handleSearhClick() {
    getContacts({
      recordName: this.template.querySelector('[data-id="txtSearch"]').value
      //paymentGateway : selectPG
    })
      .then((result) => {
        if (result.length > 0) {
          //alert(' :: true result ' +result);
          this.isModalOpen = true;
          this.data = result;
          var title = "Success";
          var message = "Data Fetch";
          var variant = "success";
        } else {
          //alert(' :: false rsult ' + result);
          var title = "Error";
          var message = "Data do not exists";
          var variant = "error";
        }

        this.dispatchEvent(
          new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
          })
        );
      })

      .catch((error) => {
        console.log(":: Error" + error.message);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error in retriving Data",
            message: error.message,
            variant: "error"
          })
        );
      });

    console.log(
      ":: query selector " +
        this.template.querySelector('[data-id="txtSearch"]').value
    );
  }
  closeModal() {
    // to close modal set isModalOpen tarck value as false
    this.isModalOpen = false;
  }
  submitDetails() {
    // to close modal set isModalOpen tarck value as false
    //Add your code to call apex method or do some processing
    const selectedCon = this.template
      .querySelector("lightning-datatable")
      .getSelectedRows();
    fireEvent(this.pageRef, "searchContact", selectedCon[0].Id);
    this.isModalOpen = false;
  }

  get DisableDonorFields() {
    if (this.recordId && this.isComeFromEdit) return true;
    else return false;
  }

  get getCountry() {
    return [
      { label: "USA", value: "USA" },
      { label: "Pakistan", value: "s" },
      { label: "United Kingdom", value: "UK" },
      { label: "UAE", value: "UAE" }
    ];
  }

  get BatchPaymentMethods() {
    if (this.isComeFromEdit) {
      return [
        { label: "Card", value: "Card" },
        { label: "Direct Debit", value: "Direct Debit" },
        { label: "Bank Transfer", value: "Bank Transfer" },
        { label: "Paypal", value: "Paypal" },
        { label: "Paypal Monthly", value: "Paypal Monthly" }
      ];
    } else {
      return [
        { label: "Card", value: "Card" },
        { label: "Direct Debit", value: "Direct Debit" },
        { label: "Bank Transfer", value: "Bank Transfer" },
        { label: "Cheque", value: "Cheque" }
      ];
    }
  }

  get CurrencyOptions() {
    return [
      { label: "$", value: "USD" },
      { label: "£", value: "GBP" },
      { label: "€", value: "EUR" }
    ];
  }

  get ExpMonthOptions() {
    return [
      { label: "01", value: "01" },
      { label: "02", value: "02" },
      { label: "03", value: "03" },
      { label: "04", value: "04" },
      { label: "05", value: "05" },
      { label: "06", value: "06" },
      { label: "07", value: "07" },
      { label: "08", value: "08" },
      { label: "09", value: "09" },
      { label: "10", value: "10" },
      { label: "11", value: "11" },
      { label: "12", value: "12" }
    ];
  }

  get ExpYearOptions() {
    let YearOptions = [];
    let currentYear = new Date().getFullYear();

    for (let i = currentYear; i <= currentYear + 10; i++) {
      let NewValue = { label: i.toString(), value: i.toString() };
      YearOptions = [...YearOptions, NewValue];
    }

    return YearOptions;
  }

  // (For Dynamic Options)
  get DDFrequencyOptions() {
    return [
      { label: "Monthly", value: "Monthly" },
      { label: "Quarterly", value: "Quarterly" },
      { label: "Annually", value: "Annually" }
    ];
  }

  get paymentGatewayUsed() {
    let final = "";
    if (this.SelectedPaymentType == "Card") {
      if (this.isStripeActive) final = "Stripe";
      else if (this.isWorldPayActive) final = "WorldPay";
    }
    if (this.SelectedPaymentType == "Direct Debit") {
      if (this.isSmartDebitActive) final = "Smart Debit";
      else if (this.isGoCardlessActive) final = "GoCardless";
    }
    return final;
  }

  get DDDateOptions() {
    let DateOption = [];
    const currentDate = new Date();

    let DateList = [];

    //let DDHandshakeDate = currentDate.addDays(28);
    var DDHandshakeDate = new Date(currentDate);
    DDHandshakeDate.setDate(DDHandshakeDate.getDate() + 28);

    for (let i = DDHandshakeDate.getDate(); DateOption.length <= 3; i++) {
      var NextDate = new Date(
        DDHandshakeDate.setDate(DDHandshakeDate.getDate() + 1)
      );
      if (
        NextDate.getDate() == 1 ||
        NextDate.getDate() == 15 ||
        NextDate.getDate() == 25
      ) {
        let NewValue = {
          label: NextDate.toDateString(),
          value:
            NextDate.getDate() +
            "/" +
            (NextDate.getMonth() + 1) +
            "/" +
            NextDate.getFullYear()
        };
        DateOption = [...DateOption, NewValue];
        //alert('::NextDate::' + NextDate);
      }
    }
    return DateOption;
  }

  @api recordId;
  get isEditMode() {
    if (this.recordId) return true;
    else return false;
  }

  handleChange(event) {
    const field = event.target.name;

    if (field === "txtAmount") {
      // alert("Amount " + event.target.value);
      this.DonationAmount = event.target.value;
      if (this.FundAllocationList) {
        this.FundAllocationList[0].Amount = event.target.value;
      }
      // if (this.Amount) {
    //  this.Amount = event.target.value;
      //   }
    } else if (field === "cbPaymentType") {
      this.SelectedPaymentType = event.target.value;
      this.ShowHidePaymentInfoDivs();
      this.SetCurrencyForDD();
    } else if (field === "cbPaidBy") {
      this.SelectedPaidBy = event.target.value;
    } else if (field === "txtDonationDate") {
      this.SelectedDonationDate = event.target.value;
      // alert(this.SelectedDonationDate);
    } else if (field === "cbCampaign") {
      const selectedOption = event.detail.value;
      console.log("selected value=" + selectedOption);
      this.chosenValue = selectedOption;
      // this.SelectedCampaign = event.target.value;
      // alert(this.SelectedDonationDate);
    }

    // else if (field === "txtMobile") {
    //   this.MobileNumber = event.target.value;
    // } else if (field === "txtEmail") {
    //   this.Email = event.target.value;
    // }
    // //Credit Card Details
    // else if (field === "txtCardNumber") {
    //   this.CreditCardNumber = event.target.value;
    // } else if (field === "cbCCExpiryMonth") {
    //   this.SelectedExpMonth = event.target.value;
    // } else if (field === "cbCCExpiryYear") {
    //   this.SelectedExpYear = event.target.value;
    // }
    //Direct Debit Details
    // else if (field === "txtDDSortCode") {
    //   this.DDSortCode = event.target.value;
    // } else if (field === "txtDDAccNo") {
    //   this.DDAccNo = event.target.value;
    // } else if (field === "txtDDFrequency") {
    //   this.DDSelectedFrequency = event.target.value;
    // } else if (field === "txtDDDate") {
    //   this.DDSelectedDate = event.target.value;
    // }
    // //CAF Details
    // else if (field === "txtCAFNo") {
    //   this.CAFNo = event.target.value;
    // } else if (field === "txtCAFTrust") {
    //   this.CAFTrust = event.target.value;
    // }
    // //Cheque Details
    // else if (field === "txtChqNo") {
    //   this.ChqNo = event.target.value;
    // } else if (field === "txtChqSortCode") {
    //   this.ChqSortCode = event.target.value;
    // } else if (field === "txtChqAccNo") {
    //   this.ChqAccNo = event.target.value;
    // } else if (field === "txtChqAccTitle") {
    //   this.ChqAccTitle = event.target.value;
    // } else if (field === "txtCurrency") {
    //   this.SelectedCurrency = event.target.value;
    //   this.UpdateFAOnCurrencyChange();
    // } else if (field === "txtPostOptOut") {
    //   this.txtPostOptOut = event.target.checked;
    // } else if (field === "txtEmailOptOut") {
    //   //console.log('::name=' + event.target.name + '::value=' + event.target.checked);
    //   this.txtEmailOptOut = event.target.checked;
    // } else if (field === "txtSmsOptOut") {
    //   this.txtSmsOptOut = event.target.checked;
    // } else if (field === "txtReceiptOptOut") {
    //   this.txtReceiptOptOut = event.target.checked;
    // } else if (field === "txtEmail1") {
    //   this.txtEmail1 = event.target.value;
    // } else if (field === "txtMobile1") {
    //   this.txtMobile1 = event.target.value;
    // } else if (field === "txtEmail2") {
    //   this.txtEmail2 = event.target.value;
    // } else if (field === "txtMobile2") {
    //   this.txtMobile2 = event.target.value;
    // } else if (field === "txtEmail3") {
    //   this.txtEmail3 = event.target.value;
    // } else if (field === "txtMobile3") {
    //   this.txtMobile3 = event.target.value;
    // }
    // //New Work Sherbaz-24-Nov-2020
    // else if (field == "txtIsRecurring") {
    //   this.txtIsRecurring = event.target.checked;
    // }
  }

  ShowHidePaymentInfoDivs() {
    this.ShowDDDetails = false;
    this.ShowCardDetails = false;
    this.ShowChequeDetails = false;
    this.ShowCAFDetails = false;
    this.ShowDefaultPGDetails = false;

    if (this.SelectedPaymentType == "Card") {
      this.ShowCardDetails = true;
    } else if (this.SelectedPaymentType == "Direct Debit") {
      this.ShowDDDetails = true;
    } else if (this.SelectedPaymentType == "Cheque") {
      this.ShowChequeDetails = true;
    } else if (this.SelectedPaymentType == "CAF Vouchers") {
      this.ShowCAFDetails = true;
    } else {
      this.ShowDefaultPGDetails = true;
    }
  }

  Process_Card_DD() {
    alert("Process Card start");
   // let isError = this.ValidateInputs();
   // if (!isError) {
      //alert("Process Card");
      this.CreateDonation();
    //}
  }

  handleAmountBlur(event) {
    //console.log(":: event"+event);
    if (event.target.value) {
      let txtId = '[data-id="' + event.target.dataset.id + '"]';
      let amount = event.target.value;
      this.template.querySelector(txtId).value = parseFloat(amount).toFixed(2);

      //New Work 21 May, 2020
      this.DonationAmount = parseFloat(amount).toFixed(2);

      if (this.Amount) {
        this.Amount = parseFloat(this.Amount).toFixed(2);
      }
    }
  }

  handleOnchange(event) {
    alert(":: event" + event);
    //event.preventDefault();
    const searchKey = event.detail;
    //alert('In Main Component => ' +searchKey);
    //this.records = null;
    /* eslint-disable no-console */
    //console.log(searchKey);

    /* Call the Salesforce Apex class method to find the Records */
    if (searchKey.length >= 4) {
      findRecords({
        searchKey: searchKey
      })
        .then((result) => {
          console.log(" result ", JSON.stringify(result));
          this.records = result;
          for (let i = 0; i < this.records.length; i++) {
            const rec = this.records[i];
            this.records[i].Name = rec["name"];
          }
          this.error = undefined;
          console.log(" records ", this.records);
        })
        .catch((error) => {
          this.error = error;
          this.records = undefined;
        });
    } else {
      this.records = undefined;
    }
  }

  handleCampaignSelectedNew(event) {
    if (event.detail) {
      //alert('Detail');
      //We Are Using IF CONDITION (FOR CAMPAIGN DESELECT)
      if (event.detail.record) {
        //alert('Select');
        this.CampaignSelected = true;
        this.CampaignInfo = event.detail.record.Name;
        this.SelectedCampaignId = event.detail.record.Id;

        //this.CampaignInfo       = this.CampignDetails.Name;
        //this.CampaignSelected    = true;
      } else {
        //alert('Deselect');
        this.CampaignSelected = false;
        this.CampaignInfo = "";
        this.SelectedCampaignId = null;

        //this.CampaignInfo       = undefined;
        //this.CampaignSelected    = false;
      }
      //alert(this.CampignDetails.Id);
    }
  }

  fundAlloc_HandleChange(event) {
    try {
      let FundAllocationId = event.target.dataset.id;
      const field = event.target.name;

      console.log("::FundAllocationId::" + FundAllocationId);
      console.log("::field::" + field);
      console.log("::event.target.value::" + event.target.value);
    } catch (err) {
      console.log("::err.message::" + err.message);
    }
  }

  SaveDonation() {
    //let isError = this.ValidateInputs();
   //c/contactCreator if (!isError) {
     // if (!this.isComeFromEdit) {
        // if (
        //   (this.SelectedPaymentType == "Card" ||
        //     this.SelectedPaymentType == "Direct Debit") &&
        //   !this.isCard_DD_Processed
        // ) {
        //   this.dispatchEvent(
        //     new ShowToastEvent({
        //       title: "Error",
        //       message: "Please Process Card/DD First",
        //       variant: "error"
        //     })
        //   );
        //   isError = true;
       // }
    //  }

    //  if (!isError) {
        if (this.recordId) {
          this.UpdateDonation();
        } else {
          this.CreateDonation();
        }
     // }
   // }
  }


  CreateDonation() {
    this.SpinLoader = true;
    alert("Create Donation111");
    let testParam = {
      // DonorContactId: this.DonorId,
      // DonorAccountId: this.DonorDetail.AccountId,
     // BatchId: this.BatchId,
      SelectedCurrency: this.SelectedCurrency,
      DonationAmount: this.DonationAmount,
      SelectedPaymentType: this.SelectedPaymentType,
      SelectedCampaignId: this.SelectedCampaignId,
      SelectedPaidBy: this.SelectedPaidBy,
      SelectedDonationDate: this.SelectedDonationDate,
     // MobileNumber: this.MobileNumber,
     // Email: this.Email,
      CreditCardNumber: this.CreditCardNumber,
      SelectedExpMonth: this.SelectedExpMonth,
      SelectedExpYear: this.SelectedExpYear,
      // DDSortCode: this.DDSortCode,
      // DDAccNo: this.DDAccNo,
      // DDSelectedFrequency: this.DDSelectedFrequency,
      // DDSelectedDate: this.DDSelectedDate,
      // CAFNo: this.CAFNo,
      // CAFTrust: this.CAFTrust,
      // ChqNo: this.ChqNo,
      // ChqSortCode: this.ChqSortCode,
      // ChqAccNo: this.ChqAccNo,
      // ChqAccTitle: this.ChqAccTitle,
      // txtPostOptOut: this.txtPostOptOut,
      // txtEmailOptOut: this.txtEmailOptOut,
      // txtReceiptOptOut: this.txtReceiptOptOut,
      // txtSmsOptOut: this.txtSmsOptOut,
      // txtEmail1: this.txtEmail1,
      // txtEmail2: this.txtEmail2,
      // txtEmail3: this.txtEmail3,
      // txtMobile1: this.txtMobile1,
      // txtMobile2: this.txtMobile2,
      // txtMobile3: this.txtMobile3,
     // isRecurring: this.txtIsRecurring,
      paymentGatewayUsed: this.paymentGatewayUsed
    };

 console.log('Parameters '+ JSON.stringify(testParam));
    CreateDonation({
      AllDonationFieldMap: testParam,
      FundAllocationMap: this.FundAllocationList
    })
    .then(result => {
      alert(result.isError +'Result Data' + JSON.stringify(result));
    //  alert(result['isError'] + result['ErrorMessage']);
      if (result.isError == "true") {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error In Creating Donation",
            message: result.Message,
            variant: "error",
            mode: "sticky"
          })
        );
        this.SpinLoader = false;
      } else {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Donation created Successfully",
            message: result.Message,
            variant: "success"
          })
        );

        if (
          this.SelectedPaymentType == "Card" ||
          this.SelectedPaymentType == "Direct Debit"
        ) {
          this.recordId = result.DonationId;
          //alert(this.recordId);
          this.isCard_DD_Processed = true;
          console.log("::recordId::" + this.recordId);
        } else {
          this.RefreshDonationForm();
          this.RefreshDonorDetails();
          this.RefreshFundAllocations();
        }
        this.SpinLoader = false;
      }
      alert(result);
      //this.SpinLoader = false;
    })
    .catch(error => {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error In Creating Donation",
          message: error.body.message,
          variant: "error",
          mode: "sticky"
        })
      );
      this.SpinLoader = false;
    });
}


handleFAAddClick() {
alert("Invoke ");
  this.getDefaultFundAllocation(true, 0);
}
    // ********************  Fund Allocation *********** //
getDefaultFundAllocation(ShowDeleteButton, DefaultAmount) {
  let DefaultDonationType = "";
  let DefaultCountry = "";
  let DefaultProject = "";
  let DefaultProjectInfo = "";
  alert('::DefaultProject::' + JSON.stringify(this.DefaultProjects));
  this.DefaultProjects.forEach(ele => {
    console.log("::ele.CurrencyISOCode::" + ele.CurrencyIsoCode);
    if (ele.CurrencyIsoCode == this.SelectedCurrency) {
      console.log("::ele.CurrencyISOCode::" + ele.CurrencyIsoCode);
      DefaultDonationType = ele.Product2.Donation_Type__c;
      DefaultCountry = ele.Product2.Country__c;
      DefaultProject = ele.Id;
      DefaultProjectInfo = ele.Product2.Project_Info__c;
    }
  });

  if (this.FundAllocation_SNo) this.FundAllocation_SNo++;
  else this.FundAllocation_SNo = 1;

  let NewAllocation = {
    SNo: this.FundAllocation_SNo,
    Amount: "", //DefaultAmount.toString(),
    OnBehalfOf: "",
    ShowAdd: "",
    ShowDelete: ShowDeleteButton,
    SelectedDonationType: DefaultDonationType,
    //FACountryOptions : this.getCountriesByDonationType(DefaultDonationType, SerialNumber),
    FACountryOptions: [],
    SelectedCountry: DefaultCountry,
    //FAProgramOptions : this.getProgramsByTypeAndCountry(DefaultDonationType, DefaultCountry, SerialNumber),
    FAProgramOptions: [],
    SelectedPBE: DefaultProject,
    ProjectInfo: DefaultProjectInfo
  };

  this.FundAllocationList = [...this.FundAllocationList, NewAllocation];

  // this.getCountriesByDonationType(
  //   DefaultDonationType,
  //   this.FundAllocationList.length - 1
  // );
  // this.getProgramsByTypeAndCountry(
  //   DefaultDonationType,
  //   DefaultCountry,
  //   this.FundAllocationList.length - 1
  // );

  //For Drop Downs

  //return NewAllocation;
}

handleFADeleteClick(event) {
  let deletedId = event.target.dataset.id;

  let indexValue = this.FundAllocationList.findIndex(
    ids => ids.SNo == deletedId
  );
  this.FundAllocationList.splice(indexValue, 1);
  alert(deletedId);
}

@wire(GetDefaultProjects)
  PBEWireMethod(result) {
    if (result.data) {
      if (result.data.length > 0) {
        this.DefaultProjects = result.data;
        //alert(JSON.stringify(this.DefaultProjects));
        this.getDefaultFundAllocation(false, 0);
      }
    } else if (result.error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error In Getting Default Product",
          message: result.error,
          variant: "error"
        })
      );
      //this.SpinLoader = false;
    }
  }



}