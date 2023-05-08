@isTest
public class StartProjectManuallyTest {
    static testMethod void validateTrigger() {
		Project__c sinSquad = new Project__c(Name='Project Test 1', StartDate__c=Date.today(), Status__c='Pre Kickoff',
                                             Amount__c=5000, ProjectManager__c= '005Dp000001WLkRIAW', QuantityHours__c= 10);
        
        Project__c proyecto2 = new Project__c(Name='Project Test 2', StartDate__c=Date.today(), Status__c='Pre Kickoff',
                                             Amount__c=1, ProjectManager__c= '005Dp000001WLkRIAW', 	SquadLead__c= '005Dp000001WLkRIAW',  QuantityHours__c= 10);
        
        Project_Resources__c pr1 = new Project_Resources__c (Project__c= sinSquad.Id, 	Rate_Per_Hours_Num__c= 10,	RequieredHours__c = 20);
        Project_Resources__c pr2 = new Project_Resources__c (Project__c= proyecto2.Id, 	Rate_Per_Hours_Num__c= 10,	RequieredHours__c = 20);
        
        
        
        
        
   }
}