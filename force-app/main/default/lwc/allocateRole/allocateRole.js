import { LightningElement, api, wire } from "lwc";
import getRolesWhithoutAssignment from "@salesforce/apex/resourcesAllocation.getRolesWhithoutAssignment";
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import STARTDATE_FIELD from '@salesforce/schema/Project__c.StartDate__c';
import ENDDATE_FIELD from '@salesforce/schema/Project__c.EndDate__c';

const fields = [STARTDATE_FIELD, ENDDATE_FIELD];

export default class AllocateRole extends LightningElement {
    @api recordId;
    rolesWithoutAssignment;

    @wire(getRecord, { recordId: '$recordId', fields })
    project;

    get startDate() {
      return getFieldValue(this.project.data, STARTDATE_FIELD);
  }

  get endDate() {
      return getFieldValue(this.project.data, ENDDATE_FIELD);
  }

    @wire(getRolesWhithoutAssignment, { projectId: "$recordId" })
    roles(result, error) {
    if (result) {
      this.rolesWithoutAssignment = result;
      console.log(
        "RolesWhitoutAssignment are: ",
        this.rolesWithoutAssignment
      );
    } else if (error) {
      this.rolesWithoutAssignment = undefined;
      
    }
  }

}