/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 5: using SQL SERVER 2012 and various databases
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   Sharayah Reyes
                DATE:      

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
PRINT 'CIS 275, Lab Week 5, Question 1  [3pts possible]:
Teacher Posts
-------------
We begin with the Discussions database. The table names are a little different from the ERD presented in Lesson 3,
so be sure to check the correct names (use SSMS or DataGrip to browse the tables and columns).

Find all posts made by Alan Turing (the teacher). USE ONLY SUBQUERIES AND NO JOINS. Do not hard code Alan''s user ID.
Write a subquery that look up the correct value in the database using the teacher''s first name and last name.

Return title, content, and posted date. Format title as 30 characters wide and content as 70 characters wide. Format 
Posted date as MM/DD/YYYY. Display results with the MOST RECENT POST FIRST.

Hint: First write a query that returns the UserID for users with the FirstName "Alan" and the LastName "Turing". Then,
write a query that uses the first query as a subquery in the WHERE clause of an outer query that looks up all posts
where the user ids match.

Correct results will have 35 rows and will look like this:

Title                          Content                                                                Date
------------------------------ ---------------------------------------------------------------------- ----------
Repetition                     <p>lol, great observation, Dorothy.</p><p>-Alan</p>                    12/15/2016
Objects....                    <p>Nice, Scott!</p><p>-Alan</p>                                        12/15/2016
Hardware and Software          <p>I like it, but I think it would be a better illustration of Input a 12/15/2016
Lession 9 Discussion           <p>I think it''s a great example of Selection, Melissa :)</p><p>-Alan< 12/15/2016
pics                           <p>These are pretty, and most of them are appropriate for the concepts 12/15/2016
Lesson#4 Discussion            <p>Your Uncle has probably not picked up a book on Algorithms recently 12/15/2016
Arrays                         <p>You were clearly inspired! You definitely deserve extra credit for  12/14/2016
Lesson#4 Discussion            <p>I don''t necessarily disagree with you, but that raises two questio 12/14/2016
Staying calm                   <p style="padding-left: 30px;">If you are prone to panic and stressing 12/13/2016
Input Validation               <p>I like it, Matthew! The square peg in a round hole is&nbsp;a great  12/13/2016
Discussion                     <p>"Some people are just better than others at certain things."</p><p> 12/04/2016
...
Download and set up successful <p>Good Solomon, glad you figured it out. Don''t forget that the walkt 10/04/2016
How Much Is Too Much? --Jordon <p>I think this is an extremely sensible approach to the problem, Jord 10/03/2016
Which Version of Python to Ins <p>You ended up with me (Alan Turing) this term. I''m sorry, but Pytho 09/27/2016
' + CHAR(10)

GO

USE Discussions

SELECT   CONVERT(CHAR(30), Title) AS "Title",
	     CONVERT(CHAR(70), Content) AS "Content",
	     CONVERT(CHAR(10), PostedDate, 101) AS "Date"
FROM     Posts
WHERE    FK_UserID IN(
	SELECT UserID
	FROM   Profiles
	WHERE  LastName = 'Turing'
	AND	   FirstName = 'Alan')
ORDER BY PostedDate DESC;

GO
PRINT 'CIS 275, Lab Week 5, Question 2  [3pts possible]:
Late Work
---------
Find all posts to the discussion named "Introduce Yourself" that were made after the first post that was made to
the "Week 2 Discussion" discussion.	USE ONLY SUBQUERIES AND NO JOINS. Do not hard code any discussion IDs or dates.
Write subqueries that look up the correct values in the database using the discussion names.

Return discussion ID, user ID, title, content, and posted date. Format discussion ID and user ID as 10 characters 
wide. Format title as 30 characters wide and content as 50 characters wide. Format Posted date as MM/DD/YYYY.

Hint: 
    1. Start with a query that finds the DiscussionID for the discussion named "Week 2 Discussion". 
    2. Next, write a query that finds the PostedDates for posts where the FK_DiscussionID matches the DiscussionID 
       returned by the first query. Use the first query as a subquery in the WHERE clause of the second query. 
    3. Take the TOP 1 PostedDate when the results are ordered by PostedDate to find the date of the first post to 
       the Week 2 Discussion. 
    4. Use that whole thing as a subquery in the where clause of a query on Posts to find all posts made after that 
       date. Then, add another subquery to the WHERE clause of the outer query that finds only posts made to the 
       discussion with the name "Introduce Yourself".

