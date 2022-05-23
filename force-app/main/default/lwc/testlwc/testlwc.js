import { api, LightningElement } from 'lwc';

import getContacts from '@salesforce/apex/testapex.getContacts';

export default class Testwlc extends LightningElement {

    @api recordId;

    contacts = []
    show = true

    columns = [{
        label: 'First Name',
        fieldName: 'FirstName',
        type: 'url',
        typeAttributes: {label: {fieldName: 'FirstName'}, target: '_blank'} 
    },
    {
        label: 'Last Name',
        fieldName: 'LastName'
    },
    {
        label: 'Email',
        fieldName: 'Email',
        type: 'email',
        typeAttributes: {label: {fieldName: 'Email', target: '_blank'}}
    }];


    get data() {
        return this.contacts.map(cont => {
            return {
                ...cont,
                FirstName: '/lightning/r/Contact/' + cont.Id + '/view'
            }
        });
    }

    async connectedCallback(){
        this.contacts = await getContacts();
    }
}