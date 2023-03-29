trigger OrderItemTrigger on OrderItem (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    System.debug('entra a trigger');
    fflib_SObjectDomain.triggerHandler(OrderItems.class);


}