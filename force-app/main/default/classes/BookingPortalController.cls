public with sharing class BookingPortalController {

    @AuraEnabled(cacheable=true)
    public static List<Booking__c> getBookings(String status,Date deliveryDate) {
        String Query =
            'SELECT Id, Name, Status__c, Delivery_Date__c, ' +
            'Delivery_Address__c, Logistic_Company__c ' +
            'FROM Booking__c WHERE Id != null';

        if (String.isNotBlank(status)) {
            Query += ' AND Status__c = :status';
        }

        if (deliveryDate != null) {
            Query += ' AND Delivery_Date__c = :deliveryDate';
        }

        Query += ' ORDER BY Delivery_Date__c DESC';

        return Database.query(Query);
    }

    @AuraEnabled(cacheable=true)
    public static List<Booking_History__c> getBookingHistory(Id bookingId) {
        return [
            SELECT Id, Name,
                   Old_Value__c, New_Value__c,
                   Change_Date__c
            FROM Booking_History__c
            WHERE Booking__c = :bookingId
            ORDER BY Change_Date__c DESC
        ];
    }
}