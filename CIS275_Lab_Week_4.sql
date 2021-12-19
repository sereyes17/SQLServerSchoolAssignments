/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 4: using SQL SERVER 2012 and various databases
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Sharayah Reyes
                DATE:      10/15/20

*******************************************************************************************
*/

GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and to capitalize table names as they appear in the database; you should also put 
each projected column on its own line and use indentation for neatness.  Example:

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
PRINT 'CIS 275, Lab Week 4, Question 1  [3pts possible]:
Popular Genres
--------------
We will start with the IMDB database.

For each genre, show the total number of shows that are listed in that genre. Format genre as
15 characters wide. Order in descending order of popularity.

Correct results will have 28 rows and will look like this:

Genre           Count
--------------- -----------
Drama           1183422
Comedy          1049517
Short           670864
Documentary     499078
Talk-Show       452645
Romance         398779
Family          339665
News            338804
Animation       255212
Reality-TV      232633
...
Western         25128
War             20984
Film-Noir       852
' + CHAR(10)

GO
USE IMDB
SELECT   CONVERT(CHAR(15), genre) AS Genre,
		 COUNT(*) AS Count
FROM     title_genre
GROUP BY genre
ORDER BY COUNT(*) DESC;

GO
PRINT 'CIS 275, Lab Week 4, Question 2  [3pts possible]:
M*A*S*H
-------
For each season of M*A*S*H, show the total number of episodes and total number of votes.
Display results ordered by season. Write your query to match the primaryTitle in title_basics
instead of hard-coding a tconst value.

Hint: title_episode.parentTconst is the series, title_episode.tconst is the episode.
Episodes have ratings in title_ratings, where the number of votes for the episode is also contained.

Correct results will look like this:

Season Number Number of Episodes Total Votes by Season
------------- ------------------ ---------------------
1             24                 8470
2             24                 6724
3             24                 6383
4             24                 5859
5             24                 5546
6             24                 5092
7             25                 5362
8             25                 5340
9             20                 4177
10            21                 4049
11            16                 5849
' + CHAR(10)

GO
SELECT   seasonNumber AS "Season Number",
	     COUNT(*) AS "Numbre of Episodes",
         SUM(numVotes) AS "Total Votes by Season"
FROM     title_basics
JOIN     title_episode ON title_episode.parentTconst = title_basics.tconst
JOIN     title_ratings ON title_ratings.tconst = title_episode.tconst
WHERE    primaryTitle = 'M*A*S*H'
GROUP BY seasonNumber
ORDER BY seasonNumber;

GO
PRINT 'CIS 275, Lab Week 4, Question 3  [3pts possible]:
Again Popular Genres
--------------------
Repeat the query from Question 1, but this time express the popularity as a percentage of the total number 
of shows. Format the percentage to two decimal places and add a % sign to the end.

Hint: Start by adding the Total column to the SELECT clause. You''ll need to use a windowed function.
If you use ... OVER () that will window over the entire contents of the table. Once you have that working,
the percent is 100 * the expression that gives you Count / the expression that gives you Total. Use STR
to convert that to 6 characters with two digits after the decimal point, then add a % to the end.

Hint 2: Percent is a reserved keyword in SQL, so you''ll need to quote it if you want to use it as a column name.

Correct results will have 28 rows and look like this:

Genre           Count       Total       Percent
--------------- ----------- ----------- -------
Drama           1183422     7297619      16.22%
Comedy          1049517     7297619      14.38%
Short           670864      7297619       9.19%
Documentary     499078      7297619       6.84%
Talk-Show       452645      7297619       6.20%
Romance         398779      7297619       5.46%
Family          339665      7297619       4.65%
News            338804      7297619       4.64%
Animation       255212      7297619       3.50%
Reality-TV      232633      7297619       3.19%
...
Western         25128       7297619       0.34%
War             20984       7297619       0.29%
Film-Noir       852         7297619       0.01%
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(10), genre) AS "Genre",
	     COUNT(*) AS "Count",
	     SUM(COUNT(*)) OVER () AS "Total",
	     STR(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 6, 2) + 
		 '%' AS "Percent"
FROM     title_genre
GROUP BY genre
ORDER BY COUNT(*) DESC;

GO
PRINT 'CIS 275, Lab Week 4, Question 4 [3pts possible]:
Metaphone with the most Variants
--------------------------------
We''re going to switch over to the NAMES database for the next few queries.

Produce a report that shows the most popular metaphones for baby names. Include two rows
for each metaphone, one for F babies and one for M babies. For each metaphone, show the
total number of names that match that metaphone, and the total number of babies that were
given those names. Order in descending order by total number of babies, and display the
top 10 results.

Format Metaphone as 10 characters wide.

For practice, do not use the all_data view. Write the correct JOIN instead.

Correct results will look like this:

Gender Metaphone  Total Names Total Babies
------ ---------- ----------- ---------------------------------------
M      JN         3565        5910583
M      JMS        403         4859289
F      MR         3499        4835115
M      RBRT       410         4755683
M      MXL        1520        4641296
M      WLM        604         3746134
M      TFT        606         3547986
F      TN         10004       3276887
F      JN         9945        3216270
M      RXRT       435         2516670
' + CHAR(10)

