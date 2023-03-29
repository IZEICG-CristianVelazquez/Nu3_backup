public class FacturasScheduler implements Schedulable, Database.AllowsCallouts {
    public void execute(SchedulableContext sc){
        FacturaService.syncInvoicesSap();
    }
}