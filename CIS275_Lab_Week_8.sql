/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 8: using SQL SERVER 2012 and CIS275Sandboxx
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Sharayah Reyes
                DATE:      11/22/2020

*******************************************************************************************
*/

GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'This week, there are 8 questions worth 30 points total. The point totals for each question depend on 
the difficulty of the question. Please be sure to answer each part of each question for full credit.

All SQL should be properly formatted.';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS 275, Lab Week 8, Question 1  [2pts possible]:
Cleanup
-------
First, do Question 2. Then, come back and complete this part.

Write SQL statements that drop the tables you created in Question 2 if they already exist. This will
prepare the database for the CREATE TABLE commands in Question 2, so that the script will execute
without errors.

You have the permissions required to create tables in the CIS275Sandboxx database.

Hint: The syntax for dropping a table if it exists in SQL looks like this:
'
/*
	IF OBJECT_ID('ABC_RecipeIngredient', 'U') IS NOT NULL
		DROP TABLE ABC_RecipeIngredient;
*/
+ '
You will also need to drop the view you create for Question 5. The SQL for that looks like:
'
/*
	IF OBJECT_ID('ABC_all_data', 'V') IS NOT NULL
		DROP VIEW ABC_all_data;
*/
+ '
Hint 2: Foreign key constraints will cause errors unless you drop the tables in the right order.
Drop the tables with foreign keys before you drop the tables with the primary keys those tables
depend on.
' + CHAR(10)

GO

USE CIS275Sandboxx
IF OBJECT_ID('SER_RecipeIngredient', 'U') IS NOT NULL
	DROP TABLE SER_RecipeIngredient;

IF OBJECT_ID('SER_Recipe', 'U') IS NOT NULL
	DROP TABLE SER_Recipe;

IF OBJECT_ID('SER_Ingredient', 'U') IS NOT NULL
	DROP TABLE SER_Ingredient;

IF OBJECT_ID('SER_Chef', 'U') IS NOT NULL
	DROP TABLE SER_Chef;

IF OBJECT_ID('SER_all_data', 'V') IS NOT NULL
		DROP VIEW SER_all_data;

