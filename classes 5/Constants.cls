public class Constants {

    // facturas
    public static final Id FACT_RT_FACTURA_ID = Schema.SObjectType.Factura__c.getRecordTypeInfosByName().get('Factura').getRecordTypeId();
    public static final Id FACT_RT_NOTACREDITO_ID = Schema.SObjectType.Factura__c.getRecordTypeInfosByDeveloperName().get('Nota_de_Cr_dito').getRecordTypeId();

    public static final Map<String, String> MAP_TIPO_UNIDAD = new Map<string, String>{
        '01' => 'Camioneta',
        '02' => 'Rabón',
        '03' => 'Torton',
        '04' => 'Trailer',
        '05' => 'Full'
    };

    public static final Map<String, String> MAP_ESTATUS_FACTURA = new Map<String, String>{
        'O' => 'Abierta',
        'C' => 'Cerrada'        
    };

    public static final String FACT_CANCELADA = 'Y';
    public static final String FACT_ERRORLOG_MSG = 'Error en la integración de facturas, se encontraron valores nulos en el JSON';
    //Permission Set
    public static final String PS_INTEGRATION_NAME = 'Usuario_de_integraci_n';

    // Accounts
    public static final Set<String> ACCOUNT_DATABASE_PICKLIST = new Set<String>{
        'NU3_AgropecuariaPiedadense_LAGOS','NU3_CabNutres_Veracruz'
    };
    public static final String ACCOUNT_DATABASE_LAGOS = 'NU3_AgropecuariaPiedadense_LAGOS';
    public static final String ACCOUNT_DATABASE_VERACRUZ = 'NU3_CabNutres_Veracruz';

    // Custom Notification
    public static final String CN_TITLE = 'Error en Integración';
    public static final String CN_BODY = 'Ocurrió un problema con la integración favor de revisar logs';

    // Orders
    public static Set<String> ORDER_STATUS = new Set<String>{'Entregado','Cancelado'};
}