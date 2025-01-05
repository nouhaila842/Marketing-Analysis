-- Requête pour nettoyer et normaliser la table engagement_data

SELECT 
    EngagementID,  -- Sélectionne l'identifiant unique de chaque enregistrement d'engagement
    ContentID,  -- Sélectionne l'identifiant unique de chaque contenu
    CampaignID,  -- Sélectionne l'identifiant unique de chaque campagne marketing
    ProductID,  -- Sélectionne l'identifiant unique de chaque produit
    -- Remplace "Socialmedia" par "Social Media", puis convertit toutes les valeurs de ContentType en majuscules
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
    -- Extrait la partie 'Views' de la colonne ViewsClicksCombined (avant le caractère '-')
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,
    -- Extrait la partie 'Clicks' de la colonne ViewsClicksCombined (après le caractère '-')
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,
    Likes,  -- Sélectionne le nombre de mentions "J'aime" reçues par le contenu
    -- Convertit et formate la date d'engagement au format dd.mm.yyyy
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate  
FROM 
    dbo.engagement_data 
WHERE 
    ContentType != 'Newsletter';  -- Exclut les lignes où ContentType est 'Newsletter', car elles ne sont pas pertinentes pour l'analyse
