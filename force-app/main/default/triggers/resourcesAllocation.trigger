trigger resourcesAllocation on Project_Resources__c (before insert) {
    List <Project_Resources__c> resourcesRejected = resourcesAllocationTrigger.validateResources(Trigger.new);

    if (resourcesRejected.size()>0){
        for(Project_Resources__c rRejected : resourcesRejected){
            rRejected.addError(
                'You Can not Allocate the resource ' 
                + rRejected.User__c
                + ' on the indicated date ' 
                + rRejected.StartDate__c + ' - ' 
                + rRejected.EndDate__c);
        }
   }

}