'GO
USE NAMES
SELECT   TOP 10
	     Gender,
	     CONVERT(CHAR(10), Metaphone) AS "Metaphone",
	     COUNT(*) AS "Total Names",
	     SUM(NameCount) AS "Total Babies"
FROM     names
JOIN     name_counts ON NameID = FK_NameID
JOIN     year_gender_totals ON YearGenderTotalID = FK_YearGenderTotalID
GROUP BY Metaphone, Gender
ORDER BY SUM(NameCount) DESC;'

GO
SELECT Metaphone,
	   COUNT(*)
FROM   names
GROUP BY Metaphone;

GO
PRINT 'CIS 275, Lab Week 4, Question 5  [3pts possible]:
What about John?
----------------
For the most popular combination of Metaphone with Gender (JN and M), show a list of the most popular names
that match the metaphone.

Name       Total Babies
---------- ---------------------------------------
John       4712974
Juan       331865
Johnny     305889
Jon        164821
Gene       124121
Johnnie    93336
Jonah      54315
Jean       22359
Jan        21534
Johnie     17265
Gino       11250
Gianni     8071
Joan       5594
...
Giani      227
Jony       216
Jauan      190
' + CHAR(10)

GO
SELECT   TOP 50
		 CONVERT(CHAR(10), Name) AS "Name",
		 SUM(NameCount) AS "Total Babies"
FROM     all_data
WHERE    Metaphone = 'JN'
AND      Gender = 'M'
GROUP BY Name
ORDER BY SUM(NameCount) DESC;

GO
PRINT 'CIS 275, Lab Week 4, Question 6  [3pts possible]:
Year-by-Year Popularity for JN
------------------------------
This time, show a breakdown of the popularity of JN names for M babies.

Your results should contain 100 rows that look like this:

Metaphone  Year                                    Total Babies
---------- --------------------------------------- ---------------------------------------
JN         1915                                    50983
JN         1916                                    53675
JN         1917                                    55877
JN         1918                                    61148
JN         1919                                    58457
JN         1920                                    62319
JN         1921                                    63521
JN         1922                                    62980
JN         1923                                    63395
JN         1924                                    65348
...
JN         2012                                    21925
JN         2013                                    21402
JN         2014                                    21125
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(10), Metaphone) AS "Metaphone",
	     Year,
	     SUM(NameCount) AS "Total Babies"
FROM     names
JOIN     name_counts ON name_counts.FK_NameID = names.NameID
JOIN     year_gender_totals ON year_gender_totals.YearGenderTotalID =
         name_counts.FK_YearGenderTotalID
WHERE    Metaphone = 'JN'
AND      Gender = 'M'
GROUP BY Metaphone , Year
ORDER BY Year;

GO
PRINT 'CIS 275, Lab Week 4, Question 7  [3pts possible]:
Corey in the House
------------------
For all years where the total number of both M and F babies named "Corey" was 100 or more,
show the name (formatted as 10 characters wide) along with the year and the total number
of babies with that name. Display results in chronological order.

Correct results will have 62 rows formatted as:

Name       Year                                    Total Babies
---------- --------------------------------------- ---------------------------------------
Corey      1952                                    117
Corey      1954                                    161
Corey      1955                                    271
Corey      1956                                    313
Corey      1957                                    285
Corey      1958                                    336
Corey      1959                                    351
Corey      1960                                    347
Corey      1961                                    450
Corey      1962                                    485
Corey      1963                                    484
Corey      1964                                    501
Corey      1965                                    544
Corey      1966                                    513
Corey      1967                                    512
Corey      1968                                    1668
Corey      1969                                    5069
...
Corey      2012                                    895
Corey      2013                                    889
Corey      2014                                    818
' + CHAR(10)

GO
SELECT		CONVERT(CHAR(10), Name) AS "Name",
			Year,
			SUM(NameCount) AS "Total Babies"
FROM		names
JOIN		name_counts ON names.NameID = name_counts.FK_NameID
JOIN		year_gender_totals ON year_gender_totals.YearGenderTotalID = name_counts.FK_YearGenderTotalID
WHERE		Name = 'Corey'
GROUP BY	Name, Year
HAVING		SUM(NameCount) >= 100
ORDER BY	Year;

GO
PRINT 'CIS 275, Lab Week 4, Question 8  [3pts possible]:
Popular Genres on TV
--------------------
JOIN the SHOW table to the SCHEDULE table.

For each genre, calculate the total minutes spent airing shows in that genre.
Let''s switch to the TV database for the last three problems. Then, calculate the total
percent of time dedicated to that genre. Show the genre formatted to 20 characters wide,
the total number of minutes, and the percentage of minutes. Only include rows where
the total number of minutes was 1000 or more. Display in descending order by total minutes.
In the case of ties, order alphabetically by genre.

Hint: Review the hints and your answer to Question 3. Your calculation of the percentage
will be similar here.

