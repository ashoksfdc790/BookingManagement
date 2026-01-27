public class BookingSharingService {
    
    public static void shareBookings(List<Booking__c> bookings) {
        
        if (bookings == null || bookings.isEmpty()) {
            return;
        }
        
        Set<Id> accountIds = new Set<Id>();
        for (Booking__c b : bookings) {
            if (b.Account__c != null) {
                accountIds.add(b.Account__c);
            }
        }
        
        if (accountIds.isEmpty()) {
            return;
        }
        
        Map<Id, List<AccountContactRelation>> accountToAcrMap =
            new Map<Id, List<AccountContactRelation>>();
        
        Set<Id> contactIds = new Set<Id>();
        
        for (AccountContactRelation acr : [
            SELECT AccountId, ContactId
            FROM AccountContactRelation
            WHERE AccountId IN :accountIds
            AND IsActive = true
        ]) {
            contactIds.add(acr.ContactId);
            
            if (!accountToAcrMap.containsKey(acr.AccountId)) {
                accountToAcrMap.put(acr.AccountId, new List<AccountContactRelation>());
            }
            accountToAcrMap.get(acr.AccountId).add(acr);
        }
        
        if (contactIds.isEmpty()) {
            return;
        }
        
        Map<Id, Id> contactToUserMap = new Map<Id, Id>();
        
        for (User u : [
            SELECT Id, ContactId
            FROM User
            WHERE ContactId IN :contactIds
            AND IsActive = true
        ]) {
            contactToUserMap.put(u.ContactId, u.Id);
        }
        
        if (contactToUserMap.isEmpty()) {
            return;
        }
        
        List<Booking__Share> sharesToInsert = new List<Booking__Share>();
        
        for (Booking__c b : bookings) {
            
            if (!accountToAcrMap.containsKey(b.Account__c)) {
                continue;
            }
            
            for (AccountContactRelation acr : accountToAcrMap.get(b.Account__c)) {
                
                if (!contactToUserMap.containsKey(acr.ContactId)) {
                    continue;
                }
                
                sharesToInsert.add(new Booking__Share(
                    ParentId      = b.Id,
                    UserOrGroupId = contactToUserMap.get(acr.ContactId),
                    AccessLevel   = 'Read',
                    RowCause      = Schema.Booking__Share.RowCause.Manual
                ));
            }
        }
        
        if (!sharesToInsert.isEmpty()) {
            insert sharesToInsert;
        }
    }
}