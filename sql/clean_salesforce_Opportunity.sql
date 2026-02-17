/* STEP 1 : Create a cleaned salesforce_Opportunity table

Objectives : 
- Split the column Interesse_par_cc because we need to have on each line only one product
- Clean mistakes made in this column like put a ", " insted of ";"

Source table : 
- `data-technical-cases.da_case.salesforce_Opportunity`
*/

CREATE OR REPLACE TABLE `data-technical-cases.mguerout.salesforce_opportunity_cleaned` AS
SELECT 
  o.*,
  TRIM(produit) as Produit_interesse
FROM `data-technical-cases.da_case.salesforce_Opportunity` o,
  UNNEST(SPLIT(REPLACE(o.Interesse_par__c, ', ', ';'), ';')) as produit
WHERE o.Interesse_par__c IS NOT NULL
  AND TRIM(produit) != '';
