import { LightningElement, api, wire } from "lwc";
import getRolesWhitoutAssignment from "@salesforce/apex/resourcesAllocation.getRolesWhitoutAssignment";

export default class AllocateRole extends LightningElement {
    @api recordId;
    rolesWithoutAssignment;

    @wire(getRolesWhitoutAssignment, { projectId: "$recordId" })
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