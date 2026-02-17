/* STEP 1 : Create a cleaned cc_decompte table

Objectives : 
- Standardize names for the product column

Source table : 
- `data-technical-cases.da_case.cc_decompte`
*/

CREATE OR REPLACE TABLE `data-technical-cases.mguerout.cc_decompte_cleaned` AS
SELECT 
  *,
  CASE 
    -- Timmi
    WHEN Product LIKE '%Timmi Absences%' OR Product LIKE '%Timmi Ausencias%' THEN 'Timmi Absences'
    WHEN Product LIKE '%Timmi Temps%' OR Product LIKE '%Timmi Timesheet%' OR Product LIKE '%Timmi Control horario%' THEN 'Timmi Temps'
    WHEN Product LIKE '%Timmi Office%' OR Product LIKE '%Timmi Oficina%' THEN 'Timmi Office'
    WHEN Product LIKE '%Timmi Congés%' THEN 'Timmi Congés'
    WHEN Product LIKE '%Timmi Projets%' OR Product LIKE '%Timmi Proyectos%' THEN 'Timmi Projets'
    
    -- Pagga
    WHEN Product LIKE '%Pagga Bulletin%' OR Product LIKE '%Pagga Nomina%' OR Product LIKE '%Pagga Payslip%' OR Product LIKE '%Pagga Fiche de salaire%' THEN 'Pagga Bulletin de paie'
    WHEN Product LIKE '%Pagga Rémunération%' OR Product LIKE '%Pagga Masa salarial%' OR Product LIKE '%Pagga rémunération%'  THEN 'Pagga Rémunération'
    WHEN Product LIKE '%Pagga Assistant Paie%' THEN 'Pagga Assistant Paie'
    
    -- Cleemy
    WHEN Product LIKE '%Cleemy Notes de frais%' OR Product LIKE '%Notas de gastos%' OR Product LIKE '%Cleemy Note de frais%' OR Product LIKE '%Cleemy Note%' THEN 'Cleemy Note de frais'
    WHEN Product LIKE '%Cleemy Achats%' OR Product LIKE '%Notas de gastos%' THEN 'Cleemy Note de frais'
    WHEN Product LIKE '%Cleemy Dépenses%' THEN 'Cleemy Dépenses'
    WHEN Product LIKE '%Cleemy Paiement%' THEN 'Cleemy Paiement'
    WHEN Product LIKE '%Cleemy Banking%' THEN 'Cleemy Banking'

    -- Poplee
    WHEN Product LIKE '%Poplee Entretien%' THEN 'Poplee Entretien'
    WHEN Product LIKE '%Poplee Engagement%' THEN 'Poplee Engagement'
    WHEN Product LIKE '%Poplee Formation%' OR Product LIKE '%Poplee Formación%' THEN 'Poplee Formation'
    WHEN Product LIKE '%Poplee Desempeno%' THEN 'Poplee Performances'
    WHEN Product LIKE '%Poplee Core HR%' THEN 'Poplee Core HR'
    WHEN Product LIKE '%Poplee Clima Laboral%' THEN 'Poplee Climat de travail'
    WHEN Product LIKE '%Poplee sans signature%' THEN 'Poplee sans signature'

    -- Socle RH
    WHEN Product LIKE '%Socle RH%' THEN 'Socle RH'
    
    -- Suites
    WHEN Product LIKE '%Suite Essentiel%' OR Product LIKE '%Suite Esencial%' OR Product LIKE '%Suite essentiel%' THEN 'Suite Essentiel SIRH'
    WHEN Product LIKE '%Suite Lucca%' THEN 'Suite Lucca'
    WHEN Product LIKE '%Suite Startup%' THEN 'Suite Startup'
    
    -- Plans (Espagne)
    WHEN Product LIKE '%Plan Profesional%' THEN 'Plan Profesional'
    
    -- Connecteurs et services
    WHEN Product LIKE '%Connecteur%' THEN 'Connecteurs'
    WHEN Product LIKE '%Lucca Connect%' THEN 'Lucca Connect'
    WHEN Product LIKE '%Capture%' OR Product LIKE '%Collect%' THEN 'Capture & Collect'
    WHEN Product LIKE '%Budget Insight%' THEN 'Budget Insight'
    WHEN Product LIKE '%Lucca pour la Paie%' THEN 'Lucca pour la Paie'
    
    -- Anciens produits
    WHEN Product LIKE '%Calendar%' THEN 'Calendar'
    WHEN Product LIKE '%Timesheet%' THEN 'Timesheet'
    WHEN Product LIKE '%Spensy%' THEN 'Spensy'
    WHEN Product LIKE '%Urba%' THEN 'Urba'
    
    -- Divers
    WHEN Product LIKE '%Sandbox%' THEN 'Sandbox'
    WHEN Product LIKE '%Retention Log%' THEN 'Retention Log'
    
    ELSE 'Autre'
  END as produit_standardise
  
FROM `data-technical-cases.da_case.cc_decompte`;
