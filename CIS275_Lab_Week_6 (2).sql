/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 6: using SQL SERVER 2012 and the IMDB database
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Sharayah Reyes
                DATE:      11/2/2020

*******************************************************************************************
*/

USE IMDB    -- ensures correct database is active


GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and table names; you should also put each projected column on its own line
and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS2275, Lab Week 6, Question 1  [3pts possible]:
Write the query to display the name and year of birth for all people born after 1980, who have
directed at least one show (i.e. those who appear at least once in the title_directors table).
Limit results to those who have died (who have a value in the deathYear column).
----------------------------------------------------------------------------------------------
Columns to display:    name_basics.primaryName, name_basics.birthYear
Sort in descending order by birth year.' + CHAR(10)

GO
SELECT   DISTINCT primaryName,
         birthYear
FROM     name_basics
JOIN     title_directors ON name_basics.nconst = title_directors.nconst
WHERE    birthYear > 1980
AND      deathYear IS NOT NULL
ORDER BY birthYear DESC,
         primaryName;
       
--Expected outcome
--primaryName	birthYear
--Anthony Conti	2000
--Amanda Todd	1996
--Daniel W. Ridge	1996
--Daniil Lazarenkov	1994
--Skye McCole Bartusiak	1992
--Safar Shakeyev	1991
--Anestis Dalezis	1989
--Kent Nolan	1989
--Wilson P.Y. Lau	1989
--Edd Gould	1988
--Ryan McHenry	1987
--Adam Cooley	1986
--Arturo Domínguez	1986
--Bradley John Smith	1986
--Cameron Duncan	1986
--John H. Lamensdorf	1986
--Krzysztof Szot	1986
--Greg Potocky	1985
--Jason Williams	1985
--Kate Chappell	1985
--Nilu Doma Sherpa	1985
--Ryan Thomas Andersen	1985
--Harris Wittels	1984
--Matt Palazzolo	1984
--Nataasha Van Kampen	1984
--Zachary Philip Freeman	1984
--Alex Goddard	1983
--Brianna Lea Pruett	1983
--Brock H. Brown	1983
--C.R. Johnson	1983
--Mici Falvo	1983
--Stephen Kitaen	1983
--Vanessa Libertad Garcia	1983
--Alberto C. Diaz	1982
--David Dutchess	1982
--Derek Lake	1982
--Emer Prevost	1982
--Erik Rhodes	1982
--John Driftmier	1982
--Lee Kazimir	1982
--Taylor Alves	1982
--Alex Ghassan	1981
--Brygida Frosztega-Kmiecik	1981
--Eric Harris	1981
--Haley Paige	1981
--Jordan Christianson	1981
--Monty Oum	1981
--Nick Louvel	1981
--Seth Gimlan	1981
--Shane Ballard	1981

GO
PRINT 'CIS2275, Lab Week 6, Question 2  [3pts possible]:
Show every genre of television show which has had at least one title with 500 episodes.
i.e. limit results to the titleType ''tvEpisode'' in the title_basics table, and to titles
containing a row in the title_episode table with episodeNumber 500.
----------------------------------------------------------------------------------------------
Columns to display:    title_genre.genre
Display genre name only, and eliminate duplicate values.' + CHAR(10)

GO
SELECT DISTINCT genre
FROM   title_genre
JOIN   title_basics ON title_basics.tconst = title_genre.tconst
AND    titleType = 'tvEpisode'
JOIN   title_episode ON title_basics.tconst = title_episode.tconst
AND    episodeNumber = '500';

--expected result
--
--genre
--Action
--Adventure
--Animation
--Comedy
--Crime
--Documentary
--Drama
--Family
--Fantasy
--Game-Show
--Horror
--Music
--Musical
--Mystery
--News
--Reality-TV
--Romance
--Sport
--Talk-Show
--Thriller
-- the concurrent subquery should produce the following:
--genre
--Action
--Adventure
--Animation
--Comedy
--Crime
--Documentary
--Drama
--Family
--Fantasy
--Game-Show
--Horror
--Music
--Musical
--Mystery
--News
--Reality-TV
--Romance
--Sport
--Talk-Show
--Thriller
--
GO
PRINT 'CIS2275, Lab Week 6, Question 3  [3pts possible]:
Write a common table expression to identify the WORST shows: join title_basics against title_ratings
and limit your results to those with an averageRating value equal to 1.  Project the title,
type, and startYear from title_basics; and label your CTE as BADSHOWS.
In the main query, show a breakdown of BADSHOWS grouped by type, along with the total number of
rows for each (i.e. GROUP BY titleType)
----------------------------------------------------------------------------------------------
Columns to display:    titleType, COUNT(*)
Sort results in descending order by COUNT(*).' + CHAR(10)

