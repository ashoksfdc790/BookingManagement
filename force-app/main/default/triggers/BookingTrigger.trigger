Trigger BookingTrigger on Booking__c (after insert, after update) {
    
    if (Trigger.isAfter) {
        
        if (Trigger.isInsert) {
            BookingSharingService.shareBookings(Trigger.new);
        }
        
        if (Trigger.isUpdate) {
            
            BookingTriggerHandler.updateBookingHistory(Trigger.new,Trigger.oldMap);
            
            List<Booking__c> accountChangedBookings = new List<Booking__c>();
            
            for (Booking__c newRec : Trigger.new) {
                Booking__c oldRec = Trigger.oldMap.get(newRec.Id);
                
                if (newRec.Account__c != oldRec.Account__c) {
                    accountChangedBookings.add(newRec);
                }
            }
            
            if (!accountChangedBookings.isEmpty()) {
                BookingSharingService.shareBookings(accountChangedBookings);
            }
        }
    }
}