The correct answer will look like:

Discussion ID User ID    Title                          Content                                            Date
------------- ---------- ------------------------------ -------------------------------------------------- ----------
354033        1          Oh the Irony, Introduction.    <p>I go by Sol or Solomon. If you call me Solly I  12/16/2016
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(10), FK_DiscussionID) AS "Discussion ID",
         CONVERT(CHAR(10), FK_UserID) AS "User ID",
		 CONVERT(CHAR(30), Title) AS "Title",
		 CONVERT(CHAR(50), Content) AS "Content",
		 CONVERT(CHAR(10), PostedDate, 101) AS "Date"
FROM     Posts
WHERE    PostedDate > (
	SELECT TOP 1 PostedDate 
	FROM       Posts
	WHERE      FK_DiscussionID IN (
		SELECT DiscussionID
		FROM   Discussions
		WHERE  Name = 'Week 2 Discussion')
		)
AND	       FK_DiscussionID IN (
			   SELECT DiscussionID
			   FROM   Discussions
			   WHERE Name = 'Introduce Yourself'
			   )
ORDER BY  PostedDate;

GO
PRINT 'CIS 275, Lab Week 5, Question 3  [3pts possible]:
Antisocial
----------
Return the username for all users who have never replied to anyone else''s post. Use subqueries only, NO JOINS.

Format username as 20 characters wide and sort in alphabetical order by username.

Correct answers will have 15 rows and will look like this:

Username
--------------------
arthur.jefferson    
brian.smith         
david.green         
dick.phelps         
dorothy.emmerson    
james.jones         
jason.tyler         
jonah.syms          
lee.shelley         
matthew.johnson     
melissa.aizawa      
mohammad.abduallah  
racquel.house       
sage.kutchener      
william.kareda     
' + CHAR(10)
GO
SELECT   CONVERT(CHAR(20), Username) AS "Username"
FROM     Users
WHERE    UserID NOT IN (
			 SELECT FK_UserID
			 FROM   Posts
			 WHERE  FK_ParentID IS NOT NULL
	)
AND      Username NOT LIKE 'noPOSTS.%'
ORDER BY Username;

GO
PRINT 'CIS 275, Lab Week 5, Question 4  [3pts possible]:
Week 3 Participants
-------------------
Find all students who posted to the "Week 3 Discussion" discussion board. Use EXISTS with
coorelated subqueries. 

Produce the student names in "LastName, FirstName" format (e.g., "Turing, Alan"). Produce names
in alphabetical order by lastname, additionally sort by first name for students with the same last 
name.

Use 20 characters for the name as shown below.

Correct answers will look like this:

Name
--------------------
Abduallah, Mohammad 
Aizawa, Melissa     
Ashley, Scott       
Emmerson, Dorothy   
Fuchs, Jordon       
Johnson, Matthew    
Kutchener, Sage     
O''Connor, Solomon   
Shelley, Lee        
Syms, Jonah         
Turing, Alan        
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(20), LastName + ',' + FirstName) AS "Name"
FROM     Profiles
WHERE    EXISTS (
			 SELECT *
			 FROM   Posts
			 WHERE  FK_UserID = UserID
	AND      EXISTS (
				 SELECT *
				 FROM   Discussions 
				 WHERE  Name = 'Week 3 Discussion'
	AND	         FK_DiscussionID = DiscussionID))
ORDER BY LastName,
	     FirstName;

GO
PRINT 'CIS 275, Lab Week 5, Question 5  [3pts possible]:
Who wrote this?
---------------
For each post, show the title, content and author''s username WITHOUT USING JOINS.

Use 30 characters for the title, 70 characters for the content, and 20 characters for the username.
Order by PostedDate (but don''t include that column in the SELECT clause).

Hint: Use a subquery in the SELECT clause that retrieves Username from the Users table. Match
FK_UserID in the outer query (which is selecting from Posts) to UserID in the subquery.

