/**
 * Created by gregd on 10/28/2019.
 */

public with sharing class infermedicaApiConsumerController {
    public List<wrapSymptom> wrapSymptomList { get; set; }
    public List<Symptom__c> selectedSymptoms { get; set; }
    public List<Conditions> value { get; set; }
    public Conditions cond {get;set;}
    public List<Conditions> conditionList { get; set; }
    public DiagnosisResponse results{get;set;}
    public List<User> use{get;set;}
    public Contact c { get; set; }
    public User tempUser {get;set;}
    public String condId {get;set;}


    public infermedicaApiConsumerController() {
        tempUser = new User();
        use = new List<User>();
        selectedSymptoms = [SELECT External_ID__c, Name FROM Symptom__c];
        if (wrapSymptomList == null) {
            wrapSymptomList = new List<wrapSymptom>();
            for (Symptom__c s : [SELECT External_ID__c, Name FROM Symptom__c]) {
                // As each Symptom is processed we create a new wrapSymptom object and add it to the wrapSymptomList
                wrapSymptomList.add(new wrapSymptom(s));
            }
        }
        use = [SELECT Id, FirstName, LastName, Gender__c, Age__c FROM User WHERE Id=:UserInfo.getUserId()];
        for(User u  : use){
            tempUser.Id = u.Id;
            tempUser.FirstName = u.FirstName;
            tempUser.LastName = u.LastName;
            tempUser.Gender__c = u.Gender__c;
            tempUser.Age__c = u.Age__c;
        }
    }
    public void selectSymptoms() {
        selectedSymptoms = new List<Symptom__c>();
        conditionList = new List<Conditions>();
        cond = new Conditions();
        for (wrapSymptom wrapSymptomObj : wrapSymptomList) {
            if (wrapSymptomObj.selected == true) {
                selectedSymptoms.add(wrapSymptomObj.symps);
            }
        }
        //call httpresponse method
        // desrialize response into a conditions object
        HttpResponse apiCall = Diagnose();
        results = (DiagnosisResponse) JSON.deserialize(apiCall.getBody(), DiagnosisResponse.class);
        value = results.conditions;
        cond = value[0];
        condId = cond.Id;
    }

    public PageReference bookAppointment(){
        //condition id
        String condName = ApexPages.currentPage().getParameters().get('conditionName');
        String url = 'https://project-2-developer-edition.na114.force.com/community/apex/AppointmentBookingPage?Condition=' + cond.name;
        PageReference pageRef = new PageReference(url);
        pageRef.setRedirect(false);
        return pageRef;
    }

    //This method is where I diagnose the patient
    //based on the symptoms they select.
    //Make the API call
    public HttpResponse Diagnose() {
        Diagnosis diag = new Diagnosis();
        //Grab Information from user object
        diag.sex = tempUser.Gender__c.toLowerCase();
        diag.age = (Integer)tempUser.Age__c;
        for (Symptom__c symp : selectedSymptoms) {
            Evidence newevi = new Evidence();
            newevi.id = symp.External_ID__c;
            newevi.choice_Id = 'present';
            diag.evidence.add(newevi);
        }
        String reqBody = JSON.serialize(diag);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        StaticResource appIdSR = [SELECT Body FROM StaticResource WHERE Name='InfermedicaAppId' LIMIT 1];
        String AppId = appIdSR.Body.toString();
        StaticResource appKeySR =  [SELECT Body FROM StaticResource WHERE Name='InfermedicaAppKey' LIMIT 1];
        String AppKey = appKeySR.Body.toString();
        request.setMethod('POST');
        request.setHeader('App-Id', AppId);
        request.setHeader('App-Key', AppKey);
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint('https://api.infermedica.com/v2/diagnosis');

        request.setBody(reqBody);
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            results = (DiagnosisResponse) JSON.deserialize(response.getBody(), DiagnosisResponse.class);
        }
        return response;
    }



    // This is our wrapper/container class. In this example a wrapper class contains
    // both the standard salesforce object Symptom and a Boolean value
    public class wrapSymptom {
        public Symptom__c symps { get; set; }
        public Boolean selected { get; set; }

        public wrapSymptom(Symptom__c s) {
            symps = s;
            selected = false;
        }
    }

    /**
Evidence {
id (string): id of observation or condition ,
choice_id (string) = 'present'
}
 */
    public class Evidence {
        public String id { get; set; }
        public String choice_id { get; set; }
    }
    /**
     Diagnosis{
     sex (String),
     age (Integer),
     evidence (List<Evidence>)
     }
     */
    public class Diagnosis {
        public String sex { get; set; }
        public Integer age { get; set; }
        public List<Evidence> evidence {
            get {
                if (evidence == null) {
                    evidence = new List<Evidence>();
                    return evidence;
                } else {
                    return evidence;
                }
            }
            set;
        }
    }
    /**
Conditions {
id (string),
name (string),
probability (Decimal)
}
 */
    public class Conditions {
        public String id { get; set; }
        public String name { get; set; }
        public Decimal probability { get; set; }
    }

    /**
     DiagnosisResponse{
        conditions (List<Conditions>)
     }
     */
    public class DiagnosisResponse {
        public List<Conditions> conditions { get; set; }
    }
}
