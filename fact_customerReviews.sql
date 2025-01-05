-- Requête pour corriger les problèmes d'espaces dans la colonne ReviewText
--SELECT * FROM dbo.customer_reviews;
SELECT 
    ReviewID,  -- Sélectionne l'identifiant unique de chaque avis
    CustomerID,  -- Sélectionne l'identifiant unique de chaque client
    ProductID,  -- Sélectionne l'identifiant unique de chaque produit
    ReviewDate,  -- Sélectionne la date à laquelle l'avis a été rédigé
    Rating,  -- Sélectionne la note numérique attribuée par le client (par exemple, de 1 à 5 étoiles)
    -- Nettoie la colonne ReviewText en remplaçant les doubles espaces par des espaces simples pour rendre le texte plus lisible et standardisé
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM 
    dbo.customer_reviews;  -- Spécifie la table source contenant les avis clients
