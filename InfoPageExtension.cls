public class InfoPageExtension {
    
     private final User usr;
    
    public InfoPageExtension(ApexPages.StandardController stanControl) {
        this.usr = (User)stanControl.getRecord();
    }
    
    
    public List<Appointment__c> getNewAppointments(){
        List<Appointment__c> returnList = [SELECT DateTime__c,Doctor__r.name,User__c FROM Appointment__c 
                                          WHERE User__c = :UserInfo.getUserId() AND DateTime__c > TODAY];
		return returnList;        
    }

    public List<Appointment__c> getOldAppointments(){
        List<Appointment__c> returnList = [SELECT DateTime__c,Doctor__r.name,User__c FROM Appointment__c 
                                          WHERE User__c = :UserInfo.getUserId() AND DateTime__c < TODAY];
		return returnList;        
    }

}