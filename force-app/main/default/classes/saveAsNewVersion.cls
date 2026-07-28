public with sharing class saveAsNewVersion {
    
    @AuraEnabled(cacheable=false)
    public static String saveAsNewVersion(String currentQuoteId) {
        
        Id quoteId = QuoteForceSecurityUtil.requireId(currentQuoteId, 'Quote Id');
        
        QuoteForceSecurityUtil.assertCreateable(
            QuoteForce__Quotes__c.SObjectType
        );
        
        QuoteForceSecurityUtil.assertCreateable(
            QuoteForce__QuoteLineItem__c.SObjectType
        );

        // NEW: also require createable on the Section object
        QuoteForceSecurityUtil.assertCreateable(
            QuoteForce__Product_Section__c.SObjectType
        );
        
        QuoteForce__Quotes__c newVersion;
        
        try {
            
            QuoteForce__Quotes__c original = [
                SELECT Name,
                QuoteForce__Opportunity__c,
                QuoteForce__Expiration_Date__c,
                QuoteForce__Status__c,
                QuoteForce__State_Province__c,
                QuoteForce__Pages_JSON__c,
                QuoteForce__Terms_Conditions__c,
                QuoteForce__Warranty__c,
                QuoteForce__Tax__c,
                QuoteForce__Bill_To__Street__s,
                QuoteForce__Bill_To__City__s,
                QuoteForce__Bill_To__PostalCode__s,
                QuoteForce__Bill_To__Longitude__s,
                QuoteForce__Bill_To__GeocodeAccuracy__s,
                QuoteForce__Bill_To__StateCode__s,
                QuoteForce__Layout_Name__c,
                QuoteForce__Date__c,
                QuoteForce__Ship_To__c,
                QuoteForce__Ship_To__GeocodeAccuracy__s,
                QuoteForce__Ship_To__Longitude__s,
                QuoteForce__Ship_To__Latitude__s,
                QuoteForce__Ship_To__StateCode__s,
                QuoteForce__Ship_To__CountryCode__s,
                QuoteForce__Bill_To__CountryCode__s,
                QuoteForce__Ship_To__PostalCode__s,
                QuoteForce__Ship_To__City__s,
                QuoteForce__Ship_To__Street__s,
                QuoteForce__LayoutId__c,
                QuoteForce__Currency__c,       
                QuoteForce__Price_Book__c,
                QuoteForce__Primary_Image__c,
                QuoteForce__Secondary_Image__c
                FROM QuoteForce__Quotes__c
                WHERE Id = :quoteId
                WITH USER_MODE
                LIMIT 1
            ];
            
            newVersion = new QuoteForce__Quotes__c();
            
            String oldName = original.Name;
            String newName;
            
            if (oldName.contains(' Version ')) {
                
                String baseName =
                    oldName.substringBeforeLast(' Version ');
                
                String versionStr =
                    oldName.substringAfterLast(' Version ');
                
                try {
                    
                    Integer versionNum =
                        Integer.valueOf(versionStr.trim());
                    
                    newName =
                        baseName + ' Version ' + (versionNum + 1);
                    
                } catch (Exception e) {
                    
                    newName = oldName + ' Version 1';
                }
                
            } else {
                
                newName = oldName + ' Version 1';
            }
            
            newVersion.Name = newName;
            
            newVersion.QuoteForce__Opportunity__c =
                original.QuoteForce__Opportunity__c;
            
            newVersion.QuoteForce__Expiration_Date__c =
                original.QuoteForce__Expiration_Date__c;
            
            newVersion.QuoteForce__Status__c =
                original.QuoteForce__Status__c;
            
            newVersion.QuoteForce__Pages_JSON__c =
                original.QuoteForce__Pages_JSON__c;
            
            newVersion.QuoteForce__Terms_Conditions__c =
                original.QuoteForce__Terms_Conditions__c;
            
            newVersion.QuoteForce__Warranty__c =
                original.QuoteForce__Warranty__c;
            
            newVersion.QuoteForce__Tax__c =
                original.QuoteForce__Tax__c;
            
            newVersion.QuoteForce__Layout_Name__c =
                original.QuoteForce__Layout_Name__c;
            
            newVersion.QuoteForce__Date__c =
                original.QuoteForce__Date__c;
            
            // Billing Mapping
            newVersion.QuoteForce__Bill_To__Street__s =
                original.QuoteForce__Bill_To__Street__s;
            
            newVersion.QuoteForce__Bill_To__City__s =
                original.QuoteForce__Bill_To__City__s;
            
            newVersion.QuoteForce__Bill_To__PostalCode__s =
                original.QuoteForce__Bill_To__PostalCode__s;
            
            newVersion.QuoteForce__Bill_To__CountryCode__s =
                original.QuoteForce__Bill_To__CountryCode__s;
            
            // Shipping Mapping
            newVersion.QuoteForce__Ship_To__Street__s =
                original.QuoteForce__Ship_To__Street__s;
            
            newVersion.QuoteForce__Ship_To__City__s =
                original.QuoteForce__Ship_To__City__s;
            
            newVersion.QuoteForce__Ship_To__PostalCode__s =
                original.QuoteForce__Ship_To__PostalCode__s;
            
            newVersion.QuoteForce__Ship_To__Longitude__s =
                original.QuoteForce__Ship_To__Longitude__s;
            
            newVersion.QuoteForce__Ship_To__GeocodeAccuracy__s =
                original.QuoteForce__Ship_To__GeocodeAccuracy__s;
            
            newVersion.QuoteForce__Ship_To__StateCode__s =
                original.QuoteForce__Ship_To__StateCode__s;
            
            newVersion.QuoteForce__Ship_To__PostalCode__s =
                original.QuoteForce__Ship_To__PostalCode__s;
            
            newVersion.QuoteForce__Ship_To__CountryCode__s =
                original.QuoteForce__Ship_To__CountryCode__s;
            
            newVersion.QuoteForce__State_Province__c =
                original.QuoteForce__State_Province__c;
                
            newVersion.QuoteForce__LayoutId__c =      
                original.QuoteForce__LayoutId__c;

            newVersion.QuoteForce__Currency__c =
                original.QuoteForce__Currency__c;

            newVersion.QuoteForce__Price_Book__c =
                original.QuoteForce__Price_Book__c;

            newVersion.QuoteForce__Primary_Image__c =
                original.QuoteForce__Primary_Image__c;

            newVersion.QuoteForce__Secondary_Image__c =
                original.QuoteForce__Secondary_Image__c;
            
            List<QuoteForce__Quotes__c> sanitizedQuotes =
                (List<QuoteForce__Quotes__c>) Security.stripInaccessible(
                    AccessType.CREATABLE,
                    new List<QuoteForce__Quotes__c>{ newVersion }
                ).getRecords();
            
            insert as user sanitizedQuotes[0];
            
            newVersion = sanitizedQuotes[0];
            
        } catch (Exception e) {
            
            throw new AuraHandledException(
                'Error on QuoteForce__Quotes__c: ' + e.getMessage()
            );
        }

        // ================================================================
        // Clone Section records FIRST, build old->new section Id map
        // (confirmed via debug log: object = QuoteForce__Product_Section__c,
        //  lookup field = QuoteForce__Quotes__c)
        // ================================================================
        Map<Id, Id> oldSectionToNewSectionMap = new Map<Id, Id>();

        List<QuoteForce__Product_Section__c> originalSections = [
            SELECT Id, Name, QuoteForce__Notes__c, QuoteForce__Master_Template__c
            FROM QuoteForce__Product_Section__c
            WHERE QuoteForce__Quotes__c = :quoteId
            WITH USER_MODE
        ];

        if (!originalSections.isEmpty()) {

            List<QuoteForce__Product_Section__c> newSections =
                new List<QuoteForce__Product_Section__c>();

            for (QuoteForce__Product_Section__c sec : originalSections) {
                QuoteForce__Product_Section__c newSec =
                    new QuoteForce__Product_Section__c();

                newSec.Name = sec.Name;
                newSec.QuoteForce__Notes__c = sec.QuoteForce__Notes__c;
                newSec.QuoteForce__Master_Template__c = sec.QuoteForce__Master_Template__c;
                newSec.QuoteForce__Quotes__c = newVersion.Id;

                newSections.add(newSec);
            }

            List<QuoteForce__Product_Section__c> sanitizedSections =
                (List<QuoteForce__Product_Section__c>) Security.stripInaccessible(
                    AccessType.CREATABLE,
                    newSections
                ).getRecords();

            insert as user sanitizedSections;

            for (Integer i = 0; i < originalSections.size(); i++) {
                oldSectionToNewSectionMap.put(
                    originalSections[i].Id,
                    sanitizedSections[i].Id
                );
            }
        }
        
        List<QuoteForce__QuoteLineItem__c> orginalineIteam = [
            SELECT QuoteForce__Product_Bundle__c,
            QuoteForce__Price__c,
            QuoteForce__Product_Section__c,
            QuoteForce__Quantity__c,
            QuoteForce__Product__c,
            QuoteForce__Price_Book_Entry__c
            FROM QuoteForce__QuoteLineItem__c
            WHERE QuoteForce__Quotes__c = :quoteId
            WITH USER_MODE
        ];
        
        if (!orginalineIteam.isEmpty()) {
            
            List<QuoteForce__QuoteLineItem__c> newVersion1 =
                new List<QuoteForce__QuoteLineItem__c>();
            
            for (QuoteForce__QuoteLineItem__c lineitem : orginalineIteam) {
                
                QuoteForce__QuoteLineItem__c lineItemnewVersion =
                    new QuoteForce__QuoteLineItem__c();
                
                lineItemnewVersion.QuoteForce__Product_Bundle__c =
                    lineitem.QuoteForce__Product_Bundle__c;
                
                lineItemnewVersion.QuoteForce__Price__c =
                    lineitem.QuoteForce__Price__c;
                
                lineItemnewVersion.QuoteForce__Product__c =
                    lineitem.QuoteForce__Product__c;
                
                lineItemnewVersion.QuoteForce__Price_Book_Entry__c =
                    lineitem.QuoteForce__Price_Book_Entry__c;
                
                // Remap to the newly cloned section instead of the old one
                lineItemnewVersion.QuoteForce__Product_Section__c =
                    oldSectionToNewSectionMap.get(
                        lineitem.QuoteForce__Product_Section__c
                    );
                
                lineItemnewVersion.QuoteForce__Quantity__c =
                    lineitem.QuoteForce__Quantity__c;
                
                lineItemnewVersion.QuoteForce__Quotes__c =
                    newVersion.Id;
                
                newVersion1.add(lineItemnewVersion);
            }
            
            if (!newVersion1.isEmpty()) {
                
                List<QuoteForce__QuoteLineItem__c> sanitizedLineItems =
                    (List<QuoteForce__QuoteLineItem__c>)
                    Security.stripInaccessible(
                        AccessType.CREATABLE,
                        newVersion1
                    ).getRecords();
                
                insert as user sanitizedLineItems;
            }
        }
        
        return newVersion.Id;
    }
}