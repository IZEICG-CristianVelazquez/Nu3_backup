({
    showToast : function(component,message, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Atención!",
            "message": message
        });
        toastEvent.fire();
    },
    
    handleShowNotice : function(component,message) {
        
        component.find('notifLib').showToast({
            "variant": "success",
            "tittle": "Atención!",
            "message": message,
            "mode" : "pester"
        });
    },

    callServer : function (component, actionName, params, callback) {
        
        var action = component.get(actionName);
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    },
    
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    getData : function(component) {

        var params;
        
        this.callServer(component, "c.loadData", params, function(response) {
            
            if (response.getState() === "SUCCESS") {
                
                var res =  response.getReturnValue();
                var resJSON = JSON.parse(res);
                
                component.set("v.dataJSON",res);
                component.set("v.data",resJSON);
                console.log('new data loaded!');
            }
            
        });
	},

    initEmpApi : function(component) {
        
        const empApi = component.find('empApi');
        
        // Uncomment below line to enable debug logging (optional)
        // empApi.setDebugFlag(true);
        
        empApi.onError($A.getCallback(error => {
            console.error('EMP API error: ', error); 
        }));
            
        },
            
            subscribe : function(component,event,helper) {
                
                const empApi = component.find('empApi');
                const channel = component.get('v.channel');
                const replayId = -1;
                
                empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {

                    var orderJSON = JSON.parse(eventReceived.data.payload.Record__c);
                    var andenOrBanda = (orderJSON.anden !='')?'al andén '+orderJSON.anden:'a '+orderJSON.banda;
                    
                    console.log('Received event ', JSON.stringify(eventReceived));
                    console.log(eventReceived.data.payload.RecordId__c);
                    console.log(orderJSON);
                    
                    component.set("v.msgAlert", orderJSON.nombreChofer+' favor de pasar '+andenOrBanda);
                    this.openModel(component,event,helper);
                    this.getData(component);
                    
                    window.setTimeout($A.getCallback(function() {
                    	console.log('close modal');
                    	component.set("v.isOpen", false);
                	}), 15000);
                   
                    
                }))
                    .then(subscription => {
                    console.log('Subscribed to channel ', subscription.channel);
                    component.set('v.subscription', subscription);
                    
                });
                },
                    
                    unsubscribe : function(component) {
                        
                        const empApi = component.find('empApi');
                        const subscription = component.get('v.subscription');
                        
                        empApi.unsubscribe(subscription, $A.getCallback(unsubscribed => {
                            
                            console.log('Unsubscribed from channel '+ unsubscribed.subscription);
                            component.set('v.subscription', null);
                            
                        }));
                            
                        }
                            
                            
                        })