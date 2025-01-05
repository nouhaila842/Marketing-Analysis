-- Requ�te pour corriger les probl�mes d'espaces dans la colonne ReviewText
--SELECT * FROM dbo.customer_reviews;
SELECT 
    ReviewID,  -- S�lectionne l'identifiant unique de chaque avis
    CustomerID,  -- S�lectionne l'identifiant unique de chaque client
    ProductID,  -- S�lectionne l'identifiant unique de chaque produit
    ReviewDate,  -- S�lectionne la date � laquelle l'avis a �t� r�dig�
    Rating,  -- S�lectionne la note num�rique attribu�e par le client (par exemple, de 1 � 5 �toiles)
    -- Nettoie la colonne ReviewText en rempla�ant les doubles espaces par des espaces simples pour rendre le texte plus lisible et standardis�
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM 
    dbo.customer_reviews;  -- Sp�cifie la table source contenant les avis clients
