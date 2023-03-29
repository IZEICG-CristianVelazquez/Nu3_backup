public with sharing class VisitasCheckinController {

    public static String visitaId {get;set;}

    public VisitasCheckinController(ApexPages.StandardController controller) {
        
        visitaId = controller.getRecord().Id;
    
    }

    // Hora Checkin Datetime = Fecha_y_hora_de_inicio__c
    // Hora Checkout Datetime = Fecha_y_hora_de_fin__c
    // Direccion Checkout Text Area 255 Direccion_Checkout__c
    // Direccion Checkin Text Area 255 Direccion_Checkin__c
    // Geolocation Geolocation Geolocalizaci_n__c

    @RemoteAction
    @AuraEnabled
    public static void addCheckIns(string recordId,decimal lat, decimal lng,string address) {

        System.debug('visitaId ' + visitaId);

        Visita__c visita = [SELECT Id, Fecha_y_hora_de_inicio__c, Fecha_y_hora_de_fin__c, Geolocalizaci_n__latitude__s, 
                            Geolocalizaci_n__longitude__s, Direccion_Checkin__c, Direccion_Checkout__c 
                            FROM Visita__c WHERE Id =: recordId ];
                            
        visita.Fecha_y_hora_de_inicio__c=system.now();
        visita.Geolocalizaci_n__latitude__s=lat;
        visita.Geolocalizaci_n__longitude__s=lng;
        
        visita.Direccion_Checkin__c=address;
        update visita;
    }
    
    @RemoteAction
    @AuraEnabled
    public static void addCheckOuts(string recordId,decimal lat, decimal lng,string address) {
        
        Visita__c visita = [SELECT Id, Fecha_y_hora_de_inicio__c, Fecha_y_hora_de_fin__c, Geolocalizaci_n__latitude__s, 
                            Geolocalizaci_n__longitude__s, Direccion_Checkin__c, Direccion_Checkout__c 
                            FROM Visita__c WHERE Id =: recordId];
        visita.Fecha_y_hora_de_fin__c=system.now();
        visita.Geolocalizaci_n__latitude__s=lat;
        visita.Geolocalizaci_n__longitude__s=lng;
    
        visita.Direccion_Checkout__c=address;
        update visita;
    }
    
}