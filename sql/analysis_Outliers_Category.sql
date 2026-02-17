CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex1_comptes_outliers` AS
SELECT 
  a.AccountCategorie__c as categorie,
  s.cc_account_id,
  ROUND(AVG(s.headcount), 0) as headcount_moyen,
  ROUND(AVG(s.revenue * 12), 0) as arr_moyen,
  
  -- Catégorie théorique
  CASE 
    WHEN AVG(s.headcount) < 100 THEN 'Devrait être Bronze'
    WHEN AVG(s.headcount) < 250 THEN 'Devrait être Silver'
    WHEN AVG(s.headcount) < 500 THEN 'Devrait être Gold'
    ELSE 'Devrait être Platinium'
  END as categorie_theorique,
  
  -- Statut
  CASE 
    WHEN (a.AccountCategorie__c = 'Bronze' AND AVG(s.headcount) >= 100) THEN 'Mal catégorisé ⚠️'
    WHEN (a.AccountCategorie__c = 'Silver' AND (AVG(s.headcount) < 100 OR AVG(s.headcount) >= 250)) THEN 'Mal catégorisé ⚠️'
    WHEN (a.AccountCategorie__c = 'Gold' AND (AVG(s.headcount) < 250 OR AVG(s.headcount) >= 500)) THEN 'Mal catégorisé ⚠️'
    WHEN (a.AccountCategorie__c = 'Platinium' AND AVG(s.headcount) < 500) THEN 'Mal catégorisé ⚠️'
    ELSE 'OK ✅'
  END as statut

FROM `data-technical-cases.mguerout.cc_decompte_cleaned` s
LEFT JOIN `data-technical-cases.mguerout.salesforce_account_clean_ex1` a
  ON s.cc_account_id = a.ID_CC__c
WHERE a.AccountCategorie__c IN ('Bronze', 'Silver', 'Gold', 'Platinium')
  AND s.headcount > 0
GROUP BY cc_account_id, categorie
HAVING statut = 'Mal catégorisé ⚠️'
ORDER BY headcount_moyen DESC;
