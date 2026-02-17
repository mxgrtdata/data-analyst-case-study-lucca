/* STEP 1 : Create a intermediate table from the clean version of salesforce_Account and the clean version of cc_decompte in order to identify
account that need to be categorize (no category given) or that are not in the good category

Objectives :
- For each account, we first check if there is a given category, if not this account id is kept
- Then, for each account id, with a given category, we check the average of headcount (licenses) throughout the period given and we compare it to the categories standards 
(0-100 Bronze /  100-250 Silver / 250-500 Gold / 500+ Platinium). if it is not in those standards we keep this account id to the new table created and we 
note the theoretical category (based on the calculated average number of headcount)
- Also, for each account id with not a given category, we also check the average of headcount (licenses) throughout the period given and we compare it to the categories standards 
(0-100 Bronze /  100-250 Silver / 250-500 Gold / 500+ Platinium) and we note the theoretical category (based on the calculated average number of headcount) 

Source table : 
- `data-technical-cases.mguerout.cc_decompte_cleaned`
- `data-technical-cases.mguerout.salesforce_account_clean_ex1`
*/

CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex1_comptes_a_categoriser` AS

-- We create a temporary table only used for the next query
WITH comptes_analyses AS (
  SELECT 
    s.cc_account_id,
    a.AccountCategorie__c,
    ROUND(AVG(s.headcount), 0) as headcount_moyen,
    ROUND(AVG(s.revenue * 12), 0) as arr_moyen
  
  FROM `data-technical-cases.mguerout.cc_decompte_cleaned` s
  LEFT JOIN `data-technical-cases.mguerout.salesforce_account_clean_ex1` a
    ON s.cc_account_id = a.ID_CC__c
  WHERE s.headcount > 0
  GROUP BY s.cc_account_id, a.AccountCategorie__c
)
  
SELECT 
  COALESCE(AccountCategorie__c, 'Non catégorisé') as categorie_actuelle,
  cc_account_id,
  headcount_moyen,
  arr_moyen,
  
  -- Catégorie théorique basée sur headcount
  CASE 
    WHEN headcount_moyen < 100 THEN 'Devrait être Bronze'
    WHEN headcount_moyen < 250 THEN 'Devrait être Silver'
    WHEN headcount_moyen < 500 THEN 'Devrait être Gold'
    ELSE 'Devrait être Platinium'
  END as categorie_theorique,
  
  -- Statut
  CASE 
    -- Non catégorisés (NULL)
    WHEN AccountCategorie__c IS NULL THEN 'À catégoriser'
    
    -- Mal catégorisés (hors seuils)
    WHEN (AccountCategorie__c = 'Bronze' AND headcount_moyen >= 100) THEN 'Mal catégorisé'
    WHEN (AccountCategorie__c = 'Silver' AND (headcount_moyen < 100 OR headcount_moyen >= 250)) THEN 'Mal catégorisé'
    WHEN (AccountCategorie__c = 'Gold' AND (headcount_moyen < 250 OR headcount_moyen >= 500)) THEN 'Mal catégorisé'
    WHEN (AccountCategorie__c = 'Platinium' AND headcount_moyen < 500) THEN 'Mal catégorisé'
    
    -- Bien catégorisés
    ELSE 'OK'
  END as statut

FROM comptes_analyses
WHERE 
  -- Non catégorisés
  AccountCategorie__c IS NULL
  OR
  -- Mal catégorisés
  (AccountCategorie__c = 'Bronze' AND headcount_moyen >= 100)
  OR (AccountCategorie__c = 'Silver' AND (headcount_moyen < 100 OR headcount_moyen >= 250))
  OR (AccountCategorie__c = 'Gold' AND (headcount_moyen < 250 OR headcount_moyen >= 500))
  OR (AccountCategorie__c = 'Platinium' AND headcount_moyen < 500)

ORDER BY headcount_moyen DESC;
