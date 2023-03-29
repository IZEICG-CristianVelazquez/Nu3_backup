public interface IRegistroChoferesPedidosSelector extends fflib_ISObjectSelector {
    List<Registro_Choferes_Pedidos__c> selectById(Set<ID> idSet);
    List<Registro_Choferes_Pedidos__c> selectAll (Integer recordLimit);
    List<Registro_Choferes_Pedidos__c> selectRCPWithRelatedData(String phone, String phoneComplete);
    List<Registro_Choferes_Pedidos__c> selectByIdWithRelatedData(Set<ID> idSet);
    List<Registro_Choferes_Pedidos__c> selectToControlRCP();
    Registro_Choferes_Pedidos__c selectByOrderIdRCP(String IdPedido);
}