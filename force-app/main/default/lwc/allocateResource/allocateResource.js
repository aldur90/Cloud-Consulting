import { LightningElement, api, track, wire } from "lwc";
import getAvailableEmployeesByRole from "@salesforce/apex/resourcesAllocation.getAvailableEmployeesByRole";
import getHoursPendingByRole from "@salesforce/apex/resourcesAllocation.getHoursPendingByRole";
import allocateResources from "@salesforce/apex/resourcesAllocation.allocateResources";

/* 
* How to use lightning-datatable
https://developer.salesforce.com/docs/component-library/bundle/lightning-datatable/documentation

* How to use on save and draft
https://developer.salesforce.com/docs/component-library/documentation/en/lwc/lwc.data_table_inline_edit

*/

const columns = [
    { label: "Name", fieldName: "FirstName" },
    { label: "LastName", fieldName: "LastName" },
    { label: "Rate", fieldName: "Rate__c", type: "currency" },
    {
      label: "Start Date",
      fieldName: "startDate",
      type: "date-local",
      editable: true
    },
    {
      label: "End Date",
      fieldName: "endDate",
      type: "date-local",
      editable: true
    }
  ];

export default class AllocateResource extends LightningElement {

    saveDraftValues = [];
    @api role;
    @api recordId;
    @api columns = columns;

    @track resList;
    @wire(getAvailableEmployeesByRole, { roleName: "$role.Role__c", projectId: "$recordId" })
    resourceList(result, error) {
    this.resList = result;
    if (result.error) {
      this.resList = undefined;
    }
    }

    @api handleSave(event) {
      
      const inputsDates = JSON.stringify(
      event.detail.draftValues.slice().map((draft) => {
          let fields = {};
          fields.User__c = draft.Id;
          fields.Project__c = this.recordId;
          fields.Project_Line_Item__c = this.role.Id;
          fields.StartDate__c = draft.startDate;
          fields.EndDate__c = draft.endDate;
          
          return fields;
        })
      );

      console.log(inputsDates);
      allocateResources({ allocationJSON: inputsDates })
      .then((res) => {
        console.log("New Project Resource: " , res);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: res,
            variant: "success"
          })
        );
      })
      .catch((error) => {
        console.log(error);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error",
            message: "ERROR!! ",
            variant: "error"
          })
        );
      });
    }



    @track hoursPendingToAssign;
    @wire(getHoursPendingByRole, {
      projectId: "$recordId",
      roleName: "$role.Role__c"    
    })
    hoursPending(result, error) {
      if (result.data) {
        this.hoursPendingToAssign = result.data[0].HoursPending__c;
      } else if (error) {
        this.hoursPendingToAssign = undefined;
      }
    }
}