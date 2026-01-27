public class BookingTriggerHandler {
    
    public static void updateBookingHistory(List<Booking__c> newBookingList, Map<Id,Booking__c> oldBookingList){
        
        if(!newBookingList.isEmpty()){
            List<Booking_History__c> bookinghtryList = new List<Booking_History__c>();
            for(Booking__c booking: newBookingList){
                Booking__c oldRecordValue = oldBookingList.get(booking.Id);
                if(booking.Status__c != oldRecordValue.Status__c ){
                    Booking_History__c bookhistory = new Booking_History__c();
                    bookhistory.Booking__c = booking.Id;
                    bookhistory.Change_Date__c = System.now();
                    bookhistory.Changed_By__c = System.UserInfo.getUserId();
                    bookhistory.Name = 'Status';
                    bookhistory.Old_Value__c = String.valueOf(oldRecordValue.Status__c);
                    bookhistory.New_Value__c = String.valueOf(booking.Status__c);
                    bookinghtryList.add(bookhistory);
                }
                
                if(booking.Delivery_Date__c != oldRecordValue.Delivery_Date__c){
                    Booking_History__c bookhistory = new Booking_History__c();
                    bookhistory.Booking__c = booking.Id;
                    bookhistory.Change_Date__c = System.now();
                    bookhistory.Changed_By__c = System.UserInfo.getUserId();
                    bookhistory.Name = 'Delivery Date';
                    bookhistory.Old_Value__c = String.valueOf(oldRecordValue.Delivery_Date__c);
                    bookhistory.New_Value__c = String.valueOf(oldRecordValue.Delivery_Date__c);
                    bookinghtryList.add(bookhistory);
                }
            }
            if(!bookinghtryList.isEmpty()){
                insert bookinghtryList;
            }
        }
        
        
    }
    
}