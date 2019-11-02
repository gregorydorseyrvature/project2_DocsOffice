public with sharing class welcomePageController {
    public Contact cont {get;set;}

     public PageReference goToAppointmentPage() {
        return Page.AppointmentBookingPage;
    }
    // public PageReference goToSymptomChecker(){
    //     return Page.SymptomCheckerPage;
    // }
}