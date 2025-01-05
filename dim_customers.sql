-- Requête SQL pour joindre la table dim_customers avec dim_geography afin d'enrichir les données des clients avec des informations géographiques

SELECT 
    c.CustomerID,  -- Sélectionne l'identifiant unique de chaque client
    c.CustomerName,  -- Sélectionne le nom de chaque client
    c.Email,  -- Sélectionne l'adresse email de chaque client
    c.Gender,  -- Sélectionne le genre de chaque client
    c.Age,  -- Sélectionne l'âge de chaque client
    g.Country,  -- Sélectionne le pays à partir de la table geography pour enrichir les données des clients
    g.City  -- Sélectionne la ville à partir de la table geography pour enrichir les données des clients
FROM 
    dbo.customers AS c  
LEFT JOIN 
    -- RIGHT JOIN 
    -- INNER JOIN 
    -- FULL OUTER JOIN
    dbo.geography AS g  
ON 
    c.GeographyID = g.GeographyID;  -- Associe les deux tables sur le champ GeographyID pour faire correspondre les clients avec leurs informations géographiques
