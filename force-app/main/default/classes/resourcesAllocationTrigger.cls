public with sharing class resourcesAllocationTrigger {

    public static List <Project_Resources__c> resourcesRejected = new List <Project_Resources__c>();
    public static List <Project_Resources__c> resourcesApproved = new List <Project_Resources__c>();

    public static List <Project_Resources__c> validateResources (List <Project_Resources__c> resourcesList ){
    
        //Create a Set Id of the resources
        Set <String> resourcesIds = new Set <String>();
        String projectId = resourcesList[0].Project__c;
        System.debug('Id del proyecto ' + projectId);
        for(Project_Resources__c rid : resourcesList){
            resourcesIds.add(rid.User__c);
        }

        //Find the project
        Project__c project =
        [
        SELECT StartDate__c, EndDate__c
        FROM Project__c
        WHERE Id = : projectId
        ];

        

        //Bring all the projects where the user is allocated
        List <Project_Resources__c> projectList = 
                            [
                            SELECT User__c, StartDate__c, EndDate__c
                            FROM Project_Resources__c
                            WHERE User__c IN : resourcesIds
                            ];

        Date projectStartDate = project.StartDate__c;
        Date projectEndDate = project.EndDate__c;

        System.debug('Inicio ' + projectStartDate + ' Fin ' + projectEndDate);

        //Inspect the Resource List of all the users that are going to be allocated
        for(Project_Resources__c prnew : resourcesList){
            Boolean available = true;

            if(prNew.StartDate__c < projectStartDate || prNew.EndDate__c > projectEndDate){
                resourcesRejected.add(prNew);
                available = false;
            } else {

                for(Project_Resources__c prold : projectList ){
                    if(prnew.User__c == prold.User__c){
                        Boolean validate = validateAvailability(prold,prnew);
                        if(!validate){
                            available = false;
                            break;
                        }
                    }
                }
            }
            //If there is no overlaping with another project add to the approved list
            if(available) resourcesApproved.add(prnew);
        }
        return resourcesRejected;
    }

    private static Boolean validateAvailability(Project_Resources__c prOld, Project_Resources__c prNew){
        Boolean validate = true;
          if (prNew.StartDate__c >= prOld.StartDate__c && prNew.StartDate__c <= prOld.EndDate__c) {
            resourcesRejected.add(prNew);
            validate = false;
          } else if(prNew.EndDate__c >= prOld.StartDate__c && prNew.EndDate__c <= prOld.EndDate__c) {
            resourcesRejected.add(prNew);
            validate = false;
          }
          return validate;
    }

}