public with sharing class Lookupcontroller {

	@AuraEnabled
	public static List<sObject> querySalesforceRecord(String queryString) {
		System.debug('qString'+queryString);
		return Database.query(queryString);

	}

}