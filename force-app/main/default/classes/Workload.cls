public class Workload {
    
	@AuraEnabled(cacheable=true)
    public static list<Task__c> getTask (Id projectResourceId){
        List<Task__c> tasks= [SELECT Id,
                                      Status__c,
                                      Description__c,
                                      StartDate__c,
                                      EndDate__c,
                                      EstimatedHours__c,
                                      WorkedHours__c,
                              			Project_Resource__c
                                FROM Task__c
                                WHERE Project_Resource__c =: projectResourceId
                             	ORDER BY Project_Resource__c];
        System.debug('task ' + tasks.get(0).Description__c);
        return tasks;
    } 
    
    @AuraEnabled(cacheable=false)
    public static Task__c updateWorkedHours (Id taskId, Boolean completed, Integer workedHours){
        system.debug(taskId);
        Task__c task = [SELECT Id,
                                Status__c,
                                Description__c,
                                StartDate__c,
                                EndDate__c,
                                EstimatedHours__c,
                                WorkedHours__c,
                                Project_Resource__c
                        FROM Task__c
                       	WHERE Id =: taskId];

                           system.debug(task);
        if(completed){
            task.Status__c = 'Completed';
        }else{
            task.Status__c = 'In Progress';
        }

        system.debug('Status ' + task.Status__c);
        system.debug(task);
        system.debug('Worked ' + workedHours);
        system.debug('Worked ' + task.WorkedHours__c);
        //task.Status__c = completed == true ? 'Completed': 'In Progress';
        //if(task.WorkedHours__c == NULL) task.WorkedHours__c =0;
        task.WorkedHours__c += workedHours;

        
        
        update task;
        
        return task;
    }
}