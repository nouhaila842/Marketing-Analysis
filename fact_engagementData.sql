-- Requ�te pour nettoyer et normaliser la table engagement_data

SELECT 
    EngagementID,  -- S�lectionne l'identifiant unique de chaque enregistrement d'engagement
    ContentID,  -- S�lectionne l'identifiant unique de chaque contenu
    CampaignID,  -- S�lectionne l'identifiant unique de chaque campagne marketing
    ProductID,  -- S�lectionne l'identifiant unique de chaque produit
    -- Remplace "Socialmedia" par "Social Media", puis convertit toutes les valeurs de ContentType en majuscules
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,
    -- Extrait la partie 'Views' de la colonne ViewsClicksCombined (avant le caract�re '-')
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,
    -- Extrait la partie 'Clicks' de la colonne ViewsClicksCombined (apr�s le caract�re '-')
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,
    Likes,  -- S�lectionne le nombre de mentions "J'aime" re�ues par le contenu
    -- Convertit et formate la date d'engagement au format dd.mm.yyyy
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate  
FROM 
    dbo.engagement_data 
WHERE 
    ContentType != 'Newsletter';  -- Exclut les lignes o� ContentType est 'Newsletter', car elles ne sont pas pertinentes pour l'analyse
