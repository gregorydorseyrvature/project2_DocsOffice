public class InfoPageExtension {
    
    public static String username{get;set;}
    
    private final User usr;
    
    public InfoPageExtension(ApexPages.StandardController stanControl) {
        this.usr = (User)stanControl.getRecord();
        username= UserInfo.getUserName();
    }
    
    public List<User> getUserInfo(){
        List<User> returnList  = [SELECT Age__c, Email, Phone, Name FROM User WHERE Id= :UserInfo.getUserID()];
        return returnList;
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
    
    public DateTime getEst(DateTime dt){
    	    
        return dt;
    }
   
   

}