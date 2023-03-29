public inherited sharing class FacturaService {

    /**
     * @description Implementacion de la Clase de Servicio ElementoService
     * @return   Implementacion del ElementoService
     */
    private static IFacturaService service() {
        return (IFacturaService) Application.Service.newInstance(IFacturaService.class);
    }

    @future(callout = true)
    public static void syncInvoicesSap() {

        service().syncInvoicesSap();
    }
}