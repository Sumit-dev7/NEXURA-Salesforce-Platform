
import { LightningElement } from 'lwc';

const COLUMNS = [
    {
        label: 'Order Number',
        fieldName: 'OrderNumber',
        type: 'text'
    },
    {
        label: 'Customer',
        fieldName: 'customerName',
        type: 'text'
    },
    {
        label: 'Status',
        fieldName: 'Status',
        type: 'text'
    },
    {
        label: 'Effective Date',
        fieldName: 'EffectiveDate',
        type: 'date'
    },
    {
        label: 'Total Amount',
        fieldName: 'TotalAmount',
        type: 'currency'
    }
];

export default class NexuraOrderPanel extends LightningElement {
    columns = COLUMNS;

    orders = [];
    searchTerm = '';
    errorMessage = '';

    get filteredOrders() {
        const search = this.searchTerm.trim().toLowerCase();

        if (!search) {
            return this.orders;
        }

        return this.orders.filter((order) =>
            [
                order.OrderNumber,
                order.customerName,
                order.Status
            ].some((value) =>
                String(value || '').toLowerCase().includes(search)
            )
        );
    }

    get hasOrders() {
        return this.filteredOrders.length > 0;
    }

    get hasError() {
        return Boolean(this.errorMessage);
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
    }

    handleRefresh() {
        this.errorMessage = '';
    }
}
