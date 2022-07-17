import { LightningElement, track, wire } from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';
import changeCaseStatus from '@salesforce/apex/CaseController.changeCaseStatus';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';
import VINE_BOOM from '@salesforce/resourceUrl/VineBoom';
import USERID from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';
import BRANCHNUM from '@salesforce/schema/User.Branch_Number__c';

export default class CaseSplit extends LightningElement {
    channelName = '/event/Case_Create__e';
    subscription = {};
    userBranchNum;
    columns = [
        {label: 'Case Number', fieldName: 'num', type: 'button', typeAttributes: {label: {fieldName: 'num'}, variant: 'base'}},
        {label: 'Branch Number', fieldName: 'branchNumber'},
        {label: 'Created Date', fieldName: 'createdDate'},
        {label: 'Subject', fieldName: 'subject'},
        {label: 'Type', fieldName: 'type'},
        {label: 'Status', fieldName: 'status'}
    ];
    @track caseOpened = false;
    @track cases = [];
    @track case = {};
    @track isLoading = false;

    @wire(getRecord, {recordId: USERID, fields: [BRANCHNUM]})
    setUserBranchNum({data, error}){
        if(data){
            this.userBranchNum = data.fields.Branch_Number__c.value;
        }
        else if(error){
            console.error('setUserBranchNum:', error);
        }
    }

    get caseId(){
        return this.case.id;
    };

    wireCases(){
        getCases().then(response => {
            this.cases = response.map((cs) => {
                let el = {
                    id: cs.Id,
                    num: cs.CaseNumber,
                    branchNumber: cs.Branch_Number__c,
                    createdDate: cs.CreatedDate,
                    status: cs.Status,
                    type: cs.Type,
                    subject: cs.Subject
                };
                return el;
            });
            this.cases.sort((a,b) => (a.createdDate < b.createdDate) ? 1 : ((b.createdDate < a.createdDate) ? -1 : 0));
        }).catch(error => {
            console.error('wireCases: ', error);
        })
    }

    connectedCallback(){
        console.clear();
        this.wireCases();
        this.handleError();
        this.handleSubscribe();
    }

    handleSubscribe(){
        const messageCallback = (response) => {
            if(this.userBranchNum == response.Branch_Number__c){
                let notifSound = new Audio();
                notifSound.src = VINE_BOOM;
                notifSound.load();
                notifSound.play();
                
                this.wireCases();
            }
        };  

        subscribe(this.channelName, -1, messageCallback)
        .then(response => {
            this.subscription = response;
        })
        .catch(error => {
            console.error('handleSubscribe:', error);
        }); 
    }

    handleError(){
        onError(error => {
            console.error('handleError:', JSON.stringify(error));
        });
    }

    handleNumClick(event){
        this.isLoading = true;
        this.template.querySelector('[data-id="table-div"]').classList.add('slds-size_2-of-3');

        this.case = this.cases.find(obj => {
            return obj.id === event.detail.row.id;
        });

        changeCaseStatus({caseId: this.caseId})
        .then(() => {
            this.wireCases();
        })
        .catch(error => {
            console.error('handleNumClick:', error);
        });
        
        this.caseOpened = true;
        this.isLoading = false;
    }

    handleCloseClick(){
        this.caseOpened = false;
        this.template.querySelector('[data-id="table-div"]').classList.remove('slds-size_2-of-3');
    }
}