-- Requ�te SQL pour joindre la table dim_customers avec dim_geography afin d'enrichir les donn�es des clients avec des informations g�ographiques

SELECT 
    c.CustomerID,  -- S�lectionne l'identifiant unique de chaque client
    c.CustomerName,  -- S�lectionne le nom de chaque client
    c.Email,  -- S�lectionne l'adresse email de chaque client
    c.Gender,  -- S�lectionne le genre de chaque client
    c.Age,  -- S�lectionne l'�ge de chaque client
    g.Country,  -- S�lectionne le pays � partir de la table geography pour enrichir les donn�es des clients
    g.City  -- S�lectionne la ville � partir de la table geography pour enrichir les donn�es des clients
FROM 
    dbo.customers AS c  
LEFT JOIN 
    -- RIGHT JOIN 
    -- INNER JOIN 
    -- FULL OUTER JOIN
    dbo.geography AS g  
ON 
    c.GeographyID = g.GeographyID;  -- Associe les deux tables sur le champ GeographyID pour faire correspondre les clients avec leurs informations g�ographiques
