public class BookingDeliveryNotificationBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query = 'SELECT Id, Account__c, Contact__c, Delivery_Address__c, Logistic_Company__c, Status__c FROM Booking__c'+
                        'WHERE Delivery_Date__c = TODAY';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Booking__c> scope) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Booking__c b : scope) {
            List<AccountContactRelation> acrList  = [
                SELECT Contact.Email
                FROM AccountContactRelation
                WHERE AccountId = :b.Account__c
                AND IsActive = true
            ];
            
            for (AccountContactRelation acr : acrList) {
                if (acr.Contact.Email != null) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[] { acr.Contact.Email });
                    email.setSubject('Delivery Notification');
                    email.setPlainTextBody(
                        'Status: ' + b.Status__c +
                        '\nAddress: ' + b.Delivery_Address__c +
                        '\nLogistics: ' + b.Logistic_Company__c
                    );
                    emails.add(email);
                }
            }
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}