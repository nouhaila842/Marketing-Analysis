-- Common Table Expression (CTE) pour identifier et marquer les enregistrements en double

WITH DuplicateRecords AS (
    SELECT 
        JourneyID,  -- Sélectionne l'identifiant unique pour chaque parcours client
        CustomerID,  -- Sélectionne l'identifiant unique pour chaque client
        ProductID,  -- Sélectionne l'identifiant unique pour chaque produit
        VisitDate,  -- Sélectionne la date de la visite pour comprendre la chronologie des interactions clients
        Stage,  -- Sélectionne l'étape du parcours client (ex : Sensibilisation, Considération, etc.)
        Action,  -- Sélectionne l'action effectuée par le client (ex : Vue, Clic, Achat)
        Duration,  -- Sélectionne la durée de l'interaction ou de l'action
        -- Utilise ROW_NUMBER() pour attribuer un numéro unique à chaque enregistrement dans une partition définie ci-dessous
        ROW_NUMBER() OVER (
            -- PARTITION BY regroupe les lignes en fonction des colonnes qui doivent être uniques
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY définit l'ordre des lignes dans chaque partition (souvent par un identifiant unique comme JourneyID)
            ORDER BY JourneyID  
        ) AS row_num  -- Crée une nouvelle colonne 'row_num' qui numérote chaque ligne dans sa partition
    FROM 
        dbo.customer_journey 
)

-- Sélectionne tous les enregistrements de la CTE où row_num > 1, ce qui indique des doublons

SELECT *
FROM DuplicateRecords
-- WHERE row_num > 1  -- Filtre les occurrences initiales (row_num = 1) et affiche uniquement les doublons (row_num > 1)
ORDER BY JourneyID;

-- Requête principale pour sélectionner les données nettoyées et standardisées

SELECT 
    JourneyID,  -- Sélectionne l'identifiant unique de chaque parcours client pour assurer la traçabilité des données
    CustomerID,  -- Sélectionne l'identifiant unique de chaque client pour lier les parcours à des clients spécifiques
    ProductID,  -- Sélectionne l'identifiant unique de chaque produit pour analyser les interactions clients-produits
    VisitDate,  -- Sélectionne la date de la visite pour comprendre la chronologie des interactions clients
    Stage,  -- Utilise la valeur des étapes en majuscules pour une cohérence dans l'analyse
    Action,  -- Sélectionne l'action réalisée par le client (ex : Vue, Clic, Achat)
    COALESCE(Duration, avg_duration) AS Duration  -- Remplace les durées manquantes par la durée moyenne pour la date correspondante
FROM 
    (
        -- Sous-requête pour traiter et nettoyer les données
        SELECT 
            JourneyID,  -- Sélectionne l'identifiant unique de chaque parcours client pour assurer la traçabilité des données
            CustomerID,  -- Sélectionne l'identifiant unique de chaque client pour lier les parcours à des clients spécifiques
            ProductID,  -- Sélectionne l'identifiant unique de chaque produit pour analyser les interactions clients-produits
            VisitDate,  -- Sélectionne la date de la visite pour comprendre la chronologie des interactions clients
            UPPER(Stage) AS Stage,  -- Convertit les valeurs des étapes en majuscules pour une cohérence dans l'analyse
            Action,  -- Sélectionne l'action réalisée par le client (ex : Vue, Clic, Achat)
            Duration,  -- Utilise directement la colonne Duration, supposée être de type numérique
            AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,  -- Calcule la durée moyenne pour chaque date
            ROW_NUMBER() OVER (
                PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Regroupe par ces colonnes pour identifier les doublons
                ORDER BY JourneyID  -- Trie par JourneyID pour conserver la première occurrence de chaque doublon
            ) AS row_num  -- Associe un numéro de ligne à chaque ligne dans la partition pour identifier les doublons
        FROM 
            dbo.customer_journey  
    ) AS subquery  -- Nomme la sous-requête pour référence dans la requête externe
WHERE 
    row_num = 1;  -- Garde uniquement la première occurrence de chaque groupe de doublons identifié dans la sous-requête
