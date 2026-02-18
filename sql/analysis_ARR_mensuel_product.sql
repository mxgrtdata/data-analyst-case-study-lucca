/* STEP 1 : Create a table from the clean version of cc_decompte in order to analyze the evolution of ARR by product

Objectives : 
- Each line is a unique combination of a product and a billing_period_date
- For each unique combination we provide :
  - The number of distinct account id
  - the MRR
  - the ARR
  - the total number of licenses
  - the average ARR by licenses

Source table : 
- `data-technical-cases.mguerout.cc_decompte_cleaned`
*/

CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex2_arr_mensuel_par_produit` AS
SELECT 
  produit_standardise as produit,
  billing_period_date as mois,
  
  -- Nombre de comptes utilisant ce produit ce mois-ci
  COUNT(DISTINCT cc_account_id) as nb_comptes,
  
  -- MRR total ce mois-ci
  SUM(revenue) as mrr_total,
  
  -- ARR total ce mois-ci (MRR × 12)
  SUM(revenue * 12) as arr_total,
  
  -- ARR moyen par compte
  ROUND(AVG(revenue * 12), 0) as arr_moyen_par_compte,
  
  -- Nombre total de licences
  SUM(headcount) as nb_licences_total,
  
  -- ARR moyen par licence
  ROUND(AVG(revenue * 12 / NULLIF(headcount, 0)), 0) as arr_par_licence

FROM `data-technical-cases.mguerout.cc_decompte_cleaned`
WHERE produit_standardise IS NOT NULL
  AND produit_standardise != 'Autre'
  AND headcount > 0
  AND revenue > 0
GROUP BY produit, mois
ORDER BY produit, mois;
