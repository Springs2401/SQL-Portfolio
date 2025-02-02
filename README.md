# SQL Portfolio Project

This repository contains my SQL portfolio project from my Data Science and AI bootcamp with atomcamp. The project involves analyzing the history of Stack Overflow posts, including edits, comments, and other changes, to gain insights into user activity and content evolution.

## About the Project
The goal of this project was to explore and analyze a real-world dataset using SQL queries. The dataset, sourced from Kaggle, contains multiple tables, including badges, comments, post history, post links, posts, users, and votes.

## Files in this Repository
- **SQL-Portfolio-Questions.pdf** – Contains the project questions and analysis tasks.
- **SQL-Project-Dataset.sql** – Contains the project dataset to be worked upon.
- **SQL-Portfolio-Tasks-and-Concepts.sql** – Includes queries for exploring data, filtering, sorting, and basic aggregations, joins, subqueries, and CTEs.
- **SQL-Portfolio-New-Insights-and-Questions.sql** – Contains queries with advanced SQL operations to analyse and get insights.
- **Tables** – A folder with 9 CSV files representing the database tables.
- **Deepnote Notebook** – [Click here to view my full project with SQL queries and insights](https://deepnote.com/app/springs24/SQL-Portfolio-Project-887d53c9-c13a-40b3-8f5e-7a655e0b22a9?utm_content=887d53c9-c13a-40b3-8f5e-7a655e0b22a9&__run=true).

## Tasks & Concepts Covered

### **Part 1: Basics**
- Loaded and explored data, checking the first 10 rows of each table.
- Found the total number of records in each table.
- Filtered posts with more than 2 comments and sorted comments by creation date.
- Counted the total number of badges and calculated the average score of posts by post type.

### **Part 2: Joins**
- Used basic joins to combine post history with posts to display title changes.
- Joined the users table with badges to find total badges earned per user.
- Used multi-table joins to fetch post titles, their comments, and the users who made them.

### **Part 3: Subqueries**
- Found the user with the highest reputation.
- Retrieved posts with the highest score in each post type.
- Used correlated subqueries to count the number of related posts.

### **Part 4: Common Table Expressions (CTEs)**
- Created a non-recursive CTE to calculate the average post score per user.
- Used a recursive CTE to simulate a hierarchy of linked posts.

### **Part 5: Advanced Queries**
- Used window functions to rank posts based on score within each year.
- Calculated the running total of badges earned by users.

### **Key Insights & Findings**
- Identified users with the most contributions (comments, edits, and votes).
- Analyzed which badges are most commonly earned and who the top earners are.
- Found the most popular tags associated with high-scoring posts.
- Studied the frequency of related question links to understand knowledge sharing patterns.

## Skills Used
- SQL Querying & Filtering  
- Joins & Multi-Table Queries  
- Aggregations & Subqueries  
- Common Table Expressions (CTEs)  
- Window Functions & Ranking  
- Data Analysis & Insights  

### **Additional Note**
All queries and insights have been documented in SQL scripts and the online Deepnote notebook.
