({
    onPageReferenceChange: function(cmp, event, helper) {
        
        // URL base
        var baseURL = cmp.get("v.baseURL");

        var myPageRef = cmp.get("v.pageReference");
        
        var slpCode = myPageRef.state.c__slpCode;
        var slpName = myPageRef.state.c__slpName;
        var busUnit = myPageRef.state.c__busUnit;
        var cardCode = myPageRef.state.c__cardCode;
        var tipo = myPageRef.state.c__tipo;

        if (!slpCode || !slpName || !busUnit || !cardCode) {

            slpCode = cmp.get("v.slpCode");
            slpName = cmp.get("v.slpName");
            busUnit = cmp.get("v.busUnit");
            cardCode = cmp.get("v.cardCode");

        }
    
        cmp.set("v.page", baseURL + "CardCode=" + cardCode + "&SlpCode=" + slpCode + "&SlpName=" 
                + slpName + "&BusUnit=" + busUnit + "&Tipo=" + tipo );
    }
})