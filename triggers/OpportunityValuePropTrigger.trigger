trigger OpportunityValuePropTrigger on Opportunity (after update) {
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
        
        // Check if stage changed to Discovery
        if (opp.StageName == 'Value Proposition' && 
            oldOpp.StageName != 'Value Proposition') {
            
            // Make async callout
            OpportunityWebhookService.sendWebhook(opp.Id);
        }
    }
}