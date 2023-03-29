@isTest
public with sharing class AccountTriggerTest {

    @IsTest
    static void AccountTriggerTest(){
        
        Account acc = new Account(
            Name = 'test',
            Base_de_Datos__c = 'NU3',
            ID_SAP__c = 'Ctest'
        );
    
        insert acc;
        
        acc.Name = 'test2';
        acc.Clave_cliente__c = '1111';

        update acc;

        Account accRecently = [SELECT Id,Clave_cliente__c FROM Account LIMIT 1];
        System.assertEquals('NU3CTEST', accRecently.Clave_cliente__c);
    }

}