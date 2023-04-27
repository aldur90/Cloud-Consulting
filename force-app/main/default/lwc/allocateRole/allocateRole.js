import { LightningElement, api, wire } from "lwc";
import getRolesWhithoutAssignment from "@salesforce/apex/resourcesAllocation.getRolesWhithoutAssignment";

export default class AllocateRole extends LightningElement {
    @api recordId;
    rolesWithoutAssignment;

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