CREATE OR REPLACE TABLE `data-technical-cases.mguerout.salesforce_opportunity_cleaned` AS
SELECT 
  o.*,
  TRIM(produit) as Produit_interesse
FROM `data-technical-cases.da_case.salesforce_Opportunity` o,
  UNNEST(SPLIT(REPLACE(o.Interesse_par__c, ', ', ';'), ';')) as produit
WHERE o.Interesse_par__c IS NOT NULL
  AND TRIM(produit) != '';