GO
WITH BADSHOWS AS (
	SELECT	  titleType
	FROM      title_basics
	JOIN	  title_ratings ON title_basics.tconst = title_ratings.tconst
	AND       averageRating = 1
)
SELECT         CONVERT(CHAR(10), titleType) AS "Title", 
	           CONVERT(CHAR(10), COUNT(*)) AS "TOTAL_BAD_SHOWS"
FROM           BADSHOWS 
GROUP BY       titleType
ORDER BY       COUNT(*) DESC;
                 
--Expected outcom
--titleType	TOTAL_BAD_SHOWS
--tvEpisode   	314
--video       	74
--short       	62
--movie       	51
--tvMovie     	16
--tvSeries    	11
--tvSpecial   	11
--tvMiniSeries	7
--tvShort     	2
--videoGame   	2

GO
PRINT 'CIS2275, Lab Week 6, Question 4  [3pts possible]:
Identify the least popular professions.  Show each profession value from the name_profession table,
along with the total number of matching rows (GROUP BY profession).  Use the HAVING clause to limit
your results to professions with less than 1,000 rows.
----------------------------------------------------------------------------------------------
Columns to display:    name_profession.profession, COUNT(*)' + CHAR(10)

GO
SELECT   profession, 
         COUNT(*) AS "Total People"
FROM     name_profession 
GROUP BY profession 
HAVING   COUNT (*) < 1000;

--Expected outcome
--profession	TOTAL_PEOPLE
--electrical_department	1
--production_department	1
--script_department	1

GO
PRINT 'CIS2275, Lab Week 6, Question 5  [3pts possible]:
Use the query from #4 above to display the names of all people belonging to these professions.
Use the previous query as a subquery in the FROM clause here to limit the results.
----------------------------------------------------------------------------------------------
Columns to display:    name_basics.primaryName, name_profession.profession
Sort results in ascending order by primaryName.' + CHAR(10)

GO
SELECT  primaryName,
	    profession
FROM    name_basics AS NB,
	    name_profession AS NP
WHERE   profession IN (
	SELECT   profession
	FROM     name_profession
	GROUP BY profession
	HAVING   COUNT(*) < 1000
)
AND      NB.nconst = NP.nconst
ORDER BY primaryName ASC;
		
--primaryName	profession
--Andrea Devaux	script_department
--Eddie A. Reid IV	electrical_department
--Leonardo Aquilini	production_department

GO
PRINT 'CIS2275, Lab Week 6, Question 6  [3pts possible]:
Show the name of every writer, along with the total number of titles they''ve written (i.e. rows in the 
title_writers table).  Limit results to those who have written between 5,000 and 10,000 titles (inclusive).
----------------------------------------------------------------------------------------------
Columns to display:    name_basics.primaryName, COUNT(*)
Sort results in descending order by primaryName.' + CHAR(10)

GO
SELECT     primaryName, 
	       COUNT(*) AS "Titles Written" 
FROM       title_writers AS TW
INNER JOIN name_basics AS NB on NB.nconst = TW.nconst 
GROUP BY   primaryName 
HAVING     COUNT (*) BETWEEN 5000 AND 10000 
ORDER BY   primaryName DESC;

--Expected outcome
--primaryName	TITLES_WRITTEN
--Tony Warren	9373
--Peter Ling	5151
--Kevin Laffan	5018
--Hazel Adair	5066
--Delia Fiallo	5558
--Bradley Bell	6234
--Armand Jammot	5329
--Agnes Nixon	5594
--Adrián Suar	5968

GO
PRINT 'CIS2275, Lab Week 6, Question 7  [3pts possible]:
Show the actor and character names for everyone who has performed the same role in more than one
show with the title ''Battlestar Galactica''.  i.e. identify the combination of (primaryName, characters)
which occurs in the title_principals table more than once for matching titles.
----------------------------------------------------------------------------------------------
Columns to display:    name_basics.primaryName, title_principals.characters, COUNT(*)
Sort results in ascending order by primaryName.' + CHAR(10)

GO
SELECT   primaryName,
         characters,
	     COUNT(*)
