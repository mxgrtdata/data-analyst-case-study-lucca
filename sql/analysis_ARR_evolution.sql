CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex1_arr_evolution_typologie` AS
SELECT 
  COALESCE(a.AccountCategorie__c, 'Non catégorisé') as typologie,
  s.billing_period_date as mois,
  COUNT(DISTINCT s.cc_account_id) as nb_comptes,
  AVG(s.revenue * 12) as arr_moyen,
  SUM(s.revenue * 12) as arr_total,
  AVG(s.headcount) as headcount_moyen,
  AVG(s.revenue * 12 / NULLIF(s.headcount, 0)) as arr_par_licence
FROM `data-technical-cases.mguerout.cc_decompte_cleaned` s
LEFT JOIN `data-technical-cases.mguerout.salesforce_account_clean_ex1` a
  ON s.cc_account_id = a.ID_CC__c
WHERE s.headcount > 0
  AND s.revenue > 0
GROUP BY typologie, mois
ORDER BY typologie, mois;
