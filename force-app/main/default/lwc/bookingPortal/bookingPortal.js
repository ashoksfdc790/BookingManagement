import { LightningElement, track } from 'lwc';
import getBookings from '@salesforce/apex/BookingPortalController.getBookings';

export default class BookingPortal extends LightningElement {

    @track bookings;
    @track status;
    @track deliveryDate;
    @track selectedBookingId;

    columns = [
        { label: 'Status', fieldName: 'Status__c' },
        { label: 'Delivery Date', fieldName: 'Delivery_Date__c', type: 'date' },
        { label: 'Logistics', fieldName: 'Logistic_Company__c' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View History',
                name: 'history',
                variant: 'base'
            }
        }
    ];

    statusOptions = [
        { label: 'All', value: '' },
        { label: 'Draft', value: 'Draft' },
        { label: 'Scheduled', value: 'Scheduled' },
        { label: 'In Transit', value: 'In Transit' },
        { label: 'Delivered', value: 'Delivered' }
    ];

    connectedCallback() {
        this.loadBookings();
    }

    handleStatusChange(event) {
        this.status = event.detail.value;
    }

    handleDateChange(event) {
        this.deliveryDate = event.detail.value;
    }

    loadBookings() {
        getBookings({
            status: this.status,
            deliveryDate: this.deliveryDate
        })
        .then(result => {
            this.bookings = result;
        })
        .catch(error => {
            console.error(error);
        });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'history') {
            this.selectedBookingId = row.Id;
        }
    }
}