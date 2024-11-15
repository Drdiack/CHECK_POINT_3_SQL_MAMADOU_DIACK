
------1.Executer le script 
OK
------2 Écrivez chacune des requêtes suivantes en SQL.
OK
-----3 Question 3
select * from EMPLOYEES ; 
--Question 3 3.	Affichez, par ordre décroissant d’ancienneté, les salariés masculins dont le salaire net (salaire + commission) est supérieur ou égal à 8000. Le tableau qui en résulte doit inclure les colonnes suivantes : Numéro d’employé, Prénom et Nom (en utilisant LPAD ou RPAD pour le formatage), Âge et Ancienneté.
select salary + commission as full_salary  From EMPLOYEES;
select DATEDIFF (year, HIRE_DATE, '2024-11-05') as Seniority FROM EMPLOYEES;
select salary + Commission  as full_salary , DATEDIFF(Year ,HIRE_DATE, '2024-11-05') as Seniority , EMPLOYEE_NUMBER
FROM EMPLOYEES
where salary + commission >= 8000 and Title ='Dr'
Order by Seniority DESC;

---4.	Affichez les produits qui répondent aux critères suivants : (C1) la quantité est emballée dans une ou plusieurs bouteilles, (C2) le troisième caractère du nom du produit est « t » ou « T », (C3) fourni par les fournisseurs 1, 2 ou 3, (C4) les prix unitaires varient entre 70 et 200 et (C5) les unités commandées sont spécifiées (non null). Le tableau qui en résulte doit inclure les colonnes suivantes : numéro de produit, nom du produit, numéro de fournisseur, unités commandées et prix unitaire.


SELECT PRODUCT_REF, PRODUCT_NAME, SUPPLIER_NUMBER, UNITS_ON_ORDER, UNIT_PRICE
from PRODUCTS
WHERE
(QUANTITY LIKE '%bottles%'  Or QUANTITY LIKE '%bottles%')
AND
(PRODUCT_NAME LIKE '_t_%' OR PRODUCT_NAME LIKE '_T_%')
AND 
(SUPPLIER_NUMBER BETWEEN '%1%' Or SUPPLIER_NUMBER LIKE '%2%'OR SUPPLIER_NUMBER  LIKE '%3%')
AND
(UNIT_PRICE BETWEEN 70 and 200)
AND
UNITS_ON_ORDER <> NULL;

-----5.	Affichez les clients qui résident dans la même région que le fournisseur 1, c’est-à-dire qu’ils partagent le même pays, la même ville et les trois derniers chiffres du code postal. La requête doit utiliser une seule sous-requête. La table résultante doit inclure toutes les colonnes de la table customer.

select  * FROM CUSTOMERS
join SUPPLIERS ON  SUPPLIERS.COUNTRY = CUSTOMERS.COUNTRY 
wHERE SUPPLIER_NUMBER= 1 AND CUSTOMERS.COUNTRY = SUPPLIERS.COUNTRY  AND SUPPLIERS.POSTAL_CODE  = CUSTOMERS.POSTAL_CODE;

-----6.	Pour chaque numéro de commande compris entre 10998 et 11003, procédez comme suit :
----Affichez le nouveau taux de remise, qui doit être de 0% si le montant total de la commande avant remise (prix unitaire * quantité) est compris entre 0 et 2000, 5% si entre 2001 et 10000, 10% si entre 10001 et 40000, 15% si entre 40001 et 80000, et 20% sinon.
----Afficher le message « appliquer l’ancien taux de remise » si le numéro de commande est compris entre 10000 et 10999, et « appliquer le nouveau taux de remise » dans le cas contraire. Le tableau qui s’affiche doit afficher les colonnes : numéro de commande, nouveau taux de remise et note d’application du taux de remise.
Select ORDER_NUMBER,
CASE 
WHEN (UNIT_PRICE*QUANTITY) BETWEEN 0 AND 2000 THEN 0
WHEN (UNIT_PRICE*QUANTITY) BETWEEN 2001 AND 10000 THEN 5
WHEN (UNIT_PRICE*QUANTITY) BETWEEN 10001 AND 40000 THEN 10
WHEN (UNIT_PRICE*QUANTITY) BETWEEN 40001 AND 80000 THEN 15
ELSE 20
END AS nouveau_taux_de_remise,
CASE
WHEN ORDER_NUMBER BETWEEN 10000 AND 10999 THEN 'APPLIQUER-lancien_taux'
ELSE 'appliquer_nouveau_taux_de_remise'
END AS taux_de_remise
from ORDER_DETAILS 
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003 ;

