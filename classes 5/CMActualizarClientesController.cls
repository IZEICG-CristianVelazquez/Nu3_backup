public with sharing class CMActualizarClientesController {

    @AuraEnabled
    public static Boolean actualizaClientes(){
        SchedulerActualizarclientes.processScheduler();

        return true;
    }


}