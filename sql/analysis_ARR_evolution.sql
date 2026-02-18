/* STEP 1 : Create a intermediate table from the clean version of salesforce_Account and cc_decompte in order to analyze the evolution of ARR by typology

Objectives : 
- Each line is a unique combination of a category and a billing_period_date
- For each unique combination we provide :
  - The number of distinct account id
  - the average ARR
  - the total ARR
  - the average number of headcount (licenses)
  - the average ARR by licenses

Source table : 
- `data-technical-cases.mguerout.cc_decompte_cleaned`
- `data-technical-cases.mguerout.salesforce_account_clean_ex1`
*/

CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex1_arr_evolution_typologie` AS
SELECT 
  COALESCE(a.AccountCategorie__c, 'Non catégorisé') as typologie,
  s.billing_period_date as mois,
  COUNT(DISTINCT s.cc_account_id) as nb_comptes,
  AVG(s.revenue * 12) as arr_moyen,
  SUM(s.revenue * 12) as arr_total,
  AVG(s.headcount) as headcount_moyen,
  AVG(s.revenue * 12 / NULLIF(s.headcount, 0)) as arr_par_licence
FROM `data-technical-cases.mguerout.cc_decompte` s
LEFT JOIN `data-technical-cases.mguerout.salesforce_account_clean_ex1` a
  ON s.cc_account_id = a.ID_CC__c
WHERE s.headcount > 0
  AND s.revenue > 0
GROUP BY typologie, mois
ORDER BY typologie, mois;
