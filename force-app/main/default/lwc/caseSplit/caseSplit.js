import { LightningElement, track, wire } from 'lwc';
import getCases from '@salesforce/apex/CaseService.getCases';
import changeCaseStatus from '@salesforce/apex/CaseService.changeCaseStatus';
import { getRecord } from 'lightning/uiRecordApi';
import { subscribe, onError } from 'lightning/empApi';
import VINE_BOOM from '@salesforce/resourceUrl/VIneBoom';
import USER_ID from '@salesforce/user/Id';
import USER_BRANCHNUMBER from '@salesforce/schema/User.Branch_Number__c';
import CASE_BRANCHNUMBER from '@salesforce/schema/Case.Branch_Number__c';
import CASE_CASENUMBER from '@salesforce/schema/Case.CaseNumber';
import CASE_CREATEDDATE from '@salesforce/schema/Case.CreatedDate';
import CASE_SUBJECT from '@salesforce/schema/Case.Subject';
import CASE_TYPE from '@salesforce/schema/Case.Type';
import CASE_STATUS from '@salesforce/schema/Case.Status';

const channelName = '/event/Case_Create__e';
export default class CaseSplit extends LightningElement {
    userBranchNum;
    selectedCaseId;
    columns = [
        {label: 'Case Number', fieldName: CASE_CASENUMBER, type: 'button', typeAttributes: {label: {fieldName: CASE_CASENUMBER}, variant: 'base'}},
        {label: 'Branch Number', fieldName: CASE_BRANCHNUMBER},
        {label: 'Created Date', fieldName: CASE_CREATEDDATE},
        {label: 'Subject', fieldName: CASE_SUBJECT},
        {label: 'Type', fieldName: CASE_TYPE},
        {label: 'Status', fieldName: CASE_STATUS}
    ];
    @track caseOpened = false;
    @track cases = [];
    @track isLoading = false;

    @wire(getRecord, {recordId: USER_ID, fields: [USER_BRANCHNUMBER]})
    setUserBranchNum({data, error}){
        if(data){
            this.userBranchNum = data.fields.Branch_Number__c.value;
        }
        else if(error){
            console.error('setUserBranchNum:', error);
        }
    }

    wireCases(){
        this.isLoading = true;
        getCases({
            branchNum: this.userBranchNum
        }).then(response => {
            this.cases = response;
        }).catch(error => {
            console.error('wireCases:', error);
        }).finally(() => {
            this.isLoading = false;
        });
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

        subscribe(channelName, -1, messageCallback)
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

        this.selectedCaseId = event.detail.row.id;

        changeCaseStatus({
            caseId: this.caseId
        }).then(() => {
            this.wireCases();
        }).catch(error => {
            console.error('handleNumClick:', error);
        }).finally(() => {
            this.caseOpened = true;
            this.isLoading = false;
        });
        
    }

    handleCloseClick(){
        this.caseOpened = false;
        this.template.querySelector('[data-id="table-div"]').classList.remove('slds-size_2-of-3');
    }
}