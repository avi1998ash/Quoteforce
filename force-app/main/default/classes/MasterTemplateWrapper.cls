public with sharing class MasterTemplateWrapper {
    @AuraEnabled public Id id;
    @AuraEnabled public String layoutName;
    @AuraEnabled public String letterFromOwner;
    @AuraEnabled public String zipCode;
    @AuraEnabled public String stateProvince;
    @AuraEnabled public String city;
    @AuraEnabled public String streetAddress;
    @AuraEnabled public String lastName;
    @AuraEnabled public String firstName;
    @AuraEnabled public Date createdDate;
    @AuraEnabled public String primaryImage;
    @AuraEnabled public String secondaryImage;
    @AuraEnabled public String warrantyDoc;
    @AuraEnabled public String termsConditionDoc;
    @AuraEnabled public String pagesJson;
    @AuraEnabled public Id priceBook;
    @AuraEnabled public String currencyType;
}