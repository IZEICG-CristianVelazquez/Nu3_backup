@IsTest
public class AgentesSelectorTest {

    @IsTest
    static void whenSelectByIdReturnRecords(){
        Id agenteId = fflib_IDGenerator.generate(Agente__c.SObjectType);
        AgentesSelector.newInstance().selectById(new Set<Id>{agenteId});
        
    }

    @IsTest
    static void methodName(){
        AgentesSelector.newInstance().selectByIdDeAgente(new Set<String>{'test'});
        
    }
}