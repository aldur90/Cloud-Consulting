public with sharing class allocateResources {
    @AuraEnabled(cacheable=true)
    public static Map<string, List<user>> availableResourcesPerRole(Id recordId) {
    
    //Project dates
    Project__c dates = [
                        SELECT StartDate__c,
                        EndDate__c
                        FROM Project__c
                        WHERE Project__c.Id =: recordId
                        ];

    //Look for not available resources
    List<Project_Resources__c> notAvailableResources = 
                        [
                        SELECT User__c
                        FROM Project_Resources__c
                        WHERE (StartDate__c = NULL OR EndDate__c = NULL)
                        OR (StartDate__c <= : dates.EndDate__c)
                        OR (EndDate__c <= : dates.StartDate__c)
                        ];

    //Set Id of available project resources
    Set<Id> notAvailableResourceId = New Set<Id>();
    for (Project_Resources__c nar : notAvailableResources){
        notAvailableResourceId.add(nar.User__c);
    }

    //Determines which roles the project has sold
    List<Project_Line_Item__c> projectRoles =
                        [
                        SELECT Role__c, HoursPerRole__c
                        FROM Project_Line_Item__c
                        WHERE Project__r.Id =: recordId
                        ORDER BY Role__c ASC
                        ];

    //Set string of project roles
    Set<String> pRoles = New Set<String>();
    for(Project_Line_Item__c pr : projectRoles){
        pRoles.add(pr.Role__c);
    }

    //List of available employees
    List<User> availableEmployee =
                        [
                        SELECT FirstName, LastName, UserRole.Name, Rate__c
                        FROM User
                        WHERE User.Id NOT IN : notAvailableResourceId
                        AND UserRole.Name IN : pRoles
                        ORDER BY UserRole.Name ASC
                        ];

    //Map of available resources by role
    Map<String, List<User>> availableEmployeesPerRole = New Map<String, List<User>>();

        //Create a key per role in the project
        for (Project_Line_Item__c pr : projectRoles){
            if(!availableEmployeesPerRole.containsKey(pr.Role__c)){
                availableEmployeesPerRole.put(pr.Role__c, New List<User>());
            }
        }

        //Add employees on the Map according to the role
        for (User employee : availableEmployee){
            availableEmployeesPerRole.get(employee.UserRole.Name).add(employee);
        }

        return availableEmployeesPerRole;     


    }

}