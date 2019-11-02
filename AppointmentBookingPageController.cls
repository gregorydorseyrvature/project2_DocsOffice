public with sharing class AppointmentBookingPageController {

    Condition__c condition = new Condition__c();


   public List<String> DocId {get; set;}

   public List<String> DocName {get; set;}

   public List<String> DocEmail {get;set;}

   public List<Specialty__c> Doctors {get;set;}


   public static String appointmentDoc {get; set;}

   public static String appointmentDate{get; set;}




   public AppointmentBookingPageController(){

         DocId = new List<String>(); 

         DocName = new List<String>();
         Doctors = [SELECT Condition__r.Name,Doctor__c,Doctor__r.Name, Doctor__r.Email__c FROM Specialty__c];
         DocEmail = new List<String>();

         for (Integer i=0;i<Doctors.size();i++){
             System.debug(Doctors.size());
             DocId.add( (String) Doctors[i].Doctor__c);
             DocName.add( (String) Doctors[i].Doctor__r.Name);
             DocEmail.add( (String) Doctors[i].Doctor__r.Email__c);

         }

   }
   
    public static void bookAppointment2(){

        Id user = UserInfo.getUserId();
        
        List<String> DT = appointmentDate.split('T');
        String dates = DT[0];
        String times = DT[1];  

        Integer year = Integer.valueOf( dates.split('-')[0]);
        Integer month = Integer.valueOf(dates.split('-')[1]) ;
        Integer day = Integer.valueOf(dates.split('-')[2]) ;

        Integer hours = Integer.valueOf(times.split(':')[0]);
        Integer minutes = Integer.valueOf(times.split(':')[1]);

        DateTime appointmentDate2 = Datetime.newInstanceGmt(year, month, day, hours, minutes, 0);

        Appointment__c newAppointment = new Appointment__c(
            DateTime__c = appointmentDate2,
            Doctor__c = appointmentDoc,
            User__c = user
            );

        insert newAppointment;
        







        

        System.debug('Year: '+year);
        System.debug('Month: '+month);
        System.debug('Day: '+day);
        System.debug('Hour: '+hours);
        System.debug('Minute: '+minutes);

        System.debug('Final Date: '+appointmentDate2);






        // System.debug('Date: '+DT[0]);
        // System.debug('time: '+DT[1]);
        // System.debug('JavaScript Sent Me!');
        // System.debug('Date: '+ appointmentDate);
        // System.debug('Active User: '+user);

    }

}
