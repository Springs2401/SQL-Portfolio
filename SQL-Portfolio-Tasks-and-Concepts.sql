---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 1: BASICS ~ Loading and Exploring Data
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Explore the structure and first 10 rows of each table.

SELECT * 
FROM badges
LIMIT 10;

SELECT * 
FROM comments
LIMIT 10;

SELECT * 
FROM post_history
LIMIT 10;

SELECT * 
FROM post_links
LIMIT 10;

SELECT * 
FROM posts
LIMIT 10;

SELECT * 
FROM posts_answers
LIMIT 10;

SELECT * 
FROM tags
LIMIT 10;

SELECT * 
FROM users
LIMIT 10;

SELECT * 
FROM votes
LIMIT 10;

-- Identify the total number of records in each table.

SELECT COUNT(*) AS total_records 
FROM badges;

SELECT COUNT(*) AS total_records 
FROM comments;

SELECT COUNT(*) AS total_records 
FROM post_history;

SELECT COUNT(*) AS total_records 
FROM post_links;

SELECT COUNT(*) AS total_records 
FROM posts;

SELECT COUNT(*) AS total_records 
FROM posts_answers;

SELECT COUNT(*) AS total_records 
FROM tags;

SELECT COUNT(*) AS total_records 
FROM users;

SELECT COUNT(*) AS total_records 
FROM votes;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 1: BASICS ~ Filtering and Sorting
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Find all posts with a comment_count greater than 2.

SELECT DISTINCT p.* 
FROM posts p
JOIN comments c ON p.id = c.post_id
GROUP BY p.id
HAVING COUNT(c.id) > 2;

-- Display comments made in 2012, sorted by creation_date (comments table).

SELECT * 
FROM comments 
WHERE YEAR(creation_date) = 2012 
ORDER BY creation_date;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 1: BASICS ~ Simple Aggregations
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Count the total number of badges (badges table).

SELECT COUNT(*) AS total_badges 
FROM badges;

-- Calculate the average score of posts grouped by post_type_id (posts_answer table).

SELECT post_type_id, AVG(score) AS avg_score 
FROM posts_answers 
GROUP BY post_type_id;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 2: JOINS ~ Basic Joins
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Combine the post_history and posts tables to display the title of posts and the corresponding changes made in the post history.

SELECT p.id, p.title, ph.text, ph.creation_date
FROM post_history ph
JOIN posts p ON ph.post_id = p.id;

-- Join the users table with badges to find the total badges earned by each user.

SELECT u.display_name, COUNT(b.id) AS total_badges
FROM users u
JOIN badges b ON u.id = b.user_id
GROUP BY u.display_name;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 2: JOINS ~ Multi-Table Joins
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Fetch the titles of posts (posts), their comments (comments), and the users who made those comments (users).

SELECT p.title, c.text, u.display_name
FROM comments c
JOIN posts p ON c.post_id = p.id
JOIN users u ON c.user_id = u.id;

-- Combine post_links with posts to list related questions.

SELECT p1.title AS post_title, p2.title AS related_post_title
FROM post_links pl
JOIN posts p1 ON pl.post_id = p1.id
JOIN posts p2 ON pl.related_post_id = p2.id;

-- Join the users, badges, and comments tables to find the users who have earned badges and made comments.

SELECT u.display_name, COUNT(b.id) AS badges_count, COUNT(c.id) AS comments_count
FROM users u
LEFT JOIN badges b ON u.id = b.user_id
LEFT JOIN comments c ON u.id = c.user_id
GROUP BY u.display_name;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 3: SUBQUERIES ~ Single-Row Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Find the user with the highest reputation (users table).

SELECT * 
FROM users 
WHERE reputation = (
SELECT MAX(reputation)
FROM users);

-- Retrieve posts with the highest score in each post_type_id (posts table).

SELECT * FROM posts p
WHERE score = (
SELECT MAX(score) 
FROM posts p2 
WHERE p2.post_type_id = p.post_type_id);

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 3: SUBQUERIES ~ Correlated Subqueries
---------------------------------------------------------------------------------------------------------------------------------------------------

-- For each post, fetch the number of related posts from post_links.

SELECT p.title, (
SELECT COUNT(*) 
FROM post_links pl 
WHERE pl.post_id = p.id) AS related_posts_count
FROM posts p;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 4: COMMON TABLE EXPRESSIONS (CTEs) ~ Non-Recursive CTE
---------------------------------------------------------------------------------------------------------------------------------------------------

/* 
Create a CTE to calculate the average score of posts by each user and use it to:
- List users with an average score above 50.
- Rank users based on their average post score.
*/

WITH average_scores AS (
SELECT owner_user_id, AVG(score) AS avg_score
FROM posts_answers
GROUP BY owner_user_id
HAVING AVG(score) > 50)

SELECT u.display_name, a.avg_score,
RANK() OVER (ORDER BY a.avg_score DESC) AS user_rank
FROM average_scores a
JOIN users u ON a.owner_user_id = u.id
ORDER BY a.avg_score DESC;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 4: COMMON TABLE EXPRESSIONS (CTEs) ~ Recursive CTE
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Simulate a hierarchy of linked posts using the post_links table.

WITH RECURSIVE hierarchy AS (
SELECT post_id, related_post_id, 1 AS level
FROM post_links
WHERE post_id = 2001
UNION ALL
SELECT pl.post_id, pl.related_post_id, h.level + 1
FROM hierarchy h
INNER JOIN post_links pl ON h.related_post_id = pl.post_id
WHERE h.level < 15) -- NOTE: I added this parameter because without it, the query was taking a lot of time to load (~30s) and failing due to lost connection

SELECT post_id, related_post_id, level
FROM hierarchy
ORDER BY level;

---------------------------------------------------------------------------------------------------------------------------------------------------
-- PART 5: ADVANCED QUERIES ~ Window Functions
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Rank posts based on their score within each year (posts table).

SELECT title, score, creation_date, 
RANK() OVER (PARTITION BY YEAR(creation_date) ORDER BY score DESC) AS `rank`
FROM posts;

-- Calculate the running total of badges earned by users (badges table).

SELECT user_id, name, 
SUM(1) OVER (PARTITION BY user_id ORDER BY date) AS running_total
FROM badges;