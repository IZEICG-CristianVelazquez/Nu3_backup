public class visitaLocation { 
    @AuraEnabled
    public static List<Location> initMap() {
        
        
        List<Location> loc = new List<Location>();
        
        GeoLocation geoInfo = new GeoLocation();
        geoInfo.Street = 'Av. Manuel Gómez Morín 955, Montebello';
        geoInfo.PostalCode = '66273';
        geoInfo.City = 'Nuevo León';
        geoInfo.State = 'NL';
        geoInfo.Country = 'MX';
        Location locDetail = new Location();
        locDetail.icon = 'action:map'; 
        locDetail.title = 'Izei Consulting Group';
        locDetail.description ='Izei Consulting Group';
        locDetail.location = geoInfo;
        
        loc.add(locDetail);
        
        
        return loc ;
        
    }
    
    @AuraEnabled
    public static List<Location> getVisitas(String canal, date fechIn, date fechFin, String idResp, String URL) {
        List<Visita__c> visitas = new List<Visita__c>();
        System.debug('canal--->'+canal);
        System.debug('fechIn--->'+fechIn);
        System.debug('fechFin--->'+fechFin);
        System.debug('idResp--->'+idResp);
        System.debug('URL--->'+URL);
        
        String query ='Select Id,Name,Nombre_de_Visita_Texto__c,Cliente__r.Name,Responsable__c,Responsable__r.Id,Responsable__r.Name,Fecha_y_hora_de_inicio__c,Geolocalizaci_n__latitude__s,Geolocalizaci_n__longitude__s FROM Visita__c ';
        query +=' WHERE ';
        if(String.isNotBlank(idResp)){
            query += 'Responsable__r.Id = \''+idResp+'\' AND';
        }
        query +=' Responsable__r.pick_canal__c= \''+canal+'\' AND Geolocalizaci_n__longitude__s != Null AND Fecha_y_hora_de_inicio__c >=: fechIn AND Fecha_y_hora_de_inicio__c <=: fechFin Order by Fecha_y_hora_de_inicio__c desc     ';
        System.debug('Query----->'+query);
        visitas = Database.query(query);
        
        System.debug('visitas: '+visitas);
        
        List<Location> loc = new List<Location>();
        for(Visita__c visita :visitas){
            System.debug('visita en visitas---->'+visita);
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Latitude = visita.Geolocalizaci_n__latitude__s;
            geoInfo.Longitude = visita.Geolocalizaci_n__longitude__s;
            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = visita.Nombre_de_Visita_Texto__c;
            String currentURL = URL;
            System.debug('URL----->'+URL);
            locDetail.description = '<h3 style=\"color: skyblue;\">Responsable: </h3>'
                +visita.Responsable__r.Name
                +'<h3 style=\"color: skyblue;\">Cliente: </h3>'
                +visita.Cliente__r.Name
                +'<br><h3 style=\"color: skyblue;\">Fecha y hora de inicio: </h3>'
                +visita.Fecha_y_hora_de_inicio__c
                +'<br><div style=\'float: right;\'>'
                +'<a href=\"'+currentURL.substring(0,currentURL.length()-14)+'r/Visita__c/'+visita.Id+'/view \" target=\"_blank\" '
                +'style=\'color: skyblue; background-color: white; border: 0; border-radius: 2px; text-decoration:none;\'>'
                +'Visita'
                +'</a></div>';
            locDetail.location = geoInfo;
            
            loc.add(locDetail);
        }
        System.debug('locaciones:-----'+loc);
        return loc ;
    }
    
    
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
    
    @AuraEnabled   
    public static List<String> getPickListValuesIntoList(){
        // Lista donde se van a guardar los elementos del picklist
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = User.pick_canal__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        pickListValuesList.add('');
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        //Lista de elementos para el select
        System.debug(pickListValuesList);
        return pickListValuesList;
    } 
}