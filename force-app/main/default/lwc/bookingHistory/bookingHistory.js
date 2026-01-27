import { LightningElement, api, wire } from 'lwc';
import getBookingHistory from
    '@salesforce/apex/BookingPortalController.getBookingHistory';

export default class BookingHistory extends LightningElement {

    @api bookingId;
    history;

    columns = [
        { label: 'Field', fieldName: 'Field_Changed__c' },
        { label: 'Old Value', fieldName: 'Old_Value__c' },
        { label: 'New Value', fieldName: 'New_Value__c' },
        { label: 'Changed On', fieldName: 'Change_Date__c', type: 'date' }
    ];

    @wire(getBookingHistory, { bookingId: '$bookingId' })
    wiredHistory({ data, error }) {
        if (data) {
            this.history = data;
        } else if (error) {
            console.error(error);
        }
    }
}