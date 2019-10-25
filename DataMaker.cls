public with sharing class DataMaker {
    
    public static void MakeData() {
        DeleteData();
        CreateAccount();
        CreateContacts();
        CreateDoctors();
        CreateConditions();
        CreateSymptoms();
        CreateAppointments();
        CreateSpecialty();
    }
    
    public static void MakeSimpleData(){
        DeleteSimpleData();
        CreateAccount();
        CreateDoctors();
        CreateContacts();
        CreateConditions();
        CreateSymptoms();
        CreateAppointments();
        CreateSpecialty();
    }


private static void CreateAccount(){
    Account acct = new Account(Name='Patients');
    insert acct;
}


private static void CreateContacts(){
    List<Account> aId = [SELECT Id FROM Account WHERE Name='Patients' LIMIT 1];
    List<Contact> contactInsert = new List<Contact>();
    contactInsert.add(new Contact(FirstName='Andy',LastName='Warhol',Phone='0000000000',Email='awarhol@gmail.com',Birthdate= date.newInstance(1964,05,22),Gender__c='Male',AccountID=aId[0].Id));
    contactInsert.add(new Contact(FirstName='Frida',LastName='Kahlo',Phone='0000000000',Email='fkahlo@gmail.com',Birthdate= date.newInstance(1981,09,18),Gender__c='Female',AccountID=aId[0].Id));
    contactInsert.add(new Contact(FirstName='Salvador', LastName='Dali',Phone='0000000000',Email='explodinggiraffe@gmail.com',Birthdate= date.newInstance(1989,05,11),Gender__c='Male',AccountID=aId[0].Id));
    contactInsert.add(new Contact(FirstName='Francisco', LastName='Goya',Phone='0000000000',Email='fgoya@gmail.com',Birthdate=date.newInstance(1981,11,11), Gender__c='Male',AccountID=aId[0].Id));
    contactInsert.add(new Contact(FirstName='Mary Cassett', LastName='Cassett', Phone='0000000000',Email='mcassl@gmail.com',Birthdate=date.newInstance(1974,08,16), Gender__c='Female',AccountID=aId[0].Id));

    insert contactInsert;

}

private static void CreateDoctors(){
    List<Doctor__c> doctorInsert = new List<Doctor__c>();

    doctorInsert.add(new Doctor__c(Name='Elizabeth Blackwell',Phone__c='0000000000',Email__c='eblackwell@gmail.com', Gender__c='Female'));
    doctorInsert.add(new Doctor__c(Name='Benjamin Spock',Phone__c='0000000000',Email__c='llap@gmail.com', Gender__c='Male'));
    doctorInsert.add(new Doctor__c(Name='Anton Chekov',Phone__c='0000000000',Email__c='chekmeout@gmail.com', Gender__c='Male'));
    doctorInsert.add(new Doctor__c(Name='Virginia Apgar',Phone__c='0000000000',Email__c='awarhol@gmail.com', Gender__c='Female'));
    doctorInsert.add(new Doctor__c(Name='Helen Taussig',Phone__c='0000000000',Email__c='htau@gmail.com', Gender__c='Female'));

    insert doctorInsert;
}

private static void CreateConditions(){
    List<Condition__c> conditionInsert = new List<Condition__c>();

    conditionInsert.add(new Condition__c(Name='Hypertension', External_Id__c='500'));
    conditionInsert.add(new Condition__c(Name='Hyperlipidemia', External_Id__c='501'));
    conditionInsert.add(new Condition__c(Name='Diabetes', External_Id__c='502'));
    conditionInsert.add(new Condition__c(Name='Hypothyroidism', External_Id__c='503'));
    conditionInsert.add(new Condition__c(Name='Asthma', External_Id__c='504'));
    conditionInsert.add(new Condition__c(Name='Depressive Disorder', External_Id__c='505'));
    conditionInsert.add(new Condition__c(Name='Anxiety', External_Id__c='506'));
    conditionInsert.add(new Condition__c(Name='Osteoarthritis', External_Id__c='507'));

    insert conditionInsert;
}

private static void CreateSymptoms(){
    List<Symptom__c> symptomInsert = new List<Symptom__c>();

    symptomInsert.add(new Symptom__c(Name='Fever', External_Id__c='400'));
    symptomInsert.add(new Symptom__c(Name='Chills', External_Id__c='401'));
    symptomInsert.add(new Symptom__c(Name='Weight Loss', External_Id__c='402'));
    symptomInsert.add(new Symptom__c(Name='Chest Pain', External_Id__c='403'));
    symptomInsert.add(new Symptom__c(Name='Vomiting', External_Id__c='404'));
    
    insert symptomInsert;
}

//Every Doctor Assigned a random specialty
private static void CreateSpecialty(){
    List<Doctor__c> doctors = [SELECT Id FROM Doctor__c];
    List<Condition__c> conditions =[SELECT Id FROM Condition__c];
    List<Specialty__c> spectInsert = new List<Specialty__c>();
    for(Doctor__c doctor : doctors){
        spectInsert.add(new Specialty__c(Doctor__c=doctor.id,Condition__c=conditions[Integer.valueOf(Math.random()*conditions.size())].Id));
    }
    insert spectInsert;
}

//Each patient assigned 2 appointments between 2018-2021
private static void CreateAppointments(){
    List<Appointment__c> appointInsert = new List<Appointment__c>();
    List<Doctor__c> doctors = [SELECT Id FROM Doctor__c];
    List<Contact> patients =[SELECT Id FROM Contact];
    List<Condition__c> conditions = [SELECT Id FROM Condition__c];
    Integer countI=0;
    Integer countO=0;
    while(countO<2){
        while(counti<patients.size()){    
            Integer year = System.today().year()-1;
            Integer nextYear = system.today().year()+1;
            DateTime dt = DateTime.newInstance(randomDateFromYears(year,nextYear),System.now().time());
            appointInsert.add(new Appointment__c(Doctor__c=doctors[Integer.valueOf(Math.random()*doctors.size())].Id,Contact__c=patients[countI].Id, DateTime__c=dt,Condition__c=conditions[Integer.valueOf(Math.random()*conditions.size())].Id));   
            countI++;
        }
        countO++;
    }
    insert appointInsert;
}

//deletion methods

    public static void DeleteData(){
        DeleteAppointment();
        DeleteSpecialty();
        DeleteSymptom();
        DeleteCondition();
        DeleteDoctor();
    }
    
    public static void DeleteSimpleData(){
        DeleteDoctor();
        DeleteCondition();
        DeleteSymptom();
        DeleteAppointment();
        DeleteSpecialty();
    }

    //public static void DeleteAccount(){
    //    delete [SELECT Id from Account];
    //}

    //private static void DeleteContact(){
    //    delete [SELECT Id from Contact];
    //}

    public static void DeleteAppointment(){
        delete [SELECT Id FROM Appointment__c];
    }

    public static void DeleteSpecialty(){
        delete [SELECT Id FROM Specialty__c];
    }

    public static void DeleteSymptom(){
        delete [SELECT Id FROM Symptom__c];
    }

    public static void DeleteCondition(){
        delete [SELECT Id FROM Condition__c];
    }
    
    public static void DeleteDoctor(){
        delete [SELECT Id FROM Doctor__c];
    }


    private static Date randomDateFromYears(Integer startYear, Integer endYear) {
        return randomDate(Date.newInstance(startYear, 1, 1), Date.newInstance(endYear, 31, 12));
    }
    
    private static Date randomDate(Date min, Date max) {
    	DateTime mint = min, maxt = max.addDays(1);
    	Long minms = mint.getTime(), maxms = maxt.getTime(), diff = maxms - minms;
    	return DateTime.newInstance(minms + Math.mod(Math.abs(Crypto.getRandomLong()), diff)).date();
	}
}