Hint 2: To format Username, use something like:

     CONVERT(CHAR(20), (<subquery goes here>)) AS "Author"

Correct answers will have 149 rows and will look like this:

Title                          Content                                            Author
------------------------------ -------------------------------------------------- --------------------
David Green                    <p>Hey classmates name is David I''m working on m  david.green         
Introducing -- Jordon Fuchs    <p>Hey everyone:</p><p>You can call me&nbsp;Jordon jordon.fuchs        
Which Version of Python to Ins <p>Hey Mr. Jefferson,</p><p>I currently have Pytho jordon.fuchs        
Hello- Dorothy Emmerson        <p>Hi everyone! You can call me Dorothy. My major  dorothy.emmerson    
Which Version of Python to Ins <p>You ended up with me (Alan Turing) this term. I Alan.Turing         
Racquel House                  <p>Hello everyone, my name is Racquel. I''m still  racquel.house       
Which Version of Python to Ins <p>Oops, sorry Alan (not Arthur, hehe). It shouldn jordon.fuchs        
William Blake Kareda           <p>Hi Everyone,&nbsp;</p><p>My name is&nbsp;on the william.kareda      
Hey CIS122                     <p>Hey guys!</p><p>My names Scott. I''m an interna scott.ashley        
...
Do you have what it takes to b <p>For me on the surface I should in no way be a p solomon.oconnor     
Code for everybody !!!         <p>First of all I think with enough time and energ solomon.oconnor     
Oh the Irony, Introduction.    <p>I go by Sol or Solomon. If you call me Solly I  solomon.oconnor     
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(30), Title) AS "Title",
		 CONVERT(CHAR(70),Content) AS "Content",
		 CONVERT(CHAR(20),(
		 SELECT Username
		 FROM   Users
		 WHERE  UserID = FK_UserID)) AS "Author"
FROM     Posts
ORDER BY PostedDate;

GO
PRINT 'CIS 275, Lab Week 5, Question 6 [3pts possible]:
Popular Posts
-------------
For each post, show the title, content, date, total number of upvotes, total number of downvotes, and total karma 
(upvotes minus downvotes). Order in descending order of karma. If karma values are tied, order in descending order 
by total number of upvotes. Use subqueries in the SELECT clause, NO JOINS.

Use 30 characters for the title, 70 characters for the content, and 10 characters each for upvotes/downvotes/karma. 
Display Date as MM/DD/YYYY.

Hint: Match FK_PostID in the Ratings table in the subqueries to PostID in the Posts table in the outer query. 

Hint 2: To format upvotes/downvotes/karma, you can use something like:

     CONVERT(CHAR(10), ISNUL( (<subquery goes here>), 0)) AS "ColumnName"

Hint 3: Make sure your are sorting numerically by karma instead of alphabetically, and that the negative karma posts are
at the bottom! You may need to repeat the subquery for karma in the ORDER BY clause without converting to CHAR(10), and
you''ll need to use ISNULL to make sure that posts with no upvotes or downvotes are ranked using a karma value of 0 instead
of NULL (NULL comes after -1 but 0 comes before -1).