FROM     title_principals AS tp,
         name_basics AS nb,
	     title_basics AS tb
WHERE    tp.nconst = nb.nconst
AND      tp.tconst = tb.tconst
AND      tb.primaryTitle = 'Battlestar Galactica'
AND      characters IS NOT NULL
AND      category = 'actor'
GROUP BY primaryName,
         characters
HAVING   COUNT(*) > 1
ORDER BY primaryName ASC;

--Suquery
--primaryName	characters	MATCHES
--Dirk Benedict	["Lieutenant Starbuck"]	2
--Herbert Jefferson Jr.	["Lieutenant Boomer"]	2
--Lorne Greene	["Commander Adama"]	2
--Richard Hatch	["Captain Apollo"]	2
--all joins
--primaryName	characters	MATCHES
--Dirk Benedict	["Lieutenant Starbuck"]	2
--Herbert Jefferson Jr.	["Lieutenant Boomer"]	2
--Lorne Greene	["Commander Adama"]	2
--Richard Hatch	["Captain Apollo"]	2

GO
PRINT 'CIS2275, Lab Week 6, Question 8  [3pts possible]:
Identify the names of people who have directed more than five highest-rated shows (i.e. title_ratings.averageRating = 10).
For each of these people, display their names and the total number of shows they have written.
----------------------------------------------------------------------------------------------
Columns to display:    name_basics.primaryName, COUNT(*)
Sort results in ascending order by primaryName.' + CHAR(10)

GO
SELECT   primaryName AS "Name",
	     COUNT(DISTINCT TW.tconst) AS "Titles Written" 
FROM     name_basics AS NB
JOIN     title_directors AS TD ON NB.nconst = TD.nconst
JOIN     title_writers AS TW ON NB.nconst = TW.nconst
JOIN     title_ratings AS TR ON TD.tconst = TR.tconst
WHERE    averageRating = 10
GROUP BY primaryName
HAVING   COUNT(DISTINCT TD.tconst) > 5  
ORDER BY primaryName ASC;
	     
--primaryName	TOTAL_WRITTEN
--Andrew Espinoza Long	36
--Anestis Dalezis	52
--Anthony Anderson	24
--Austin D. Jordan	7
--Brendon deVore	3
--Erin Stoddard	46
--Florent Pirlet	1
--Gustavo Goulart	18
--John Kilduff	5
--Kilorenzos Smith	478
--Larry Rosen	133
--Ömer Levent Dilli	2
--Pantelis Kassotis	48
--Peter Scholl	5
--Ray Ellingsen	14
--Saba	110
--Scott Rhodes	75
--Senol Sönmez	1
--Simon Thaur	1
--Tim Prokop	180

GO
PRINT 'CIS2275, Lab Week 6, Question 9  [3pts possible]:
Display the title and running time for all TV specials ( titleType = ''tvSpecial'' ) from 1982; if the run time is
NULL, substitute zero.
----------------------------------------------------------------------------------------------
Columns to display:    title_basics.primaryTitle, title_basics.runtimeMinutes
Sort in descending numerical order by the resulting calculated run time value.' + CHAR(10)

GO
SELECT   primaryTitle,
	     ISNULL(CONVERT(CHAR(10), runtimeMinutes), 0) AS "Characters"
FROM     title_basics
WHERE    titleType = 'tvSpecial'
AND      startYear = '1982'
ORDER BY runtimeMinutes DESC;

