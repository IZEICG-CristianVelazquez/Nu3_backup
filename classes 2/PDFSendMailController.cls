public with sharing class PDFSendMailController {

    @AuraEnabled
	public static String getPDFData(String pdfURL){
		//Obteniendo el PDF
        System.debug(pdfURL);
		PageReference pdf = new PageReference(pdfURL);
		
		Blob b = blob.valueof('error');
		Try { b = pdf.getContent(); }      
		Catch(Exception e){}
		String b64 = EncodingUtil.base64Encode(b);

		return b64;
    }

	@AuraEnabled
	public static void savePDF(String recordId, String namePedido, String pdfURL){

		System.debug(recordId);

		Pagereference pdf = new Pagereference(pdfURL);
		Blob b = blob.valueOf('error');
		try{ b = pdf.getContentAsPDF(); }
		catch(Exception e ){}

		if(String.isNotBlank(recordId)){

			ContentVersion cv = new ContentVersion();
			cv.VersionData = b;
			cv.Title = namePedido;
			cv.PathOnClient = namePedido+'.pdf';

			DMLUtils.insertRecords(new List<ContentVersion>{cv},false);

			ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
			cdl.LinkedEntityId = recordId;
			cdl.ShareType = 'V';

			DMLUtils.insertRecords(new List<ContentDocumentLink>{cdl},false);

		}
	
	}

	@AuraEnabled
	public static Boolean countAtt(String recordId, String namePedido){

		Boolean v = false;
		String name = '';

		List<Order> order = new OrdersSelector().selectById(new Set<Id>{recordId});
		name = order[0].OrderNumber;

		List<ContentDocumentLink> listFiles = [SELECT Id,ContentDocument.Title, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId = :recordId
									AND  ContentDocument.Title = :name AND ContentDocument.FileType = 'PDF'];

		System.debug(listFiles);

		if(listFiles.size() >= 1){

			v = true;

		}

		return v;

	}

}