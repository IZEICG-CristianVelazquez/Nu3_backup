public with sharing class SchedulerActualizarclientes  implements Schedulable, Database.AllowsCallouts{
    private static Map<String,User> mapUsuariosByIdSap;
    private static Map<String,User> mapUsuariosByIdSap2;
    private static Map<String,User> mapUsuariosName;
    private static Map<String,Account> mapClientes;
    private static Map<String,Id> agenteSellerIdByExternalId; // Added By Oscar


    private static Map<String,List<Account>> mapIdSapClientes;

    public static void init(){
         mapUsuariosByIdSap = new Map<String,User>(); 
         mapUsuariosByIdSap2 = new Map<String,User>(); 
         mapUsuariosName = new Map<String,User>();         
         mapClientes = new Map<String,Account>(); 
         mapIdSapClientes = new Map<String,List<Account>>();

/*         for(Account acc: new AccountsSelector().selectRecentlyUpdated(10000)){
            if(acc.Clave_cliente__c != null){
                mapClientes.put(acc.Clave_cliente__c.toUpperCase(),acc);
            }

            if( String.isNotBlank(acc.Id_SAP__c) ) {

                if( mapIdSapClientes.containsKey(acc.Id_SAP__c) ) {
                    
                    mapIdSapClientes.get(acc.Id_SAP__c).add(acc);
                } else {

                    mapIdSapClientes.put(acc.Id_SAP__c, new List<Account>{acc} );
                }
            }
        } */

        for(User user:new UserSelector().selectAll(2000)){
            mapUsuariosName.put(user.Name,user);

            String referenciaIdSap = user.Base_de_datos__c+user.ID_SAP__c;
            mapUsuariosByIdSap.put(referenciaIdSap.toUpperCase(),user);

            if(user.ID_SAP_secundario__c != null){
                for(String id_sap_2:user.ID_SAP_secundario__c.split(' ')){
                    String referenciaIdSap2 = user.Base_de_datos__c+id_sap_2;
                    mapUsuariosByIdSap2.put(referenciaIdSap2.toUpperCase(),user);
                }
            }
        }
    }

    public static boolean checkEmailFormat(String mail){
        
    	if (String.isBlank(mail)) {return false;}
    
    	String regex = '\\b[\\w\\.-]+@[\\w\\.-]+\\.\\w{2,4}\\b';
    	Pattern MyPattern = Pattern.compile(regex);
    	Matcher MyMatcher = MyPattern.matcher(mail);
    
    	return MyMatcher.matches();
	}

    public static String firstEmailCorrect(String emails){
        
        String correctEmail;
        
        for(String email : emails.split(',')){
           
            if(checkEmailFormat(email)){
                correctEmail =  email;
                break;
            }
        }
        
    	return correctEmail;
	}
    
    public void execute (SchedulableContext sc) {

       processScheduler();
    }

    public static void getAccountsInDb(List<ClientesJSON.Clientes> clientes){

        Set<String> accountsToQuery = new Set<String>();
        Set<String> agentesExternalIds = new Set<String>();

        for (ClientesJSON.Clientes cliente : clientes) {
            accountsToQuery.add(Accounts.generateAccountKey(cliente.BusUnit.toUpperCase(), cliente.CardCode.toUpperCase()));
            agentesExternalIds.add(String.valueOf(cliente.SlpCode));
        }


        for(Account acc: new AccountsSelector().selectByExternalId(accountsToQuery,10000)){
            if(acc.Clave_cliente__c != null){
                mapClientes.put(acc.Clave_cliente__c.toUpperCase(),acc);
            }

            if( String.isNotBlank(acc.Id_SAP__c) ) {

                if( mapIdSapClientes.containsKey(acc.Id_SAP__c) ) {
                    
                    mapIdSapClientes.get(acc.Id_SAP__c).add(acc);
                } else {

                    mapIdSapClientes.put(acc.Id_SAP__c, new List<Account>{acc} );
                }
            }
        }

        getAgentes(agentesExternalIds);

    }

    private static void getAgentes(Set<String> agentesExternalIds){
        agenteSellerIdByExternalId = new Map<String,Id>();
        for(Agente__c agente : AgentesSelector.newInstance().selectByIdDeAgente(agentesExternalIds)){
            agenteSellerIdByExternalId.put(agente.ID_Base_de_Datos__c,agente.Vendedor__c);
        }
    }

    @future(callout=true) 
    public static void processScheduler () {
        System.debug('ejecutando scheduler...');

        try{

            
            MSObtenerClientes servicio = new MSObtenerClientes();
            ClientesJSON res = servicio.obtenerClientes();
            System.debug('respuesta del servicio'+res);
            System.debug('res.Clientes'+res.Clientes);



            if (res.Clientes != null) {
                init();
                
                //List<Account> lstAccUps = new List<Account>();
                Map<Id,Account> mapAccUps = new Map<Id, Account>();
                List<Account> lstAccIns = new List<Account>();
                
                getAccountsInDb(res.Clientes);
                
                for (ClientesJSON.Clientes cliente : res.Clientes) {
                
                    Account acc = new Account();
                    acc.ID_SAP__c = cliente.CardCode;
                    acc.Name = cliente.CardName;
                    acc.Razon_Social__c = cliente.CardName;
                    acc.ID_Agente__c = String.valueOf(cliente.SlpCode);
                    acc.Proyecto__c = cliente.ProjectCod;
                    acc.Estatus_de_cuenta__c = cliente.Activo=='Y'?'Activo':'Inactivo';
                    acc.Base_de_Datos__c = cliente.BusUnit;
                    String referencia = cliente.SlpCode+cliente.ProjectCod;
                    acc.Factor_flete__c = cliente.Flete;
                    acc.Tarifa_flete__c = cliente.Flete;
                    acc.Saldo_de_cliente__c = cliente.Balance;
                    acc.L_mite_de_cr_dito__c = cliente.CreditLine;
                    acc.Correo_electr_nico__c = firstEmailCorrect(cliente.Email);
                    
                    system.debug('Correo electrónico por Api: '+acc.Correo_electr_nico__c);
                    
                    String referenciaIdSap = cliente.BusUnit+cliente.SlpCode;

                    if(agenteSellerIdByExternalId.containsKey(String.valueOf(cliente.SlpCode))){

                        acc.OwnerId = agenteSellerIdByExternalId.get(String.valueOf(cliente.SlpCode));

                    } else{

                        if(mapUsuariosByIdSap.containsKey(referenciaIdSap.toUpperCase())){
                        
                            acc.OwnerId = mapUsuariosByIdSap.get(referenciaIdSap.toUpperCase()).Id;
                        
                        }else if(mapUsuariosByIdSap2.containsKey(referenciaIdSap.toUpperCase())){ 
                            
                            acc.OwnerId = mapUsuariosByIdSap2.get(referenciaIdSap.toUpperCase()).Id;
                        
                        }else{
                            system.debug('cliente.BusUnit------>'+cliente.BusUnit);
                            System.debug('cliente.BusUnit.toUpperCase()-------->'+cliente.BusUnit.toUpperCase());
                            System.debug('El mapa de usuarios contiene a raul?'+mapUsuariosName.containsKey('Raúl Mejía Castro'));
                            
                            if(cliente.BusUnit != null && cliente.BusUnit.toUpperCase() == 'NU3_CabNutres_Veracruz'.toUpperCase() && mapUsuariosName.containsKey('Administración de Ventas Veracruz')){
                            
                                acc.OwnerId = mapUsuariosName.get('Administración de Ventas Veracruz').Id;                        
                            
                            }else if(cliente.BusUnit != null && cliente.BusUnit.toUpperCase() == 'NU3_AgropecuariaPiedadense_LAGOS'.toUpperCase() && mapUsuariosName.containsKey('Administración de Ventas Lagos de Moreno')){
                                
                                acc.OwnerId = mapUsuariosName.get('Administración de Ventas Lagos de Moreno').Id; 
                            
                            }else if(cliente.BusUnit != null && (cliente.BusUnit.toUpperCase() == 'INPRO'.toUpperCase() || cliente.BusUnit.toUpperCase() == 'NU3_INPRO_Red'.toUpperCase()) && mapUsuariosName.containsKey('Raúl Mejía Castro')){
                            
                                acc.OwnerId = mapUsuariosName.get('Raúl Mejía Castro').Id;
                                
                                   System.debug('Nuevo OwnerId de la cuenta------>'+mapUsuariosName.get('Raúl Mejía Castro').Id);
                                   System.debug('cuenta con BusUnit '+cliente.BusUnit.toUpperCase()+' asignado a Raúl Mejía Castro');
                            
                            } else if(cliente.BusUnit != null && (cliente.BusUnit.toUpperCase() == 'NU3_GPBOUTIQUE'.toUpperCase() || cliente.BusUnit.toUpperCase() == 'NU3_GPBOUTIQUE_GUADALAJARA'.toUpperCase() 
                                    || cliente.BusUnit.toUpperCase() == 'NU3_GPBOUTIQUE_ZAMORA'.toUpperCase()) && mapUsuariosName.containsKey('Boutique GP')){
                                    
                                acc.OwnerId = mapUsuariosName.get('Boutique GP').Id;
                                    
                            } else{
                            
                                if(cliente.Grupo != null && cliente.Grupo > 0){
                                    
                                    if(cliente.Grupo == 104){
                                    
                                        if(mapUsuariosName.containsKey('Administración de Ventas GrandPet')){
                                            acc.OwnerId = mapUsuariosName.get('Administración de Ventas GrandPet').Id;
                                        }
                                        
                                    }else if(cliente.Grupo == 102){
                                        
                                        if(mapUsuariosName.containsKey('Miriam García')){
                                            acc.OwnerId = mapUsuariosName.get('Miriam García').Id;
                                        }
                                        
                                    }else if(cliente.Grupo == 103 || cliente.Grupo == 105 || cliente.Grupo == 106 || cliente.Grupo == 114){
                                        
                                        if(mapUsuariosName.containsKey('Administración de Ventas AB La Piedad')){
                                            acc.OwnerId = mapUsuariosName.get('Administración de Ventas AB La Piedad').Id;
                                        }
                                        
                                    }
                                }    
                            }
                        }
                    }
                                                    
                    acc.Lista_de_precios_SAP__c = cliente.ListNum;
                    if(cliente != null && cliente.Direcciones != null && !cliente.Direcciones.isEmpty()){
                        acc.BillingStreet = cliente.Direcciones.get(0).Street != null ? (cliente.Direcciones.get(0).Street.length() > 254 ? cliente.Direcciones.get(0).Street.substring(0,255) : cliente.Direcciones.get(0).Street) : '';
                        acc.BillingCity = cliente.Direcciones.get(0).City != null ? (cliente.Direcciones.get(0).City.length() > 39 ? cliente.Direcciones.get(0).City.substring(0,40) : cliente.Direcciones.get(0).City) : '';
                        acc.BillingState = cliente.Direcciones.get(0).State != null ? (cliente.Direcciones.get(0).State.length() > 79 ? cliente.Direcciones.get(0).State.substring(0,80) : cliente.Direcciones.get(0).State) : '';
                        acc.BillingPostalCode = cliente.Direcciones.get(0).ZipCode != null ? (cliente.Direcciones.get(0).ZipCode.length() > 19 ? cliente.Direcciones.get(0).ZipCode.substring(0,20) : cliente.Direcciones.get(0).ZipCode) : '';
                        acc.BillingCountry = cliente.Direcciones.get(0).Country != null ? (cliente.Direcciones.get(0).Country.length() > 79 ? cliente.Direcciones.get(0).Country.substring(0,80) : cliente.Direcciones.get(0).Country) : '';
                    
                    }
                    acc.RFC__c = cliente.LicTradNum;
                    acc.Phone = cliente.Phone;
                
                    if(String.isBlank(cliente.ClienteSalesForce) || cliente.ClienteSalesForce.length() < 15){
                        /* String clave = cliente.BusUnit.toUpperCase()+String.valueOf(cliente.SlpCode)+cliente.CardCode.toUpperCase(); */
                        String clave = Accounts.generateAccountKey(cliente.BusUnit.toUpperCase(), cliente.CardCode.toUpperCase()); // Added by Oscar
                        System.debug('CLAVE: '+clave);
                        if(mapClientes.containsKey(clave)){
                            acc.Id = mapClientes.get(clave).Id;
                            //lstAccUps.add(acc); 
                            mapAccUps.put(acc.Id, acc);
                        }else{
                            acc.Clave_cliente__c = clave;
                            lstAccIns.add(acc);
                        }
                    }else{
                        acc.Id = cliente.ClienteSalesForce;
                        //lstAccUps.add(acc);
                        mapAccUps.put(acc.Id, acc);
                    }
                
                    if( mapIdSapClientes.containsKey(cliente.CardCode) ) {
                    
                        for(Account accIdSap: mapIdSapClientes.get(cliente.CardCode)) {
                        
                            if( mapAccUps.containsKey(accIdSap.Id) ) {
                            
                                mapAccUps.get(accIdSap.Id).Estatus_de_cuenta__c = cliente.Activo == 'Y' ? 'Activo' : 'Inactivo';
                                mapAccUps.get(accIdSap.Id).Clave_cliente__c =  Accounts.generateAccountKey(cliente.BusUnit.toUpperCase(), cliente.CardCode.toUpperCase());

                            } else {
                                accIdSap.Estatus_de_cuenta__c = cliente.Activo == 'Y' ? 'Activo' : 'Inactivo';
                                accIdSap.Clave_cliente__c = Accounts.generateAccountKey(cliente.BusUnit.toUpperCase(), cliente.CardCode.toUpperCase());
                                mapAccUps.put(accIdSap.Id, accIdSap);
                            }
                        }
                    }
                
                
                }
                System.debug('Api Size =>'+res.Clientes.size());
                if(!lstAccIns.isEmpty()){
                    System.debug('Entro a insertar =>'+lstAccIns.size());
                    List<Database.SaveResult> saveResults = Database.insert(lstAccIns,false);
                    DMLUtils.processSaveResults(saveResults,true);
                }
            
                //System.debug('lstAccUps'+lstAccUps);
                System.debug('mapAccUps' + mapAccUps.values());
                if(!mapAccUps.isEmpty()){
                    System.debug('Entro a actualizar =>' + mapAccUps.size());
                    //List<Database.SaveResult> updateResults = Database.update(lstAccUps,false);
                    List<Database.SaveResult> updateResults = Database.update(mapAccUps.values(), false);
                    DMLUtils.processSaveResults(updateResults,true);
                }
                
                res = null;
            
            }

        } catch (Exception e){
            fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

            Error_Log__c errorLog = ErrorLog.log(e.getMessage(), e.getStackTraceString(), e.getLineNumber());
            errorLog.Integration__c = true;

            uow.registerNew(errorLog);
            uow.commitWork();
        }  
    }





}