--isnull
--primaryTitle	RUNTIME
--Night of 100 Stars	180
--Broadway Plays Washington on Kennedy Center Tonight	180
--Macy's Thanksgiving Day Parade	180
--1982 MLB All-Star Game	173
--Roy Acuff... 50 Years the King of Country Music	120
--Country Comes Home	120
--Circus of the Stars #7	120
--I Love Liberty	120
--Women I Love: Beautiful But Funny	120
--The 2nd American Movie Awards	120
--AFI Life Achievement Award: A Tribute to Frank Capra	112
--Live from Studio 8H: Caruso Remembered	90
--Olivia	78
--On Location: Robert Klein at Yale	77
--Doobie Brothers: Live at the Greek Theatre	75
--Catch a Rising Star's 10th Anniversary	66
--7th Annual Young Comedians Show	60
--The Suzanne Somers Special	60
--Star-Studded Spoof of the New TV Season, G-Rated, with Glamour, Glitter and Gags	60
--Perry Como's Easter in Guadalajara	60
--The Wayne Newton Special	60
--Pavarotti & Friends	60
--Gallagher: Totally New	60
--Bob Hope Laughs with the Movie Awards	60
--Kraft Salutes Walt Disney World's 10th Anniversary	60
--Pac Preview Party	60
--People of the Year	60
--Royal Canadian Air Farce	60
--George Burns and Other Sex Symbols	60
--Freek de Jonge: De openbaring	58
--Chick Corea: A Very Special Concert	54
--Lily for President?	50
--The Variety Club Awards for 1981	45
--The 9th Annual Daytime Emmy Awards	0
--The 1982 Annual Vision Awards	0
--The 19th Annual Publicists Guild of America Awards	0
--Interview with Commander Zero	0
--Price/Horne Met Gala Concert	0
--The 7th Los Angeles Film Critics Awards	0
--The 8th Annual People's Choice Awards	0
--The Bafta Awards	0
--The 34th Annual Directors Guild Awards	0
--The 28th Annual Genii Awards	0
--Nancy Wilson: A Very Special Concert	0
--The 24th Annual TV Week Logie Awards	0
--1982 NFC Championship Game	0
--Tonight Show Starring Johnny Carson 20th Anniversary	0
--Presidentin valitsijamiesvaalit 1982: Vaalivalvojaiset	0
--1982 NBA All-Star Game	0
--The 5th Annual Japan Academy Awards	0
--1981 AFC Championship Game	0
--1981 NFC Championship Game	0
--The 34th Annual Primetime Emmy Awards	0
--Super Bowl XVI	0
--CBS All American Thanksgiving Day Parade	0
--The American Music Awards	0
--Dronningens nytårstale	0
--EPCOT Center: The Opening Celebration	0
--The Eurovision Song Contest	0
--The Kennedy Center Honors: A Celebration of the Performing Arts	0
--Battle of the Network Stars XII	0
--Dansk melodi grand prix	0
--The Uncounted Enemy: A Vietnam Deception	0
--Battle of the Network Stars XIII	0
--The 54th Annual Academy Awards	0
--The 24th Annual Grammy Awards	0
--The 36th Annual Tony Awards	0
--The 39th Annual Golden Globe Awards	0
--COALESCE
--primaryTitle	RUNTIME
--Night of 100 Stars	180
--Broadway Plays Washington on Kennedy Center Tonight	180
--Macy's Thanksgiving Day Parade	180
--1982 MLB All-Star Game	173
--Roy Acuff... 50 Years the King of Country Music	120
--Country Comes Home	120
--Circus of the Stars #7	120
--I Love Liberty	120
--Women I Love: Beautiful But Funny	120
--The 2nd American Movie Awards	120
--AFI Life Achievement Award: A Tribute to Frank Capra	112
--Live from Studio 8H: Caruso Remembered	90
--Olivia	78
--On Location: Robert Klein at Yale	77
--Doobie Brothers: Live at the Greek Theatre	75
--Catch a Rising Star's 10th Anniversary	66
--7th Annual Young Comedians Show	60
--The Suzanne Somers Special	60
--Star-Studded Spoof of the New TV Season, G-Rated, with Glamour, Glitter and Gags	60
--Perry Como's Easter in Guadalajara	60
--The Wayne Newton Special	60
--Pavarotti & Friends	60
--Gallagher: Totally New	60
--Bob Hope Laughs with the Movie Awards	60
--Kraft Salutes Walt Disney World's 10th Anniversary	60
--Pac Preview Party	60
--People of the Year	60
--Royal Canadian Air Farce	60
--George Burns and Other Sex Symbols	60
--Freek de Jonge: De openbaring	58
--Chick Corea: A Very Special Concert	54
--Lily for President?	50
--The Variety Club Awards for 1981	45
--The 9th Annual Daytime Emmy Awards	0
--The 1982 Annual Vision Awards	0
--The 19th Annual Publicists Guild of America Awards	0
--Interview with Commander Zero	0
--Price/Horne Met Gala Concert	0
--The 7th Los Angeles Film Critics Awards	0
--The 8th Annual People's Choice Awards	0
--The Bafta Awards	0
--The 34th Annual Directors Guild Awards	0
--The 28th Annual Genii Awards	0
--Nancy Wilson: A Very Special Concert	0
--The 24th Annual TV Week Logie Awards	0
--1982 NFC Championship Game	0
--Tonight Show Starring Johnny Carson 20th Anniversary	0
--Presidentin valitsijamiesvaalit 1982: Vaalivalvojaiset	0
--1982 NBA All-Star Game	0
--The 5th Annual Japan Academy Awards	0
--1981 AFC Championship Game	0
--1981 NFC Championship Game	0
--The 34th Annual Primetime Emmy Awards	0
--Super Bowl XVI	0
--CBS All American Thanksgiving Day Parade	0
--The American Music Awards	0
--Dronningens nytårstale	0
--EPCOT Center: The Opening Celebration	0
--The Eurovision Song Contest	0
--The Kennedy Center Honors: A Celebration of the Performing Arts	0
--Battle of the Network Stars XII	0
--Dansk melodi grand prix	0
--The Uncounted Enemy: A Vietnam Deception	0
--Battle of the Network Stars XIII	0
--The 54th Annual Academy Awards	0
--The 24th Annual Grammy Awards	0
--The 36th Annual Tony Awards	0
--The 39th Annual Golden Globe Awards	0

