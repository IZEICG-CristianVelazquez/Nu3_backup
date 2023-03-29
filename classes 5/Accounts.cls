public inherited sharing class Accounts extends fflib_SObjectDomain implements IAccounts {

    public static IAccounts newInstance(List<Account> recordList) {
		return (IAccounts) Application.Domain.newInstance(recordList);
	}
	
	public static IAccounts newInstance(Set<Id> recordIdSet) {
		return (IAccounts) Application.Domain.newInstance(recordIdSet);
	}

    public Accounts(List<Account> sObjectList){
       super(sObjectList);
    }
  
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> records){
            return new Accounts(records);
        }
    }

    public override void onBeforeInsert(){
        assignAccounteCode((List<Account>)this.Records);
    }

    public override void onBeforeUpdate(Map<Id, SObject> oldMap){
        assignAccounteCode((List<Account>)this.Records);
    }

    /** 
    * @description Genera la llave para la Cuenta
    *  @param  busUnit      Campo de SAP Base de Datos
    * @param  cardCode      Campos de SAP Id de Cuenta
    */
    public static String generateAccountKey(String busUnit, String cardCode) {

        String result = String.isNotBlank(busUnit) && String.isNotBlank(cardCode) ? busUnit.toUpperCase() + cardCode.toUpperCase() : ''; 

        return result;
    }

    private static void assignAccounteCode(List<Account> accountsList){
        for(Account acc : accountsList){
            if(String.isNotBlank(acc.ID_SAP__c)){
                acc.Clave_cliente__c = generateAccountKey(acc.Base_de_Datos__c, acc.ID_SAP__c);
            }
        }
    }

}