Hint 2: Use DATEDIFF(mi, StartTime, EndTime) to get the total number of minutes that a show
was on. Total minutes will be the sum of those values for all the shows in a particular genre.

Correct results will have 88 rows that look like this:

Genre                Total Minutes Percent
-------------------- ------------- -------
Special              1257851        14.33%
Sports non-event     959388         10.93%
Reality              680033          7.75%
Children             412604          4.70%
Sitcom               393738          4.49%
Drama                377146          4.30%
Shopping             375642          4.28%
Sports event         362470          4.13%
Comedy               282608          3.22%
Crime drama          247615          2.82%
...
Baseball             1200            0.01%
Collectibles         1200            0.01%
Rodeo                1200            0.01%
Medical              1100            0.01%
' + CHAR(10)

GO
USE TV
SELECT		CONVERT(CHAR(20), Genre) AS "Genre",
			SUM(DATEDIFF(mi, StartTime, EndTime)) AS "Total Minutes",
			STR(100.0 * SUM(DATEDIFF(mi, StartTime, EndTime)) / SUM(SUM(DATEDIFF(mi, StartTime, EndTime))) OVER (), 6, 2) + 
			'%' AS "Percent"
FROM		SHOW
JOIN		SCHEDULE ON SHOW.ShowID = SCHEDULE.FK_ShowID
GROUP BY	Genre
HAVING		SUM(DATEDIFF(mi, StartTime, EndTime)) >= 1000
ORDER BY	"Total Minutes" DESC, Genre;

GO
PRINT 'CIS 275, Lab Week 4, Question 9  [3pts possible]:
0.4% of TV is SpongeBob SquarePants
-----------------------------------
Do the same thing as in the previous query, except group by SeriesNum instead of Genre. This time, only show
series where the total minutes is 10,000 or more. Display the Title formatted to be 20 characters wide instead
of the genre.

Add another column for the total number of episodes aired.

Correct results will have 98 rows and look like this:

Title                Total Minutes Total Episodes Percent
-------------------- ------------- -------------- -------
MLB Extra Innings    258240        658             10.06%
Paid Programming     218507        7292             8.51%
NBA League Pass      103200        215              4.02%
MLS Direct Kick      100620        221              3.92%
College Football     73575         421              2.86%
MLB Baseball         69510         390              2.71%
Programa Pagado      54940         1792             2.14%
SIGN OFF             43025         119              1.68%
SportsCenter         36580         596              1.42%
Public Affairs Event 24362         93               0.95%
To Be Announced      23770         161              0.93%
2017 U.S. Open Tenni 23520         98               0.92%
Law & Order          22727         379              0.88%
Forensic Files       22140         738              0.86%
...
SpongeBob SquarePant 10295         353              0.40%
Politics and Public  10186         60               0.40%
SEC Now              10080         174              0.39%
Keeping Up With the  10080         172              0.39%
' + CHAR(10)

GO
SELECT		CONVERT(CHAR(20), Title) AS "Title",
			SUM(DATEDIFF(mi, StartTime, EndTime)) AS "Total Minutes",
			COUNT(*) AS "Total Episodes",
			STR(100.0 * SUM(DATEDIFF(mi, StartTime, EndTime)) / SUM(SUM(DATEDIFF(mi, StartTime, EndTime))) OVER (), 6, 2) + 
			'%' AS "Percent"
FROM		SHOW
JOIN		SCHEDULE ON SHOW.ShowID = SCHEDULE.FK_ShowID
GROUP BY	SeriesNum, Title
HAVING		SUM(DATEDIFF(mi, StartTime, EndTime)) >= 10000
ORDER BY	"Total Minutes" DESC;

GO
PRINT 'CIS 275, Lab Week 4, Question 10  [3pts possible]:
Everything is Repeats
---------------------
For the entire schedule, calculate the total number of distinct shows aired and the
total number of shows aired. The difference in these two numbers is the total number of
repeats. Show all three values as a single row, along with the percentage of shows that
are repeats.

Note: If you look in the messages pane, you might see a warning like the following:

	Warning: Null value is eliminated by an aggregate or other SET operation.

Eliminate this warning by only including rows where FK_ShowID isn''t NULL.

(The results say that 75% of TV is repeats, but it''s even worse than that, because we''re 
counting the first airing of a show in this 2 week period as an original broadcast, even 
though many of them are repeats from previous weeks).

Correct results should look like this:

Distinct Shows Total Shows Repeats     Percent of Repeats
-------------- ----------- ----------- ------------------
35183          138286      103103      74.56%
' + CHAR(10)

GO
SELECT		COUNT(DISTINCT FK_ShowID) AS "Distinct Shows",
			COUNT(*) AS "Total Shows",
			COUNT(*) - COUNT(DISTINCT FK_ShowID) AS "Repeats",
			STR(100.0 * (COUNT(*) - COUNT(DISTINCT FK_ShowID)) / COUNT(*), 5, 2) + 
			'%' AS "Percent of Repeats"
FROM		SCHEDULE
WHERE		FK_ShowID IS NOT NULL;

GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 4' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


