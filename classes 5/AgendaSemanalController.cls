public with sharing class AgendaSemanalController {
    


    public class AgendaWrapper {

        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Cliente;
        @AuraEnabled
        public String Municipio;
        @AuraEnabled
        public String Estado;
        @AuraEnabled
        public Integer IndicadorVisita;
        @AuraEnabled
        public Date FechaPlaneada;

        public AgendaWrapper (String Id, String Cliente, String Municipio, String Estado, Integer IndicadorVisita, Date FechaPlaneada) {

            this.Id = Id;
            this.Cliente = Cliente;
            this.Municipio = Municipio;
            this.Estado = Estado;
            this.IndicadorVisita = IndicadorVisita;
            this.FechaPlaneada = FechaPlaneada;

        }

        public AgendaWrapper () {

        }

    }

    public static Map<String, List<Visita__c>> obtenerVisitasMesCliente () {

        Map<String, List<Visita__c>> mapVisitasCuenta = new Map<String, List<Visita__c>>();

        for (Visita__c visita : new VisitasSelector().selectCreatedThisMonth()) {

            if (String.isNotBlank(visita.Cliente__c)) {

                if (mapVisitasCuenta.containsKey(visita.Cliente__c)) {

                    mapVisitasCuenta.get(visita.Cliente__c).add(visita);

                } else {

                    mapVisitasCuenta.put(visita.Cliente__c, new List<Visita__c>{visita});

                }
            }

        }

        return mapVisitasCuenta;
        
    }

    private static Integer obtenerIndicadorVisita (Account a, Map<String, List<Visita__c>> mapVisitasCuenta) {

        Integer indicadorVisita = 0;

        if (String.isNotBlank(a.Frecuencia_mensual_de_visitas__c) && a.Frecuencia_mensual_de_visitas__c.isNumeric()) {

            Integer frecuencia = Integer.valueOf(a.Frecuencia_mensual_de_visitas__c);
            Integer cantidadVisitas = 0;

            if (mapVisitasCuenta.containsKey(a.Id)) {

                cantidadVisitas = mapVisitasCuenta.get(a.Id).size();
                Visita__c visitaReciente;

                Datetime fechaReciente;

                for (Visita__c visita : mapVisitasCuenta.get(a.Id)) {

                    if (fechaReciente == null) {

                        fechaReciente = visita.Fecha_y_hora_de_inicio__c;
                        visitaReciente = visita;

                    } else if (fechaReciente > visita.Fecha_y_hora_de_inicio__c) {

                        fechaReciente = visita.Fecha_y_hora_de_inicio__c;
                        visitaReciente = visita;

                    }

                }

                if (visitaReciente.Fecha_y_hora_de_inicio__c != null) { 

                    Datetime semanaVisita = visitaReciente.Fecha_y_hora_de_inicio__c; 
                    Datetime semanaActual = Datetime.now(); 

                    Integer sv = Integer.valueOf(semanaVisita.formatGmt('w'));
                    Integer sa = Integer.valueOf(semanaActual.formatGmt('w'));
                    Integer diffSVSA = sa - sv;

                    indicadorVisita = (frecuencia - diffSVSA);

                }

            }


        }

        return indicadorVisita;

    }

    @AuraEnabled
    public static List<AgendaWrapper> obtenerCuentas () {

        List<AgendaWrapper> result = new List<AgendaWrapper>();
        Date hoy = Date.today();
        Date weekStart = hoy.toStartofWeek();
        Date nextWeekStart = weekStart.addDays(7);

        Map<String, List<Visita__c>> mapVisitasCuenta = obtenerVisitasMesCliente();

        for (Account a : new AccountsSelector().selectRecentlyUpdated(5000)) {

            Integer indicadorVisita = obtenerIndicadorVisita(a, mapVisitasCuenta);

            result.add(new AgendaWrapper(a.Id, a.Name, a.ShippingCity, a.ShippingState, indicadorVisita, nextWeekStart));

        }

        return result;

    }

    @AuraEnabled
    public static Map<String, Object> generarVisitas (String JSONCuentas) {

        System.debug('JSONCuentas ' + JSONCuentas);

        List<AgendaWrapper> cuentas = (List<AgendaWrapper>)System.JSON.deserialize(JSONCuentas, List<AgendaWrapper>.class);

        List<Visita__c> visitas = new List<Visita__c>();
        Map<String, Object> resultado = new Map<String, Object>();

        Date hoy = Date.today();
        Date weekStart = hoy.toStartofWeek();
        Date nextWeekStart = weekStart.addDays(7);
        Date nextWeekStop = weekStart.addDays(12);

        System.debug('cuentas ' + cuentas);  

        for (AgendaWrapper a : cuentas) {

            Visita__c visita = new Visita__c();
            visita.Cliente__c = a.Id;
            visita.Responsable__c = UserInfo.getUserId();
            visita.Fecha_planeada__c = a.FechaPlaneada;
            visita.Fecha_fin_planeada__c = a.FechaPlaneada.addDays(5);
            visitas.add(visita);

        }

        try {

            if (!visitas.isEmpty()) {

                insert visitas;

                resultado.put('success', true);

            }

        } catch (Exception e) {

            System.debug(e);
            resultado.put('success', false);

        }
        

        return resultado;

    }



}