GO
PRINT 'CIS 275, Lab Week 8, Question 2  [8pts possible]:
Create Tables
-------------
Using the ERD from the Lab 8 assignment document (see course shell), create the tables represented
in the ERD. For full credit, please pay attention to the following:

    0. Examine the sample data in Question 3 first. You''ll want to make sure the data types you
       pick for each column are compatible with the data we''re storing in the tables.
    1. Prefix the table names with your initials (for example, name your table ABC_RecipeIngredient
       ABC_RecipeIngredient instead of RecipeIngredient.
    2. All primary key fields should be declared with PRIMARY KEY constraints.
    3. Declare all non-composite primary keys using IDENTITY(1, 1).
    4. Create the correct FOREIGN KEY constraints for all foreign keys.
    5. The following values are all optional:
        a. Preparation in Ingredient
        b. Organization in Chef
        c. FK_ChefID in Recipe
       All other values are mandatory. Add the correct data integrity constraints for this.
    6. Name in Recipe should be distinct. Add the correct data integrity constraint for this.
    7. FK_IngredientID and FK_RecipeID form a composite primary key for the RecipeIngredient table
       (as well as being foreign keys on their own).
    8. If you have two tables with a primary key/foreign key relationship, you''ll need to create
       the table with the primary key BEFORE you create the table with the foreign key constraint.
' + CHAR(10)

GO
CREATE TABLE SER_Ingredient(
	IngredientID	NUMERIC(13, 0) PRIMARY KEY IDENTITY(1,1),
	Name	        VARCHAR(256) NOT NULL,
	Preparation		VARCHAR(256) NULL
);

CREATE TABLE SER_Chef(
	ChefID			NUMERIC(13, 0) PRIMARY KEY IDENTITY(1,1),
	Name		    NVARCHAR(256) NOT NULL,
	Organization	NVARCHAR(256) NULL
);

CREATE TABLE SER_Recipe(
	RecipeID		NUMERIC(13,0) PRIMARY KEY IDENTITY(1,1),
	FK_ChefID		NUMERIC(13,0) NULL FOREIGN KEY REFERENCES SER_Chef (ChefID),
	Name		    NVARCHAR(256) NOT NULL UNIQUE,
	Instructions	NVARCHAR(MAX) NOT NULL	
);

CREATE TABLE SER_RecipeIngredient(
	FK_IngredientID		NUMERIC(13,0) NOT NULL FOREIGN KEY REFERENCES SER_Ingredient (IngredientID),
	FK_RecipeID			NUMERIC(13,0) NOT NULL FOREIGN KEY REFERENCES SER_Recipe (RecipeID),
	Quantity			NVARCHAR(256) NOT NULL,
	Units				NVARCHAR(256) NOT NULL,
	PRIMARY KEY			(FK_IngredientID, FK_RecipeID)
);
	
GO
PRINT 'CIS 275, Lab Week 8, Question 3  [1pt possible]:
Adding Data
-----------
Change the INSERT INTO statements below to reference the tables you created in Question 2.
You should only need to change ABC_ to match your initials. Be sure to change all four statements.
Then, uncomment the lines. (remove the /* at the top and the */ at the bottom).
' + CHAR(10)

GO

INSERT INTO SER_Ingredient
VALUES 
('chunky peanut butter', NULL), -- 1
('sesame seeds', 'toasted'), -- 2
('ginger', 'minced'), -- 3
('garlic', 'minced'), -- 4
('green onion', 'thinly sliced'), -- 5
('soy sauce', NULL), -- 6
('red wine vinegar', NULL), -- 7
('sriracha sauce', NULL), -- 8
('brown sugar', NULL), -- 9
('sesame oil', NULL), -- 10
('cilantro', 'chopped'), -- 11
('thin spaghetti', NULL), -- 12
('egg noodles, 1/8" thick', NULL), -- 13
('rice vinegar', NULL), -- 14
('sesame paste', NULL), -- 15
('smooth peanut butter', NULL), -- 16
('sugar', NULL), -- 17
('ginger', 'finely grated'), -- 18
('chili garlic paste', NULL), -- 19
('cucumber', 'peeled, seeded, cut into 1/8" by 1/8" by 2" sticks'), -- 20
('roasted peanuts', 'chopped'); -- 21

INSERT INTO SER_Chef
VALUES
('Aarti Sequeria', 'Food Network'),
('Eddie Schoenfeld', 'Red Farm');

INSERT INTO SER_Recipe
VALUES
(1, 'Peanut Noodles for Miss Piggy!', 'Drop spaghetti into boiling water, and cook until al dente, according to package instructions. 
Meanwhile, throw peanut butter, sesame seeds (reserve 1 tbsp for garnish), ginger, garlic, soy 
sauce, red wine vinegar, sriracha, brown sugar/honey, sesame oil, and cilantro into a big food 
processor. Whiz ''em up until the sauce is smooth. Taste and adjust seasonings.

Toss veggies with a little sauce in a separate bowl. Drain cooked pasta, and then drizzle with 
a little sesame oil. Toss with a pair of tongs. This will help keep the pasta from sticking.
In a big bowl, toss pasta, veggies, reserved sesame seeds, and sauce together.'),

(2, 'Takeout-Style Sesame Noodles', 'Bring a large pot of water to a boil. Add noodles and cook until barely tender, about 5 minutes;
they should retain a hint of chewiness. Drain, rinse with cold water, drain again and toss with 
a splash of sesame oil.

In a medium bowl, whisk together the remaining 2 tablespoons sesame oil, the soy sauce, rice vinegar, 
sesame paste, peanut butter, sugar, ginger, garlic and chili-garlic paste.

Pour the sauce over the noodles and toss. Transfer to a serving bowl, and garnish with cucumber 
and peanuts.');

INSERT INTO SER_RecipeIngredient
VALUES
(1, 1, '1', 'cup'),
(2, 1, '1/4', 'cup'),
(3, 1, '6', 'tbsp'),
(4, 1, '4', 'cloves'),
(5, 1, '1', 'bunch'),
(6, 1, '1/2', 'cup'),
(7, 1, '4', 'tsp'),
(8, 1, '1', 'tsp'),
(9, 1, '1', 'tbsp'),
(10, 1, '1', 'tsp'),
(11, 1, '1', 'handful'),
(12, 1, '1', 'lb'),
(20, 1, '1', 'whole'),
(13, 2, '1', 'lb'),
(10, 2, '2', 'tbsp'),
(6, 2, '3 1/2', 'tbsp'),
(14, 2, '2', 'tbsp'),
(15, 2, '2', 'tbsp'),
(16, 2, '1', 'tbsp'),
(17, 2, '1', 'tbsp'),
(18, 2, '1', 'tbsp'),
(4, 2, '2', 'tsp'),
(19, 2, '2', 'tsp'),
(20, 2, '1/2', 'whole'),
(21, 2, '1/4', 'cup');

GO
PRINT 'CIS 275, Lab Week 8, Question 4  [4pts possible]:
Adding another Recipe
---------------------
Write additional INSERT INTO statements to add the following recipe to the database:

Ree''s Simple Sesame Noodles
By Ree Drummond, Food Network

Quantity Units      Ingredient           Preparation
-------- ---------- -------------------- --------------------
4        cloves     garlic               minced              
4        whole      green onion          thinly sliced       
1/4      cup        soy sauce            NULL
3        tbsp       sesame oil           NULL
2        tbsp       rice vinegar         NULL
2        tbsp       sugar                NULL
12       oz         thin noodles         NULL
1/4      cup        canola oil           NULL
1/2      tsp        hot chili oil        NULL

Bring a large pot of water to a boil. Cook the noodles according to the package instructions.

Meanwhile, whisk together the soy sauce, canola oil, sesame oil, sugar, vinegar, chili oil and 
garlic in a bowl. Taste and adjust the ingredients as needed.

Drain the noodles. Pour the sauce over the warm noodles and toss to coat. Sprinkle with the 
green onions and toss. Serve in a bowl with chopsticks. Yummy!

Note: Reuse existing ingredients instead of creating duplicates. E.g., minced garlic is already
in the database as IngredientID 4, so you don''t need to create a new row for that ingredient in
the Ingredient table.

Hint: Look at how the recipe data is structured in Question 3 and in the ERD.
' + CHAR(10)

GO
INSERT INTO SER_Ingredient
VALUES
('thin noodles', NULL), --22
('canola oil', NULL), --23
('hot chili oil', NULL); --24

INSERT INTO SER_Chef
VALUES('Ree Drummond', 'Food Network');

INSERT INTO SER_Recipe
VALUES
(3,'Ree Drummond',
'Ree''s Simple Sesame Noodles

Bring a large pot of water to a boil. Cook the noodles according to the package instructions.

Meanwhile, whisk together the soy sauce, canola oil, sesame oil, sugar, vinegar, chili oil and 
garlic in a bowl. Taste and adjust the ingredients as needed.

Drain the noodles. Pour the sauce over the warm noodles and toss to coat. Sprinkle with the 
green onions and toss. Serve in a bowl with chopsticks. Yummy!');

INSERT INTO SER_RecipeIngredient
VALUES
(4, 3, '4', 'cloves'),
(5, 3, '4', 'whole'),
(6, 3, '1/4', 'cup'),
(10, 3, '3', 'tbsp'),
(14, 3, '2', 'tbsp'),
(17, 3, '2', 'tbsp'),
(22, 3, '12', 'oz'),
(23, 3, '1/4', 'cup'),
(24, 3, '1/2', 'tsp');

GO
PRINT 'CIS 275, Lab Week 8, Question 5  [3pts possible]:
Create a view
-------------
Create a view named all_data (prefixed with your initials). After you''ve added the statement to
create the view, go back to Question 1 and add a SQL command to drop the view if it exists. Then,
add a statement that SELECTs * from your view (you will need to add a GO before the SELECT statement).

Your view should include the following columns:

RecipeID, ChefID, IngredientID, RecipeName, ChefName, ChefOrg, Instructions, IngredientName, 
Quantity, Units, Preparation

Do not do any type conversion in your view, just return the raw data in the underlying tables.

Your data should look like this (except for the type conversion):

RecipeID ChefID IngredientID RecipeName                     ChefName             ChefOrg         Instructions            IngredientName            Quantity Units      Preparation
-------- ------ ------------ ------------------------------ -------------------- --------------- ----------------------- ------------------------- -------- ---------- ---------------
1        1      1            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... chunky peanut butter      1        cup        NULL
1        1      2            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... sesame seeds              1/4      cup        toasted        
1        1      3            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... ginger                    6        tbsp       minced         
1        1      4            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... garlic                    4        cloves     minced         
1        1      5            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... green onion               1        bunch      thinly sliced  
1        1      6            Peanut Noodles for Miss Piggy! Aarti Sequeria       Food Network    Drop noodles into bo... soy sauce                 1/2      cup        NULL
...
3        3      22           Ree''s Simple Sesame Noodles   Ree Drummond         Food Network    Bring a large pot of... thin noodles              12       oz         NULL
3        3      23           Ree''s Simple Sesame Noodles   Ree Drummond         Food Network    Bring a large pot of... canola oil                1/4      cup        NULL
3        3      24           Ree''s Simple Sesame Noodles   Ree Drummond         Food Network    Bring a large pot of... hot chili oil             1/2      tsp        NULL
' + CHAR(10)

GO
CREATE VIEW SER_all_data AS
SELECT RecipeID,
	   ChefID,
	   IngredientID,
	   SER_Recipe.Name AS "RecipeName",
	   SER_Chef.Name AS "ChefName",
	   Organization,
	   Instructions, 
	   SER_Ingredient.Name AS "IngredientName",
	   Quantity,
	   Units,
	   Preparation
FROM   SER_Ingredient
JOIN   SER_RecipeIngredient AS "RI" ON SER_Ingredient.IngredientID= RI.FK_IngredientID
JOIN   SER_Recipe ON SER_Recipe.RecipeID = RI.FK_RecipeID
JOIN   SER_Chef ON SER_Chef.ChefID = SER_Recipe.FK_ChefID;

GO
SELECT	 *
FROM	 SER_all_data
ORDER BY RecipeID;

GO
PRINT 'CIS 275, Lab Week 8, Question 6  [2pts possible]:
Indexes
-------
Create indexes for Name in the Ingredient table and Name in the Chef table. Be sure that both
indexes include your initials in their name.
' + CHAR(10)

GO

CREATE INDEX IX_SER_Ingredient_Name ON SER_Ingredient(Name);
CREATE INDEX IX_SER_Chef_Name ON SER_Chef(Name);

GO
PRINT 'CIS 275, Lab Week 8, Question 7  [8pts possible]:
Changing a Recipe
-----------------
Use UPDATE to make the following changes to Peanut Noodles for Miss Piggy!

Substitute 2 tbsp rice vinegar for 4 tsp red wine vinegar.
Substitute 1/2 tbsp sugar for 1 tbsp brown sugar.
Substitute egg noodles, 1/8" thick for this spaghetti.
Change the instructions to the following:

------------------------------------- Text starts here ------------------------------------------
Drop noodles into boiling water, and cook until al dente, according to package instructions. 
Meanwhile, throw peanut butter, sesame seeds (reserve 1 tbsp for garnish), ginger, garlic, soy 
sauce, rice vinegar, sriracha, sugar, sesame oil, and cilantro into a big food 
processor. Whiz ''em up until the sauce is smooth. Taste and adjust seasonings.

Toss veggies with a little sauce in a separate bowl. Drain cooked noodles, and then drizzle with 
a little sesame oil. Toss with a pair of tongs. This will help keep the pasta from sticking.
In a big bowl, toss noodles, veggies, reserved sesame seeds, and sauce together.
-------------------------------------- Text ends here -------------------------------------------

Add a SELECT * statement after the last update that shows all the data in the all_data view.

Note: Be sure not to change any of the other ingredients/recipes, and DO NOT insert any new
rows into the database.
' + CHAR(10)

GO
UPDATE SER_Recipe
SET    Instructions = 'Drop noodles into boiling water, and cook until al dente, according to package instructions. 
Meanwhile, throw peanut butter, sesame seeds (reserve 1 tbsp for garnish), ginger, garlic, soy 
sauce, rice vinegar, sriracha, sugar, sesame oil, and cilantro into a big food 
processor. Whiz ''em up until the sauce is smooth. Taste and adjust seasonings.

Toss veggies with a little sauce in a separate bowl. Drain cooked noodles, and then drizzle with 
a little sesame oil. Toss with a pair of tongs. This will help keep the pasta from sticking.
In a big bowl, toss noodles, veggies, reserved sesame seeds, and sauce together.'
WHERE	RecipeID = 1;

GO
UPDATE		SER_RecipeIngredient
SET         FK_IngredientID= '14'
FROM		SER_RecipeIngredient 
JOIN		SER_Ingredient ON SER_Ingredient.IngredientID = SER_RecipeIngredient.FK_IngredientID
JOIN		SER_Recipe ON SER_Recipe.RecipeID =  SER_RecipeIngredient.FK_RecipeID
WHERE		RecipeID = 1
AND			IngredientID = '7';

UPDATE SER_RecipeIngredient
SET	   Quantity = 2,
	   Units = 'tbsp'
WHERE  FK_IngredientID = 7
AND	   FK_RecipeID = 1;

UPDATE		SER_RecipeIngredient
SET			FK_IngredientID = '17'
FROM		SER_RecipeIngredient 
JOIN		SER_Ingredient ON SER_Ingredient.IngredientID = SER_RecipeIngredient.FK_IngredientID
JOIN		SER_Recipe ON SER_Recipe.RecipeID =  SER_RecipeIngredient.FK_RecipeID
WHERE		RecipeID = 1
AND			IngredientID = 9;

UPDATE	SER_RecipeIngredient
SET		Quantity = '1/2'
WHERE	FK_IngredientID = 9
AND		FK_RecipeID = 1;

UPDATE		SER_RecipeIngredient
SET			FK_IngredientID  = '13'
FROM		SER_RecipeIngredient 
JOIN		SER_Ingredient ON SER_Ingredient.IngredientID = SER_RecipeIngredient.FK_IngredientID
JOIN		SER_Recipe ON SER_Recipe.RecipeID =  SER_RecipeIngredient.FK_RecipeID
WHERE		RecipeID = 1
AND			IngredientID = 12;

SELECT   *
FROM     SER_all_data
ORDER BY RecipeID;

GO
PRINT 'CIS 275, Lab Week 8, Question 8  [3pts possible]:
Cleanup
-------
After the UPDATEs in the previous question, there are now some ingredients that aren''t being
used in any recipes. Write a DELETE statement that deletes all unused ingredients. Use a SELECT
statement as a subquery in the WHERE clause of the DELETE statement that finds the correct
ingredients to delete (i.e., don''t hard-code the ingredient IDs for the ingredients to delete).

Then, SELECT * from all_data and from Ingredient to verify that your delete worked correctly.

Hint: You will be deleting ingredients 7, 9, and 12.
' + CHAR(10)

GO
DELETE SER_Ingredient
WHERE NOT EXISTS(
	  SELECT FK_IngredientID
	  FROM   SER_RecipeIngredient
	  WHERE  SER_RecipeIngredient.FK_IngredientID = SER_Ingredient.IngredientID
);

SELECT *
FROM   SER_Ingredient;
	
SELECT   *
FROM	 SER_all_data
ORDER BY RecipeID;

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 8' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;

