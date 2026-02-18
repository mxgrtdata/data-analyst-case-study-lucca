CREATE OR REPLACE TABLE `data-technical-cases.mguerout.ex2_performance_produits_bookings` AS
SELECT 
  Produit_interesse as produit,
  
  -- Nombre d'opportunités
  COUNT(DISTINCT Id) as nb_opportunites_total,
  
  -- Opportunités gagnées
  COUNT(DISTINCT CASE WHEN IsWon = TRUE THEN Id END) as nb_opportunites_won,
  
  -- Opportunités perdues
  COUNT(DISTINCT CASE WHEN IsWon = FALSE THEN Id END) as nb_opportunites_lost,
  
  -- Taux de conversion
  ROUND(COUNT(DISTINCT CASE WHEN IsWon = TRUE THEN Id END) * 100.0 / 
        NULLIF(COUNT(DISTINCT Id), 0), 1) as taux_conversion_pct,

FROM `data-technical-cases.mguerout.salesforce_opportunity_cleaned`
GROUP BY produit
ORDER BY nb_opportunites_won DESC;
