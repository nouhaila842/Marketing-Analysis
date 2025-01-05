-- Common Table Expression (CTE) pour identifier et marquer les enregistrements en double

WITH DuplicateRecords AS (
    SELECT 
        JourneyID,  -- S�lectionne l'identifiant unique pour chaque parcours client
        CustomerID,  -- S�lectionne l'identifiant unique pour chaque client
        ProductID,  -- S�lectionne l'identifiant unique pour chaque produit
        VisitDate,  -- S�lectionne la date de la visite pour comprendre la chronologie des interactions clients
        Stage,  -- S�lectionne l'�tape du parcours client (ex : Sensibilisation, Consid�ration, etc.)
        Action,  -- S�lectionne l'action effectu�e par le client (ex : Vue, Clic, Achat)
        Duration,  -- S�lectionne la dur�e de l'interaction ou de l'action
        -- Utilise ROW_NUMBER() pour attribuer un num�ro unique � chaque enregistrement dans une partition d�finie ci-dessous
        ROW_NUMBER() OVER (
            -- PARTITION BY regroupe les lignes en fonction des colonnes qui doivent �tre uniques
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY d�finit l'ordre des lignes dans chaque partition (souvent par un identifiant unique comme JourneyID)
            ORDER BY JourneyID  
        ) AS row_num  -- Cr�e une nouvelle colonne 'row_num' qui num�rote chaque ligne dans sa partition
    FROM 
        dbo.customer_journey 
)

-- S�lectionne tous les enregistrements de la CTE o� row_num > 1, ce qui indique des doublons

SELECT *
FROM DuplicateRecords
-- WHERE row_num > 1  -- Filtre les occurrences initiales (row_num = 1) et affiche uniquement les doublons (row_num > 1)
ORDER BY JourneyID;

-- Requ�te principale pour s�lectionner les donn�es nettoy�es et standardis�es

SELECT 
    JourneyID,  -- S�lectionne l'identifiant unique de chaque parcours client pour assurer la tra�abilit� des donn�es
    CustomerID,  -- S�lectionne l'identifiant unique de chaque client pour lier les parcours � des clients sp�cifiques
    ProductID,  -- S�lectionne l'identifiant unique de chaque produit pour analyser les interactions clients-produits
    VisitDate,  -- S�lectionne la date de la visite pour comprendre la chronologie des interactions clients
    Stage,  -- Utilise la valeur des �tapes en majuscules pour une coh�rence dans l'analyse
    Action,  -- S�lectionne l'action r�alis�e par le client (ex : Vue, Clic, Achat)
    COALESCE(Duration, avg_duration) AS Duration  -- Remplace les dur�es manquantes par la dur�e moyenne pour la date correspondante
FROM 
    (
        -- Sous-requ�te pour traiter et nettoyer les donn�es
        SELECT 
            JourneyID,  -- S�lectionne l'identifiant unique de chaque parcours client pour assurer la tra�abilit� des donn�es
            CustomerID,  -- S�lectionne l'identifiant unique de chaque client pour lier les parcours � des clients sp�cifiques
            ProductID,  -- S�lectionne l'identifiant unique de chaque produit pour analyser les interactions clients-produits
            VisitDate,  -- S�lectionne la date de la visite pour comprendre la chronologie des interactions clients
            UPPER(Stage) AS Stage,  -- Convertit les valeurs des �tapes en majuscules pour une coh�rence dans l'analyse
            Action,  -- S�lectionne l'action r�alis�e par le client (ex : Vue, Clic, Achat)
            Duration,  -- Utilise directement la colonne Duration, suppos�e �tre de type num�rique
            AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,  -- Calcule la dur�e moyenne pour chaque date
            ROW_NUMBER() OVER (
                PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Regroupe par ces colonnes pour identifier les doublons
                ORDER BY JourneyID  -- Trie par JourneyID pour conserver la premi�re occurrence de chaque doublon
            ) AS row_num  -- Associe un num�ro de ligne � chaque ligne dans la partition pour identifier les doublons
        FROM 
            dbo.customer_journey  
    ) AS subquery  -- Nomme la sous-requ�te pour r�f�rence dans la requ�te externe
WHERE 
    row_num = 1;  -- Garde uniquement la premi�re occurrence de chaque groupe de doublons identifi� dans la sous-requ�te
