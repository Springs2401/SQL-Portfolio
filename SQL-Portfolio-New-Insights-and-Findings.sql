---------------------------------------------------------------------------------------------------------------------------------------------------
-- Which users have contributed the most in terms of comments, edits, and votes?
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Query to find out who the top contributors are:
SELECT u.display_name, COUNT(DISTINCT c.id) AS total_comments, COUNT(DISTINCT ph.id) AS total_edits, COUNT(DISTINCT v.id) AS total_votes, 
(COUNT(DISTINCT c.id) + COUNT(DISTINCT ph.id) + COUNT(DISTINCT v.id)) AS total_contribution
FROM users u
LEFT JOIN comments c ON u.id = c.user_id
LEFT JOIN post_history ph ON u.id = ph.user_id
LEFT JOIN votes v ON u.id = v.post_id
GROUP BY u.id
ORDER BY total_contribution DESC;

/*
Alice and Bob are the top contributors, each with 3 comments and 3 edits, displaying the highest level of activity.
Charlie and Dave follow closely, contributing 2 comments and 2 edits each, ranking just below the top contributors in the table.
*/

---------------------------------------------------------------------------------------------------------------------------------------------------
-- What types of badges are most commonly earned, and which users are the top earners?
---------------------------------------------------------------------------------------------------------------------------------------------------

-- NOTE: I have queried using 2 different approaches (separately using 2 different queries and a combined method).

-- Query to find the common badges:
SELECT name AS badge_type, COUNT(*) AS total_earned
FROM badges
GROUP BY name
ORDER BY total_earned DESC;

-- Query to find the top earners of each badge:
SELECT u.display_name, COUNT(b.id) AS total_badges
FROM users u
JOIN badges b ON u.id = b.user_id
GROUP BY u.id
ORDER BY total_badges DESC;

-- A combined query to find badges that are most commonly earned and the top earners for each:
SELECT b.name AS badge_type, u.display_name AS top_user, COUNT(CASE WHEN b.user_id = u.id THEN 1 END) AS top_earners
FROM badges b
JOIN users u ON b.user_id = u.id
GROUP BY b.name, u.display_name
ORDER BY top_earners DESC;

/*
The 'Gold Contributor' badge was most commonly earned (4 times) and the other two badges were each earned 3 times.
Alice is the top earner who has secured a total of 4 badges, which is double the amount of badges other individual students have obtained.
*/

---------------------------------------------------------------------------------------------------------------------------------------------------
-- Which tags are associated with the highest-scoring posts?
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Query to find the tags, total score of posts associated with each tag, and the posts' average score:
WITH post_tags AS (
SELECT 2001 AS post_id, 1 AS tag_id 
UNION ALL
SELECT 2002, 2 
UNION ALL
SELECT 2003, 1 
UNION ALL
SELECT 2004, 3 
UNION ALL
SELECT 2005, 10)

SELECT t.tag_name, SUM(p.score) AS total_score, AVG(p.score) AS avg_score
FROM post_tags pt
JOIN tags t ON pt.tag_id = t.id
JOIN posts p ON pt.post_id = p.id
GROUP BY t.tag_name
ORDER BY total_score DESC;

/*
The posts with the highest scores are commonly linked to the tags 'SQL' and 'Database' as the total score is highest for those two tags (30).
However, if we look at the average score, the posts associated with the 'Database' tag are on the top with 30.00, followed by 'React' with an average score of 25.00.
This analysis tells us that majority of the top-scoring posts are tagged with 'Database'.
*/

---------------------------------------------------------------------------------------------------------------------------------------------------
-- How often are related questions linked, and what does this say about knowledge sharing?
---------------------------------------------------------------------------------------------------------------------------------------------------

-- Query to display the numbers of total links made, distinct posts linked, and unique related posts:
SELECT COUNT(*) AS total_links, COUNT(DISTINCT post_id) AS unique_posts_linked, COUNT(DISTINCT related_post_id) AS unique_related_posts
FROM post_links;

-- Query to show original and related post titles and the number of links made:
SELECT p1.title AS original_post, p2.title AS related_post, COUNT(*) AS link_count
FROM post_links pl
JOIN posts p1 ON pl.post_id = p1.id
JOIN posts p2 ON pl.related_post_id = p2.id
GROUP BY p1.id, p2.id
ORDER BY link_count DESC;

/*
As shown by the first query, there are a total of 10 links, which shows moderate connectivity between posts.
5 unique posts were linked, suggesting that a subset of posts act as connectors.
6 unique posts were linked to, indicating slightly more diversity in the referenced content.
The queries show that links are distributed evenly, with each pair having 1 connection.
Posts such as “How to solve SQL JOIN issues?” and “What is a LEFT JOIN?” are central and have a foundational role in discussions as they reference multiple topics.
Relatively low link counts suggest cross-referencing is limited.
The low link count indicates room for improvement in encouraging more knowledge connections among posts.
*/
