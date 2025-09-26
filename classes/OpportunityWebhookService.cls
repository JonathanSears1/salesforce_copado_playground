public class OpportunityWebhookService {
    
    @future(callout=true)
    public static void sendWebhook(Id opportunityId) {
        try {
            // Query for opportunity details
            Opportunity opp = [SELECT Id, Name, AccountId, OwnerId, StageName 
                              FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            
            // Prepare JSON payload
            Map<String, Object> payload = new Map<String, Object>();
            payload.put('opportunityId', opp.Id);
            payload.put('opportunityName', opp.Name);
            payload.put('accountId', opp.AccountId);
            payload.put('ownerId', opp.OwnerId);
            payload.put('stage', opp.StageName);
            
            // Make HTTP callout
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://d3882a076263.ngrok-free.app/salesforce-webhook');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(payload));
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            System.debug('Webhook response: ' + res.getStatusCode());
            
        } catch (Exception e) {
            System.debug('Webhook error: ' + e.getMessage());
        }
    }
}