public with sharing class SalesItemTriggerHandler extends TriggerHandler{
    List<Sales_Item__c> newItems;
    List<Sales_Item__c> oldItems;
    Map<Id, Sales_Item__c> mapNewItems;
    Map<Id, Sales_Item__c> mapOldItems;

    public SalesItemTriggerHandler(){
        newItems = (List<Sales_Item__c>)Trigger.New;
        oldItems = (List<Sales_Item__c>)Trigger.Old;
        mapNewItems = (Map<Id, Sales_Item__c>)Trigger.NewMap;
        mapOldItems = (Map<Id, Sales_Item__c>)Trigger.OldMap;
    }
    public override void beforeInsert(){
        Map<Id, List<Sales_Item__c>> mapSalesItemsByOppId = getMapOppIdSalesItems(newItems);
        Map<Id, Opportunity> mapOpps = getMapOppsByIdOpp(mapSalesItemsByOppId.keySet());

        for(Sales_Item__c si : newItems){
            Opportunity opp = mapOpps.get(si.Opportunity__c);
            Integer oppItemsNum = mapSalesItemsByOppId.get(si.Opportunity__c).size();

            if(opp.Current_Sales_Items_Number__c + oppItemsNum > opp.Sales_Items_Capacity__c){
                si.addError(Label.sales_item_capacity_full);
            }
            else{
                opp.Current_Sales_Items_Number__c++;
            }
        }

        update mapOpps.values();
    }
    public override void beforeDelete(){
        Map<Id, Opportunity> mapOpps = getMapOppsByIdOpp(getMapOppIdSalesItems(oldItems).keySet());
        
        for(Sales_Item__c si : oldItems){
            mapOpps.get(si.Opportunity__c).Current_Sales_Items_Number__c--;
        }

        update mapOpps.values();
    }
    public override void beforeUpdate(){
        Set<Id> setOppIds = new Set<Id>();

        Map<Id, List<Sales_Item__c>> mapSalesItemsByOppId = new Map<Id, List<Sales_Item__c>>();
        for(Sales_Item__c si : newItems){
            if(si.Opportunity__c == mapOldItems.get(si.Id).Opportunity__c){
                continue;
            }
            if(!mapSalesItemsByOppId.containsKey(si.Opportunity__c)){
                mapSalesItemsByOppId.put(si.Opportunity__c, new List<Sales_Item__c>());
            }
            mapSalesItemsByOppId.get(si.Opportunity__c).add(si);
            
            setOppIds.add(si.Opportunity__c);
            setOppIds.add(mapOldItems.get(si.Id).Opportunity__c);
        }

        if(setOppIds.isEmpty() || mapSalesItemsByOppID.isEmpty()){
            return;
        }

        Map<Id, Opportunity> mapNewOpps = getMapOppsByIdOpp(setOppIds);
        for(Sales_Item__c si : newItems){
            Integer salesItemsNum = mapSalesItemsByOppId.get(si.Opportunity__c).size();
            Opportunity newOpp = mapNewOpps.get(si.Opportunity__c);
            Opportunity oldOpp = mapNewOpps.get(mapOldItems.get(si.Id).Opportunity__c);

            if(newOpp.Sales_Items_Capacity__c < newOpp.Current_Sales_Items_Number__c + salesItemsNum){
                mapNewItems.get(si.Id).addError(Label.sales_item_capacity_full);
            }
            else{
                oldOpp.Current_Sales_Items_Number__c--;
                newOpp.Current_Sales_Items_Number__c++;
            }
        }

        update mapNewOpps.values();
    }
    
    private Map<Id, List<Sales_Item__c>> getMapOppIdSalesItems(List<Sales_Item__c> items){
        Map<Id, List<Sales_Item__c>> mapSalesItemsByOppId = new Map<Id, List<Sales_Item__c>>();

        for(Sales_Item__c si : items){

            if(!mapSalesItemsByOppId.containsKey(si.Opportunity__c)){
                mapSalesItemsByOppId.put(si.Opportunity__c, new List<Sales_Item__c>());
            }
            mapSalesItemsByOppId.get(si.Opportunity__c).add(si);
        }

        return mapSalesItemsByOppId;
    }
    
    private Map<Id, Opportunity> getMapOppsByIdOpp(Set<Id> setOppIds){
        return new Map<Id, Opportunity>([
            SELECT Name, Sales_Item_Num__c, Sales_Items_Capacity__c, Current_Sales_Items_Number__c 
            FROM Opportunity 
            WHERE Id=: setOppIds
        ]);
    }
}