-------8) Affichez les clients de Berlin qui ont commandé au plus 1 (0 ou 1) produit de dessert. La table résultante doit afficher la colonne : code client.
Select C.CUSTOMER_CODE,CATEGORY_NAME,CITY
FROM CUSTOMERS C
JOIN Orders O ON C.CUSTOMER_CODE= O.CUSTOMER_CODE
JOIN ORDER_DETAILS   OD ON O.ORDER_NUMBER= OD.ORDER_NUMBER
JOIN PRODUCTS P ON OD.PRODUCT_REF= P.PRODUCT_REF
JOIN CATEGORIES CAT ON P.CATEGORY_CODE= CAT.CATEGORY_CODE
WHERE C.CITY LIKE '%Berl%';
-----9) Affichez les clients qui résident en France et le montant total des commandes qu’ils ont passées tous les lundis d’avril 1998 (en tenant compte des clients qui n’ont pas encore passé de commande). Le tableau résultant doit afficher les colonnes suivantes : numéro de client, nom de l’entreprise, numéro de téléphone, montant total et pays.
Select C.CUSTOMER_CODE AS Customer_number,
C.COMPANY AS compagny_name,
C.Phone AS phone_number,
COALESCE(SUM(OD.UNIT_PRICE*OD.QUANTITY),0) AS total_amount,
C.COUNTRY AS country
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_CODE= O.CUSTOMER_CODE
AND O.ORDER_DATE LIKE '1998-04-%' 
AND DATENAME(WEEKDAY,ORDER_DATE)='Lundi'
LEFT JOIN ORDER_DETAILS OD ON O.ORDER_NUMBER = OD.ORDER_NUMBER
WHERE C. COUNTRY = 'France'
Group By C.CUSTOMER_CODE ,C.COMPANY , C.PHONE,C.COUNTRY ; 

---10 Affichez les clients qui ont commandé tous les produits. Le tableau qui s’affiche doit afficher les colonnes : code client, nom de l’entreprise et numéro de téléphone.
SELECT CUSTOMERS.CUSTOMER_CODE, COMPANY,PHONE
FROM CUSTOMERS
JOIN ORDERS ON CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
JOIN ORDER_DETAILS ON ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
JOIN PRODUCTS ON PRODUCTS.PRODUCT_REF = ORDER_DETAILS.PRODUCT_REF
GROUP BY CUSTOMERS.CUSTOMER_CODE, COMPANY, PHONE
HAVING (SELECT COUNT (*) FROM PRODUCTS) = COUNT (DISTINCT ORDER_DETAILS.PRODUCT_REF);   

------ 11 Afficher pour chaque client depuis la France le nombre de commandes qu’il a passées. Le tableau qui s’affiche doit afficher les colonnes : code client et nombre de commandes.

SELECT ORDERS.CUSTOMER_CODE,count(ORDER_DETAILS.PRODUCT_REF) AS NOMBRE_DE_COMMANDE
FROM ORDERS
JOIN CUSTOMERS ON  CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
JOIN ORDER_DETAILS ON ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER 
WHERE CUSTOMERS.COUNTRY LIKE '%Fran%'
GROUP BY ORDERS.CUSTOMER_CODE ;

-----12.	Affichez le nombre de commandes passées en 1996, le nombre de commandes passées en 1997 et la différence entre ces deux chiffres. Le tableau qui s’affiche doit afficher les colonnes : commandes en 1996, commandes en 1997 et Différence


SELECT 
(SELECT COUNT(*) FROM ORDERS WHERE YEAR(ORDER_DATE) = 1996) as commande_1996,
(SELECT COUNT(*) FROM ORDERS WHERE YEAR(ORDER_DATE) = 1997)  as commande_1997,
(SELECT COUNT(*) FROM ORDERS WHERE YEAR(ORDER_DATE) = 1996) 
(SELECT COUNT(*) FROM ORDERS WHERE YEAR(ORDER_DATE) = 1997)  ;