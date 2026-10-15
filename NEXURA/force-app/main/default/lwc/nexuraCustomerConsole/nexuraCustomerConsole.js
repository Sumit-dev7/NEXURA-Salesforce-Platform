
import { LightningElement, wire } from 'lwc';
import getCustomers from '@salesforce/apex/NexuraCustomerService.getCustomers';

export default class NexuraCustomerConsole extends LightningElement {
    @wire(getCustomers)
    customersResult;

    get customers() {
        return this.customersResult.data;
    }

    get error() {
        return this.customersResult.error;
    }

    get hasCustomers() {
        return this.customers && this.customers.length > 0;
    }

    get hasError() {
        return !!this.error;
    }
    columns = [
    { label: 'Customer Name', fieldName: 'Name', type: 'text' },
    { label: 'Customer Number', fieldName: 'Customer_Number__c', type: 'text' },
    { label: 'Customer Type', fieldName: 'Customer_Type__c', type: 'text' },
    { label: 'Status', fieldName: 'Customer_Status__c', type: 'text' }
];
}
