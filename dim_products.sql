-- Requ�te SQL pour classer les produits en fonction de leur prix
--SELECT * FROM dbo.products;
SELECT 
    ProductID,  -- S�lectionne l'identifiant unique de chaque produit
    ProductName,  -- S�lectionne le nom de chaque produit
    Price,  -- S�lectionne le prix de chaque produit
    -- Category, -- Permettrait de s�lectionner la cat�gorie du produit si n�cessaire

    CASE 
        -- Classe les produits en fonction de leur prix dans des cat�gories : Bas, Moyen ou �lev�
        WHEN Price < 50 THEN 'Bas'  -- Si le prix est inf�rieur � 50, class� comme 'Bas'
        WHEN Price BETWEEN 50 AND 200 THEN 'Moyen'  -- Si le prix est entre 50 et 200 (inclus), class� comme 'Moyen'
        ELSE '�lev�'  -- Si le prix est sup�rieur � 200, class� comme '�lev�'
    END AS PriceCategory  -- Nomme la nouvelle colonne comme PriceCategory

FROM 
    dbo.products;  -- Sp�cifie la table source d'o� proviennent les donn�es
