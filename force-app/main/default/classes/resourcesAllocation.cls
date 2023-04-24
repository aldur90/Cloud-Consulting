public with sharing class resourcesAllocation {

 
  //List of the roles with pending time to be assigned
  @AuraEnabled(cacheable=true)
  public static List <Project_Line_Item__c> getRolesWhithoutAssignment (Id projectId) {
   List<Project_Line_Item__c> rolesWithoutAssignment =
                   [
                   SELECT Id, Role__c, HoursPending__c, HoursPerRole__c, HoursAllocated__c 
                   FROM Project_Line_Item__c 
                   WHERE Project__c = : projectId
                   AND HoursPending__c > 0     
                   ];
         
   return rolesWithoutAssignment; 
 }

 //List of available employees by role
 @AuraEnabled(cacheable=true)
 public static List <User> getAvailableEmployeesByRole (String roleName, String projectId){

   //Find the project
   Project__c project =
                   [
                   SELECT Id, Name, StartDate__c, EndDate__c, Amount__c
                   FROM Project__c
                   WHERE Id = : projectId
                   ];

   //Find available users for the project
   List <User> resources = 
                   [
                   SELECT Id , FirstName, LastName, UserRole.Name, Rate__c,
                   (
                       SELECT StartDate__c, EndDate__c, Project__c 
                       FROM Project_Resources__r
                       WHERE (StartDate__c >=: project.StartDate__c AND StartDate__c <=: project.EndDate__c)
                       OR (EndDate__c >=: project.StartDate__c AND EndDate__c <=: project.EndDate__c)
                   )
                   FROM User
                   WHERE UserRole.Name = : roleName
                   
                   ];
   
   //List for available resources
   List<User> availableResources = New List<User>();

   for (User user : resources){
       if(user.Project_Resources__r.isEmpty()){
           availableResources.add(user);
       }
   }
       
   return availableResources;    
 }

 @AuraEnabled(cacheable=true)
 public static List <Project_Line_Item__c> getHoursPendingByRole (Id projectId, String roleName) {
   List <Project_Line_Item__c> hoursPending = 
                   [
                   SELECT HoursPending__c
                   FROM Project_Line_Item__c
                   WHERE Project__c = : projectId
                   AND HoursPending__c > 0
                   AND Role__c = : roleName
                   ];
               
   return hoursPending; 
 }

 @AuraEnabled
 public static Boolean allocateResources(String allocationJSON){

   List<Project_Resources__c> projectResources = (List<Project_Resources__c>) JSON.deserialize(allocationJSON, List<Project_Resources__c>.class);
   
   insert projectResources;

   return true;
 }

}