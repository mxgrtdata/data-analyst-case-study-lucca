CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex1_taux_croissance_typologie` AS
WITH premier_dernier_mois AS (
  SELECT 
    typologie,
    
    -- Premier mois
    FIRST_VALUE(arr_moyen) OVER (
      PARTITION BY typologie 
      ORDER BY mois
    ) as arr_debut,
    FIRST_VALUE(mois) OVER (
      PARTITION BY typologie 
      ORDER BY mois
    ) as date_debut,
    
    -- Dernier mois
    LAST_VALUE(arr_moyen) OVER (
      PARTITION BY typologie 
      ORDER BY mois 
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as arr_fin,
    LAST_VALUE(mois) OVER (
      PARTITION BY typologie 
      ORDER BY mois 
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) as date_fin,
    
    ROW_NUMBER() OVER (PARTITION BY typologie ORDER BY mois) as rn
    
  FROM `data-technical-cases.mguerout.ex1_arr_evolution_typologie`
  WHERE typologie IN ('Bronze', 'Silver', 'Gold', 'Platinium')
)
SELECT 
  typologie,
  date_debut,
  ROUND(arr_debut, 2) as arr_debut,
  date_fin,
  ROUND(arr_fin, 2) as arr_fin,
  ROUND(arr_fin - arr_debut, 2) as variation_absolue,
  ROUND((arr_fin - arr_debut) * 100.0 / arr_debut, 2) as taux_croissance_pct
FROM premier_dernier_mois
WHERE rn = 1
ORDER BY taux_croissance_pct DESC;
