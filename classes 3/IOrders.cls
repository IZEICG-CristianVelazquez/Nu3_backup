public interface IOrders {
    void modificarCamposOrderItems(fflib_SObjectUnitOfWork uow,Map<Id,SObject> existingRecords, List<Order> orderList);
    void crearDetalleDeEncuestas(fflib_SObjectUnitOfWork uow,Map<Id,SObject> existingRecords,Set<Id> orderIds);
    void updateDocumentSerieField(List<Order> ordersList);
}