Title                          Content                                                                Date       Upvotes    Downvotes  Karma
------------------------------ ---------------------------------------------------------------------- ---------- ---------- ---------- ----------
The ominous (or not so ominous <p>Hardware - scary to some, but to others more fun than Christmas. I  11/29/2016 4          1          3         
Lesson#4 Discussion            <p>I don''t necessarily disagree with you, but that raises two questio 12/14/2016 3          0          3         
Download and set up successful <p>I got python and pycharm downloaded and running. but in pycharm the 10/04/2016 3          0          3         
How Much Is Too Much? --Jordon <p>Hey Fox, thanks for the response.</p><p>With a computer science rel 10/09/2016 3          0          3         
JavaScript Jobs                <p>I decided to search with JavaScript on indeed. I already know a bit 10/17/2016 3          0          3         
Viewpoint                      <p>I think that it''s essentially to have some basic knowledge on how  10/17/2016 2          0          2         
David Green                    <p>Hey classmates name is David I''m working on my CIS transfer degree 09/27/2016 2          0          2         
Objects....                    <p>Well I''m a little reluctant to upload my masterpiece, especially a 12/14/2016 2          0          2         
Lesson 7                       <p>Through this course, I have grown a deep respect for programmers. I 11/28/2016 2          0          2         
My Thoughts                    <p>Some of the characteristics and qualities that some need to be a ha 11/18/2016 2          0          2         
...
Simplicity                     <p>I usually don''t consider myself dumb, but I have trouble understan 11/06/2016 0          1          -1        
Arrays                         <p><img src="/d2l/le/150271/discussions/posts/7201029/ViewAttachment?f 12/14/2016 0          1          -1        
Lesson#4 Discussion            <p>Unfortunately I disagree with how much the class focused on Pseudoc 12/14/2016 0          1          -1             
' + CHAR(10)

GO
SELECT   CONVERT(CHAR(30), Title) AS "Title",
	     CONVERT(CHAR(70), Content) AS "Content",
	     CONVERT(CHAR(10), PostedDate, 101) AS "Date",
	     CONVERT(CHAR(10), (SELECT COUNT(*) 
							FROM   Ratings
							WHERE  FK_PostID = PostID
						AND Upvote = 1)) AS "Upvotes",
         CONVERT(CHAR(10), (SELECT COUNT(*) 
							FROM   Ratings
							WHERE  FK_PostID = PostID
						AND Upvote = -1)) AS "Downvotes",
	     CONVERT(CHAR(10), ISNULL((
							SELECT SUM(Upvote) 
							FROM   Ratings
							WHERE  FK_PostID = PostID),0)) AS "Karma"
FROM     Posts
ORDER BY ISNULL((
         SELECT SUM(Upvote)
		 FROM Ratings
		 WHERE FK_PostID = PostID), 0) DESC, 
		 Upvotes DESC;
		 
GO
PRINT 'CIS 275, Lab Week 5, Question 7  [3pts possible]:
Karma
-----
For each user, show the username, the total number of posts made by that user, the total karma given to 
other users (sum of upvotes less downvotes given by the user), and total karma received (sum of upvotes
less downvotes received on posts made by that user). Use subqueries in the FROM/JOIN clauses (it
is possible to write this using subqueries in the SELECT clause, but use the subqueries in FROM/JOIN
instead). It is OK to use JOINs for this one (it''s impossible to write this query without both JOINs
and subqueries).

Format username as 20 characters wide and the other values as 10 characters wide. Order in descending 
order by total posts, then by total karma received, then by total karma given.

Hint: Start by writing separate queries to calculate total posts, total karma given and total karma 
received. Then, use those queries as subqueries in a SELECT statement that JOINs all those tables with
the Users table. Use outer JOINs to make sure that all users make it into the final list, even if those
users have no posts, and have given or received no upvotes.

Correct answers will have 21 rows and will look like this:

Username             Total Posts Total Karma Given Total Karma Received
-------------------- ----------- ----------------- --------------------
Alan.Turing          35          12                7         
jordon.fuchs         14          3                 5         
scott.ashley         12          8                 9         
matthew.johnson      12          5                 5         
solomon.oconnor      10          7                 4         
mohammad.abduallah   9           5                 7         
melissa.aizawa       9           1                 6         
dorothy.emmerson     9           3                 3         
brian.smith          7           3                 2         
...      
william.kareda       1           0                 1         
dick.phelps          1           1                 0         
jason.tyler          1           1                 0         
' + CHAR(10)

GO
SELECT     CONVERT(CHAR(20), Username) AS "Username",
           CONVERT(CHAR(10), ISNULL("TotalPosts", 0)) AS "Total Posts",
	       CONVERT(CHAR(10), ISNULL("TotalKarmaGiven", 0)) AS "Total Karma Given",
	       CONVERT(CHAR(10), ISNULL("TotalKarmaReceived", 0)) AS "Total Karma Received"
FROM       Users
LEFT JOIN (SELECT   FK_UserID,
	                SUM(Upvote) AS "TotalKarmaGiven"
		   FROM     Ratings
		   GROUP BY FK_UserID) AS Given ON Given.FK_UserID = Users.UserID
LEFT JOIN (SELECT   UserID,
		            SUM(Upvote) AS "TotalKarmaReceived"
		   FROM     Users 
		   JOIN     Posts ON Posts.FK_UserID = UserID 
		   JOIN     Ratings ON Ratings.FK_PostID = PostID
		   GROUP BY UserID) AS Received ON Received.UserID = Users.UserID
Left JOIN (SELECT   FK_UserID,
                    COUNT(*) AS "TotalPosts"
		   FROM     Posts
		   GROUP BY FK_UserID) AS POSTS ON POSTS.FK_UserID = Users.UserID
WHERE      Username NOT LIKE 'noPOSTS.%'
ORDER BY   ISNULL("TotalPosts", 0) DESC,
           ISNULL("TotalKarmaReceived", 0) DESC,
		   ISNULL("TotalKarmaGiven", 0) DESC;
		 
GO
PRINT 'CIS 275, Lab Week 5, Question 8  [3pts possible]:
Sympatico
---------
Show all pairs of authors who have responded to each other''s posts (Person A has responded to any of
Person B''s posts, and Person B has responded to any of Person A''s posts). Format usernames as 20 characters
wide and sort in alphabetical order by first author followed by second author. Use subqueries in the FROM/JOIN
clauses.

Hint: First, write a query that finds all pairs of authors where Author A has responded to Author B''s post.
Then, write an outer query that joins two copies of the first query together, and matches Author A in the first
subquery to Author B in the second subquery, and matches Author B in the first subquery to Author A in the second
subquery.

Correct answers will look like this:

First Author         Second Author
-------------------- --------------------
Alan.Turing          jordon.fuchs        
Alan.Turing          scott.ashley        
fox.henry            jordon.fuchs        
jordon.fuchs         Alan.Turing         
jordon.fuchs         fox.henry           
scott.ashley         Alan.Turing         
' + CHAR(10)

GO
USE Discussions
SELECT   DISTINCT CONVERT(CHAR(20), PU.Username) AS "First Author",
         CONVERT(CHAR(20), RU.Username) AS "Second Author"
FROM     (SELECT PARENT.FK_UserID AS "Parent Author",
			     REPLY.FK_UserID AS "Reply Author"
	      FROM   Posts AS PARENT 
	      JOIN   Posts AS REPLY ON REPLY.FK_ParentID = PARENT.PostID) AS P1
JOIN     (SELECT PARENT.FK_UserID AS "Parent Author",
                 REPLY.FK_UserID AS "Reply Author"
	      FROM   Posts AS PARENT 
	      JOIN   Posts AS REPLY ON REPLY.FK_ParentID = PARENT.PostID) AS P2 ON P1."Parent Author" = P2."Reply Author"
AND       P1."Reply Author" = P2."Parent Author"
JOIN      Users AS PU ON P1.[Parent Author] = PU.UserID
JOIN      Users AS RU ON P1.[Reply Author] = RU.UserID
WHERE     P1.[Parent Author] <> P2.[Parent Author]
ORDER BY "First Author",
         "Second Author";

GO
PRINT 'CIS 275, Lab Week 5, Question 9  [3pts possible]:
Uncommonly Sympatico
--------------------
Write the query in Question 8 again, but use Common Table Expressions instead of subqueries.
You should only need one common table expression.

Results will look the same as the previous query:

First Author         Second Author
-------------------- --------------------
Alan.Turing          jordon.fuchs        
Alan.Turing          scott.ashley        
fox.henry            jordon.fuchs        
jordon.fuchs         Alan.Turing         
jordon.fuchs         fox.henry           
scott.ashley         Alan.Turing         
' + CHAR(10)

GO
WITH PAIRS AS (SELECT PARENT.FK_UserID AS "Parent Author",
               REPLY.FK_UserID AS "Reply Author", 
			   PU.Username AS "Parent Username"
               FROM   Posts AS PARENT 
               JOIN   Posts AS REPLY ON REPLY.FK_ParentID = PARENT.PostID
               JOIN Users AS PU ON PARENT.FK_UserID = PU.UserID)
SELECT         DISTINCT CONVERT(CHAR(20), P1."Parent Username") AS "First Author",
               CONVERT(CHAR(20), P2."Parent Username") AS "Second Author"
FROM           PAIRS AS P1 
JOIN           PAIRS AS P2 ON P1.[Parent Author] = P2.[Reply Author]
AND            P1.[Reply Author] = P2.[Parent Author]
WHERE          P1.[Parent Author] <> P2.[Parent Author]
ORDER BY       "First Author",
               "Second Author";

GO
PRINT 'CIS 275, Lab Week 5, Question 10  [3pts possible]:
Conversation Starters
---------------------
Conversation starters are posts that lead to a lot of discussion. Here, we''re defining "discussion"
as replies to the start post, and replies to those replies, and so on, and so on. Find the top 10
"root posts" with the most conversation. For each of those root posts, show the post id for the root post,
the title of the root post, and the # of posts in the conversation (including the root post itself).
Format the id and # as 10 characters wide, and use 30 characters for the title. Order in descending
order by # of posts, and then alphabetically by title. Use a Common Table Expression to create a PARENTS
table. Your main SELECT statement (the part that comes after the Common Table Expression) should only 
refer to the PARENTS table without any further JOINs.

Note: There are two ways to do this, the easy way and the correct way. The easy way makes use of the
fact that the deepest reply thread in database is only 4 deep (a reply to a reply to a reply to a root post).
The correct way is to write a recursive CTE that can handle any depth of replies. You are NOT required
to do this one the correct way, but I urge you to attempt it, because exercising your brain is a good thing.

Hint 1 (the easy way): Write four seperate SELECT statements that return the root ID, the title of the 
root post, and the post ID of the post in that conversation. The first select statments covers the root 
post itself (FK_ParentID IS NULL for root posts). The second select statement covers the immediate replies 
to the root post. The third select statment joins Posts to itself to find the replies to the replies. The 
fourth select statement joins Posts to itself twice (three copies of Posts) to find replies to replies to 
replies to the root post. Then, in the SELECT statement that uses the PARENTS table, group by the root id 
and count the number of rows. That will give you the count of all posts under (and including) the root post 
itself. Use both IS NULL and IS NOT NULL where appropriate to get the counts right.

Hint 2 (the correct way): As in hint 1, you are finding the root id, the title of the root post, and the 
post ID of the post in that conversation. This time, you will have a basis step that includes all root 
posts (FK_ParentID IS NULL for root posts). This SELECT statement for the basis step will look exactly 
like the first SELECT statement in Hint 1. Then, add a recursion step that includes all children where 
the FK_PostID of the child matches the PostID of the parent. To find that, JOIN Posts with PARENTS. This
will look similar to what you did in the third select statement in Hint 1, except you will join Posts to
PARENTS instead of joining Posts to Posts. Finally, UNION ALL the basis step with the recursion step to 
get the same set of rows you got in Hint 1.

Correct results will look like this:

Root ID    Title                          Posts in Conversation
---------- ------------------------------ ---------------------
7011946    JavaScript Jobs                5         
7200903    Lesson#4 Discussion            5         
7010051    C#                             4         
6948071    How Much Is Too Much? --Jordon 4         
7174642    Programming as a Requirement   4         
6950180    Download and set up successful 3         
6984743    End-Users & Driving            3         
7069661    Simplicity                     3         
6905841    Which Version of Python to Ins 3         
7201029    Arrays                         2         
' + CHAR(10)

GO
WITH PARENTS AS ( SELECT PostID AS "Root ID", 
                  Title, 
				  PostID 
				  FROM Posts 
				  WHERE FK_ParentID IS NULL 
				  UNION ALL 
				  SELECT PARENTS."Root ID" AS "Root ID", 
				  PARENTS.Title, REPLY.PostID 
				  FROM Posts AS REPLY 
				  JOIN PARENTS ON REPLY.FK_ParentID = PARENTS.PostID ) 
SELECT            TOP 10 CONVERT(CHAR(10), "Root ID") AS "Root ID", 
                  CONVERT(CHAR(30), Title) AS "Title", 
	              CONVERT(CHAR(10), COUNT(*)) AS "Posts in Conversation" 
FROM              PARENTS 
GROUP BY          "Root ID", 
                  Title 
ORDER BY          COUNT(*) DESC,
                  Title; 
GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 5' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


