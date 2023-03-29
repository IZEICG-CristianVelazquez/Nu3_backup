public interface IAgentesSelector extends fflib_ISObjectSelector {

    List<Agente__c> selectById(Set<Id> setIds);
    List<Agente__c> selectByIdDeAgente(Set<String> setIds);
}