-- Requête SQL pour classer les produits en fonction de leur prix
--SELECT * FROM dbo.products;
SELECT 
    ProductID,  -- Sélectionne l'identifiant unique de chaque produit
    ProductName,  -- Sélectionne le nom de chaque produit
    Price,  -- Sélectionne le prix de chaque produit
    -- Category, -- Permettrait de sélectionner la catégorie du produit si nécessaire

    CASE 
        -- Classe les produits en fonction de leur prix dans des catégories : Bas, Moyen ou Élevé
        WHEN Price < 50 THEN 'Bas'  -- Si le prix est inférieur à 50, classé comme 'Bas'
        WHEN Price BETWEEN 50 AND 200 THEN 'Moyen'  -- Si le prix est entre 50 et 200 (inclus), classé comme 'Moyen'
        ELSE 'Élevé'  -- Si le prix est supérieur à 200, classé comme 'Élevé'
    END AS PriceCategory  -- Nomme la nouvelle colonne comme PriceCategory

FROM 
    dbo.products;  -- Spécifie la table source d'où proviennent les données
