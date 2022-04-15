CREATE DATABASE KontaktHome

USE KontaktHome

CREATE TABLE Categories (

	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50)

)


INSERT INTO Categories
VALUES ('Phones'),('Tablets'),('Headphones')



CREATE TABLE Products(

	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(50),
	Model NVARCHAR(50),
	CostPrice FLOAT,
	SalePrice	FLOAT,
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id)


)


INSERT INTO Products 
VALUES ('Apple','Iphone SE', 1200, 1699.99,1),
		('Samsung','Galaxy A23', 450, 619.99,1),
		('Xiaomi','Redmi Note 11S', 519.99,629.99,1),
		('HUAWEI','Nova 9 SE',489.99,699.99,1),
		('Xiaomi','Pad 5', 590,799.99,2),
		('Apple','Ipad Air', 1389.99,1849.99,2),
		('Samsung','Galaxy Tab A8',380,579.99,2),
		('HUAWEI','MetaPad',320, 499.99,2),
		('JBL','Club',399.99,549.99,3),
		('TWS','Aiwa',19.99,39.99,3)




CREATE TABLE Cart (

	Id INT PRIMARY KEY IDENTITY,
	ProductId  INT FOREIGN KEY REFERENCES Products(Id)

)



INSERT INTO Cart
VALUES (2),(7),(10)


--1) Kartin icindeki melumatlari cixartmaq
CREATE VIEW GetProductDetails
AS
SELECT p.Name as [Product Name],
		p.Model,
		p.CostPrice as [Cost Price],
		p.SalePrice as [Sale Price],
		ct.Name as [Category]
FROM Cart c
INNER JOIN Products p on p.Id= c.ProductId
INNER JOIN	Categories ct on ct.Id = p.CategoryId


SELECT * FROM GetProductDetails



--2)Carta elave edilen productlarin qiymetlerini hesablamaq (procedur olaraq)

CREATE PROCEDURE GetSumofThePrices
AS
SELECT SUM(p.SalePrice) as [Total Amount]
from Cart c
INNER JOIN Products p on p.Id= c.ProductId

EXEC GetSumofThePrices

--3)Verilen Id'li mehsulu Carta elave etmek(Procedur olaraq)
CREATE PROCEDURE InsertProduct @Id INT
AS 
BEGIN 
INSERT INTO Cart
(ProductId)
VALUES
(@Id)
END

EXEC InsertProduct @id = 4



--4)Verilen Id'li product'u Cartdan silmek
CREATE PROCEDURE DeleteProduct @Id INT
AS  
BEGIN
DELETE FROM Cart
WHERE @Id = ProductId 
END

DROP PROCEDURE DeleteProduct


EXEC DeleteProduct @Id = 7



--5)Verilen Id'li product add olunduqdan ve silindikden sonra Cartin icindeki mehsullari gostermek(trigger yazin)

CREATE TRIGGER FinalResult 
ON Cart
AFTER  INSERT, DELETE
AS
BEGIN
SELECT	
		p.Id,
		p.Name as [Product Name],
		p.Model,
		p.CostPrice as [Cost Price],
		p.SalePrice as [Sale Price],
		ct.Name as [Category]
FROM Cart c
INNER JOIN Products p on p.Id= c.ProductId
INNER JOIN	Categories ct on ct.Id = p.CategoryId
END

