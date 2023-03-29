public inherited sharing class Facturas extends fflib_SObjectDomain implements IFacturas {

   public static IFacturas newInstance(List<Factura__c> recordList) {
		return (IFacturas) Application.Domain.newInstance(recordList);
	}
	
	public static IFacturas newInstance(Set<Id> recordIdSet) {
		return (IFacturas) Application.Domain.newInstance(recordIdSet);
	}

    public Facturas(List<Factura__c> sObjectList){
       super(sObjectList);
    }
  
   public class Constructor implements fflib_SObjectDomain.IConstructable {
      public fflib_SObjectDomain construct(List<SObject> records){
         return new Facturas(records);
      }
   }

   public override void onAfterInsert(){
      updateAccountFields ((List<Factura__c>) this.Records);
   }

   public override void onBeforeInsert(){
      updateFacturaFields((List<Factura__c>)this.Records);
   }

      /**
   * Created By Oscar Medina
   * @description: Actualiza la fecha primer factura y la ultima fecha de la cuenta relacionada a la factura
   * 
   */
   public void updateAccountFields (List<Factura__c> facturasList){
      Set<Id> accountIds = new Set<Id>();
      fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

      for(Factura__c factura : facturasList){
          if(String.isnotBlank(factura.Nombre_de_la_Cuenta__c)){
              accountIds.add(factura.Nombre_de_la_Cuenta__c);
          }
      }

      Map<Id,Account> accountsById = new Map<Id,Account>(AccountsSelector.newInstance().selectById(accountIds));

      for(Factura__c factura : facturasList){
         if(String.isNotBlank(factura.Nombre_de_la_Cuenta__c) && factura.RecordTypeId == Constants.FACT_RT_FACTURA_ID){

            Account acc = accountsById.get(factura.Nombre_de_la_Cuenta__c);

            if(acc.Fecha_Primer_Factura__c == null){

               acc.Fecha_Primer_Factura__c = factura.Fecha_de_Facturaci_n__c;
               acc.Fecha_Ultima_Factura__c = acc.Fecha_Ultima_Factura__c == null ? 
                                             factura.Fecha_de_Facturaci_n__c : acc.Fecha_Ultima_Factura__c;
               uow.registerDirty(acc);

            } else if(acc.Fecha_Ultima_Factura__c < factura.Fecha_de_Facturaci_n__c 
                        || acc.Fecha_Ultima_Factura__c == null){

                  acc.Fecha_Ultima_Factura__c = factura.Fecha_de_Facturaci_n__c;
                  uow.registerDirty(acc);

            }
         }
      }

      uow.commitWork();
   }

   public void updateFacturaFields(List<Factura__c> facturasList){
      Set<Id> accountIds = new Set<Id>();

      for(Factura__c factura : facturasList){
         if(factura.Nombre_de_la_Cuenta__c != null){
            accountIds.add(factura.Nombre_de_la_Cuenta__c);
         }
         
      }

      Map<Id,Account> accountByIds = new Map<Id,Account>(AccountsSelector.newInstance().selectById(accountIds));

      for(Factura__c factura : facturasList){
         if(factura.Nombre_de_la_Cuenta__c != null){
            Account acc = accountByIds.get(factura.Nombre_de_la_Cuenta__c);
            factura.Correo_electr_nico__c = acc?.Correo_electr_nico__c;
            factura.Tel_fono__c = acc?.Phone;
         }
      }
   }



   /** 
   * @description Genera la llave para la Factura
   * @param  IdFacSap      Campo de SAP Id de Factura
   * @param  BusUnit       Campo de SAP Base de Datos
   * 
   */
   public static String generateFacturaKey(Integer IdFacSap, String BusUnit) {

      String result = IdFacSap != null && String.isNotBlank(busUnit) ? String.valueOf(IdFacSap) + BusUnit.toUpperCase(): '';

      return result;
   }


}