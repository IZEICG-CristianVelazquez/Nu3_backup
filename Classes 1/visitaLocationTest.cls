@isTest
public with sharing class visitaLocationTest {
    
    
    public class Location{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled 
        public GeoLocation location{get;set;} 
    }
    public class GeoLocation{
        @AuraEnabled 
        public String Street{get;set;}
        @AuraEnabled 
        public String PostalCode{get;set;}
        @AuraEnabled 
        public String City{get;set;}
        @AuraEnabled 
        public String State{get;set;}
        @AuraEnabled 
        public String Country{get;set;}
        @AuraEnabled 
        public Decimal Latitude{get;set;}
        @AuraEnabled 
        public Decimal Longitude{get;set;}  
    }
    
    @isTest
    public static void testInit(){
     
    	//crear cliente
    	Account acc = new Account(Name='Poncho',
                                  Clave_cliente__c='NU32256350',
                                  Estatus_de_cuenta__c='Activo');
        insert acc;
        
    	System.debug('Id de Account insertado ----> '+acc.Id);
        // Crear Visita    
    	Visita__c vis = new Visita__c(Responsable__c = UserInfo.getUserId(),
                                      Cliente__c = acc.Id,
                                      Tipo_de_visita__c ='Venta',
                                      Estatus_de_visita__c ='Pendiente',
                                      Fecha_planeada__c = Date.newInstance(2019, 10, 1),
                                      Fecha_y_hora_de_inicio__c = DateTime.newInstance(2019, 10, 1, 13, 0, 0),
                                      Fecha_y_hora_de_fin__c =DateTime.newInstance(2019, 10, 1, 13, 30, 0),
                                      Geolocalizaci_n__latitude__s=37.790197,
                                      Geolocalizaci_n__longitude__s =-122.396879,
                                      Direccion_Checkin__c = 'Eje Metropolitano 9 955, Zona Santa Barbara, 66266 San Pedro Garza García, N.L., Mexico'
                                     );	
        insert vis;
        System.debug('visita creada---->'+vis);
        vis.Estatus_de_visita__c ='Realizada';
        update vis;
        System.debug('visita actualizada---->'+vis);
        visitaLocation.initMap();
        visitaLocation.getPickListValuesIntoList();
        Date myDate = Date.newInstance(2019, 06, 1);
        Date my2Date = Date.newInstance(2019, 11, 19);
       
     	visitaLocation.getVisitas('GP AVM', myDate, my2Date,UserInfo.getUserId(), 'https://gruponu3--dev.lightning.force.com/lightning/');   
    }   
}