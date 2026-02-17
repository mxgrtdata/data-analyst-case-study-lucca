CREATE OR REPLACE TABLE `data-technical-cases.mguerout.salesforce_account_clean_ex1` AS
SELECT *
FROM `data-technical-cases.da_case.salesforce_Account`
WHERE Paid_Solutions__c IS NOT NULL;
