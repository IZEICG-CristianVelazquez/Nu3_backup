public inherited sharing class AgentesSelector extends fflib_SObjectSelector implements IAgentesSelector {

    public static IAgentesSelector newInstance() {
		return (IAgentesSelector) Application.Selector.newInstance(Agente__c.SObjectType);
	}

    public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Agente__c.Id,
            Agente__c.ID_de_Agente__c,
            Agente__c.Cliente__c,
            Agente__c.Vendedor__c,
            Agente__c.ID_Base_de_Datos__c,
            Agente__c.Canal__c
		};
	}

    public Schema.SObjectType getSObjectType() {
		return Agente__c.SObjectType;
	}

    public List<Agente__c> selectById(Set<Id> setIds) {
		return (List<Agente__c>) selectSObjectsById(setIds);
	}

    public List<Agente__c> selectByIdDeAgente(Set<String> setIds) {

        return Database.query(
            newQueryFactory()
            .setCondition('ID_de_Agente__c IN: setIds').toSOQL()
        );
    }
}