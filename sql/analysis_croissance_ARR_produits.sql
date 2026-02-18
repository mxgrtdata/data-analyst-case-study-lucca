CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex2_croissance_arr_produits` AS
WITH stats_debut_fin AS (
  SELECT 
    produit,
    
    -- Premier mois
    FIRST_VALUE(mois) OVER (PARTITION BY produit ORDER BY mois) as date_debut,
    FIRST_VALUE(arr_total) OVER (PARTITION BY produit ORDER BY mois) as arr_debut,
    FIRST_VALUE(nb_comptes) OVER (PARTITION BY produit ORDER BY mois) as nb_comptes_debut,
    FIRST_VALUE(arr_moyen_par_compte) OVER (PARTITION BY produit ORDER BY mois) as arr_moyen_debut,
    
    -- Dernier mois
    LAST_VALUE(mois) OVER w as date_fin,
    LAST_VALUE(arr_total) OVER w as arr_fin,
    LAST_VALUE(nb_comptes) OVER w as nb_comptes_fin,
    LAST_VALUE(arr_moyen_par_compte) OVER w as arr_moyen_fin
    
  FROM `data-technical-cases.mguerout.ex2_arr_mensuel_par_produit`
  WINDOW w AS (PARTITION BY produit ORDER BY mois ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
)
SELECT DISTINCT
  produit,
  date_debut,
  date_fin,
  
  -- ARR total
  ROUND(arr_debut, 0) as arr_debut,
  ROUND(arr_fin, 0) as arr_fin,
  ROUND(arr_fin - arr_debut, 0) as arr_variation_absolue,
  ROUND((arr_fin - arr_debut) * 100.0 / NULLIF(arr_debut, 0), 1) as arr_croissance_pct,
  
  -- Nombre de comptes
  nb_comptes_debut,
  nb_comptes_fin,
  ROUND((nb_comptes_fin - nb_comptes_debut) * 100.0 / NULLIF(nb_comptes_debut, 0), 1) as nb_comptes_croissance_pct,
  
  -- ARR moyen par compte
  ROUND(arr_moyen_debut, 0) as arr_moyen_debut,
  ROUND(arr_moyen_fin, 0) as arr_moyen_fin,
  ROUND((arr_moyen_fin - arr_moyen_debut) * 100.0 / NULLIF(arr_moyen_debut, 0), 1) as arr_moyen_croissance_pct

FROM stats_debut_fin
ORDER BY arr_croissance_pct DESC;