GO
PRINT 'CIS2275, Lab Week 6, Question 10  [3pts possible]:
Identify every movie from 1913 (startYear = 1913, titleType = ''movie''); limit your results to those with a non-NULL value
in the runtimeMinutescolumn.  For each movie, display the primaryTitle and the averageRating value from the title_ratings table.
Use DENSE_RANK() to display the rank based on averageRating (label this RATINGRANK), and also the rank based on runtimeMinutes
(label this LENGTHRANK).  Both of these should be based on an asecending sort order.
----------------------------------------------------------------------------------------------
Columns to display:    title_basics.primaryTitle, title_ratings.averageRating,
                       RATINGRANK, LENGTHRANK
Sort results in ascending order by primaryTitle.' + CHAR(10)

GO
SELECT   primaryTitle,
	     averageRating,
	     DENSE_RANK() OVER (ORDER BY averageRating ASC) RATINGRANK,
	     DENSE_RANK() OVER (ORDER BY runtimeMinutes ASC) LENGTHRANK
FROM     title_ratings AS TR
JOIN     title_basics AS TB ON TB.tconst = TR.tconst
WHERE    startYear = '1913'
AND	     titleType = 'movie'
AND      runtimeMinutes IS NOT NULL
ORDER BY primaryTitle ASC;

--expected solution
--primaryTitle	averageRating	RATINGRANK	LENGTHRANK
--A Message from Mars	5.2	3	15
--Atlantis	6.8	16	27
--Brother Against Brother	6.0	8	5
--Das Recht auf Dasein	6.3	11	1
--David Copperfield	6.3	11	13
--De levende ladder	6.2	10	4
--Dick Whittington and his Cat	6.9	17	1
--Die Insel der Seligen	5.0	2	3
--Die Suffragette	5.5	4	9
--Dr. Mawson in the Antarctic	5.2	3	14
--Fantômas: In the Shadow of the Guillotine	6.9	17	7
--Fantômas: Juve versus Fantômas	6.8	16	10
--Fantômas: The Dead Man Who Killed	6.9	17	22
--From Dusk to Dawn	6.0	8	22
--Germinal; or, The Toll of Labor	7.1	18	28
--Hamlet	5.2	3	11
--In the Bishop's Carriage	6.2	10	4
--Ingeborg Holm	7.3	19	23
--Ivanhoe	5.9	7	6
--L'enfant de Paris	7.8	20	24
--Les Misérables, Part 1: Jean Valjean	6.3	11	9
--Les Misérables, Part 2: Fantine	6.1	9	29
--Life of the Jews of Palestine	5.8	6	18
--Lime Kiln Club Field Day	6.2	10	12
--One Hundred Years of Mormonism	5.0	2	22
--Protéa	6.7	15	4
--Quo Vadis?	6.4	12	26
--Spartacus	5.7	5	21
--The Black Diamond	5.5	4	4
--The Count of Monte Cristo	5.7	5	15
--The Extraordinary Adventures of Saturnino Farandola	6.3	11	17
--The Last Days of Pompeii	6.2	10	21
--The Life and Works of Richard Wagner	6.5	13	25
--The Sea Wolf	6.0	8	16
--The Student of Prague	6.6	14	19
--Traffic in Souls	6.2	10	21
--Twilight of a Woman's Soul	6.8	16	2
--What 80 Million Women Want	4.5	1	8
--Where Is Coletti?	6.7	15	20
--Zigomar - the Black Scourge - Episode 1	6.6	14	7
--

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 6' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


