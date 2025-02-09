## ER Diagram for Journal Database
![Journal Database ER Diagram](https://github.com/himusharier/isdb-oracle-journal-publication-database/blob/5e431cb70b3feaf3deb04c50f96338253ffa1781/journal-publication%2C%20er-diagram%20(actual).png)

# Journal Database SQL Queries

## Basic Queries

### 1. Retrieve Journal Names and Publication Types
```sql
SELECT journal_name, publication_type FROM journals;
```

### 2. Find Researchers
```sql
SELECT first_name, last_name, profession 
FROM users 
WHERE profession = 'Botanist';
```

### 3. Journals with Impact Factor > 2
```sql
SELECT journal_name, impact_factor 
FROM journals 
WHERE impact_factor > 2;
```

### 4. Articles by Volume/Issue
```sql
SELECT a.article_title, j.journal_name
FROM articles a
JOIN journals j ON a.journal_id = j.journal_id
WHERE a.vol_issue = 'Vol5Issue01';
```

### 5. Journals and Publication Frequency
```sql
SELECT journal_name, publication_frequency 
FROM journals;
```

### 6. Users with Ecology in Profession
```sql
SELECT first_name, last_name, profession
FROM users
WHERE profession LIKE '%Plant%';
```

## Aggregation & Filtering

### 7. Total Crop Science Journal
```sql
SELECT COUNT(*) AS total_articles
FROM articles a
JOIN journals j ON a.journal_id = j.journal_id
WHERE j.journal_name = 'Crop Science Journal';
```

### 8. Journals with Acceptance Rate > 40%
```sql
SELECT journal_name, acceptance_rate
FROM journals
WHERE acceptance_rate > 40;
```

### 9. Announcements for Journal of Plant Pathology
```sql
SELECT topic, announcement, announce_date
FROM announcements a
JOIN journals j ON a.journal_id = j.journal_id
WHERE j.journal_name = 'Journal of Plant Pathology';
```

### 10. Average Impact Factor of Journals
```sql
SELECT AVG(impact_factor) AS avg_impact_factor
FROM journals j
WHERE j.journal_id IN (
    SELECT journal_id 
    FROM issues i 
    WHERE i.journal_id = j.journal_id
);
```

## Complex Joins

### 11. Editorial Members of Journal of Plant Pathology
```sql
SELECT u.first_name, u.last_name, e.category
FROM editorial e
JOIN users u ON e.user_id = u.user_id
JOIN journals j ON e.journal_id = j.journal_id
WHERE j.journal_name = 'Journal of Plant Pathology';
```

### 12. Articles by Specific Author
```sql
SELECT a.article_title, j.journal_name, a.vol_issue, a.published_date
FROM articles a
JOIN journals j ON a.journal_id = j.journal_id
WHERE a.author = 3;
```

### 13. Journals with Articles and Abstracts
```sql
SELECT j.journal_name, a.article_title, a.abstract
FROM articles a
JOIN journals j ON a.journal_id = j.journal_id;
```

### 14. Issues of Journal of Agricultural Biotechnology
```sql
SELECT vol_issue, publish_date
FROM issues
JOIN journals j ON issues.journal_id = j.journal_id
WHERE j.journal_name = 'Journal of Agricultural Biotechnology';
```

## Subqueries & Advanced Filtering

### 15. Users Authoring in High Impact Journals
```sql
SELECT DISTINCT u.first_name, u.last_name
FROM users u
WHERE u.user_id IN (
    SELECT a.author
    FROM articles a
    JOIN journals j ON a.journal_id = j.journal_id
    WHERE j.impact_factor > 3
);
```

### 16. Most Recent Article in Specific Volume/Issue
```sql
SELECT a.article_title, u.first_name, u.last_name, j.journal_name
FROM articles a
JOIN users u ON a.author = u.user_id
JOIN journals j ON a.journal_id = j.journal_id
WHERE a.vol_issue = 'Vol2Issue01'
ORDER BY a.published_date DESC
FETCH FIRST 1 ROWS ONLY;
```

### 17. Journals Above Average Acceptance Rate
```sql
SELECT journal_name, acceptance_rate
FROM journals
WHERE acceptance_rate > (SELECT AVG(acceptance_rate) FROM journals);
```

### 18. Editorial Members in High Impact Journals
```sql
SELECT DISTINCT u.first_name, u.last_name
FROM editorial e
JOIN users u ON e.user_id = u.user_id
JOIN journals j ON e.journal_id = j.journal_id
WHERE j.impact_factor > 2;
```

### 19. Most Recent Announcement per Journal
```sql
SELECT a.journal_id, a.topic, a.announce_date
FROM announcements a
WHERE a.announce_date IN (
    SELECT MAX(announce_date)
    FROM announcements
    GROUP BY journal_id
);
```

### 20. Articles Without Corresponding Author
```sql
SELECT article_title, vol_issue, journal_id
FROM articles
WHERE crosponding_author IS NULL;
```

## Data Integrity & Constraints

### 21. Insert New Journal
```sql
INSERT INTO journals (
    journal_name, eissn_id, publication_type, 
    impact_factor, publication_frequency, acceptance_rate
)
VALUES (
    'Journal of Advanced Research', '1234-5678', 'Academic', 
    3.5, 'Monthly', 30
);
```

### 22. Update Journal Acceptance Rate
```sql
UPDATE journals
SET acceptance_rate = 45
WHERE journal_name = 'Plant Biotechnology Review';
```

### 23. Delete User
```sql
DELETE FROM users WHERE user_id = 4;
```

## Advanced Data Operations

### 24. Journals with No Published Articles
```sql
SELECT journal_name
FROM journals j
WHERE j.journal_id NOT IN (
    SELECT DISTINCT journal_id FROM articles
);
```

### 25. Journals with More Than 3 Announcements
```sql
SELECT j.journal_name, COUNT(a.announcement_id) AS total_announcements
FROM journals j
LEFT JOIN announcements a ON j.journal_id = a.journal_id
GROUP BY j.journal_name
HAVING COUNT(a.announcement_id) > 3;
```

# SQL Question Bank for Database Schema

## 1. Table Creation Questions

### 1.1. How would you create a table `journals` with columns: `journal_id`, `journal_name`, `eissn_id`, `publication_type`, `impact_factor`, `publication_frequency`, and `acceptance_rate`?

### 1.2. How would you create a table `issues` with columns: `journal_id`, `vol_issue`, and `publish_date`, and create a foreign key relationship with the `journals` table?

### 1.3. How would you create a table `announcements` with columns: `journal_id`, `topic`, `announcement`, and `announce_date`, and create a foreign key relationship with the `journals` table?

### 1.4. How would you create a table `users` with columns: `user_id`, `first_name`, `last_name`, `gender`, `date_of_birth`, `email`, `phone`, `profession`, `institute`, `country`, and `address`? Ensure a gender constraint.

### 1.5. How would you create a table `editorial` with columns: `journal_id`, `user_id`, and `category`, and create foreign key relationships with the `journals` and `users` tables?

### 1.6. How would you create a table `articles` with columns: `journal_id`, `article_id`, `vol_issue`, `article_title`, `abstract`, `article_type`, `keywords`, `doi_id`, `author`, `crosponding_author`, and `published_date`, and create foreign key relationships with the `issues` and `users` tables?

## 2. Data Insertion Questions

### 2.1. How would you insert a record into the `journals` table with values: `journal_name`, `eissn_id`, `publication_type`, `impact_factor`, `publication_frequency`, and `acceptance_rate`?

### 2.2. How would you insert a record into the `issues` table with values: `journal_id`, `vol_issue`, and `publish_date`?

### 2.3. How would you insert a record into the `announcements` table with values: `journal_id`, `topic`, `announcement`, and `announce_date`?

### 2.4. How would you insert a record into the `users` table with values: `first_name`, `last_name`, `gender`, `date_of_birth`, `email`, `phone`, `profession`, `institute`, `country`, and `address`?

### 2.5. How would you insert a record into the `editorial` table with values: `journal_id`, `user_id`, and `category`?

### 2.6. How would you insert a record into the `articles` table with values: `journal_id`, `vol_issue`, `article_title`, `abstract`, `article_type`, `keywords`, `doi_id`, `author`, `crosponding_author`, and `published_date`?

## 3. Query Questions

### 3.1. How would you fetch all articles from the `articles` table where the `article_type` is `Research`?

### 3.2. How would you fetch the journal name and the acceptance rate of journals with `impact_factor` greater than 3 from the `journals` table?

### 3.3. How would you find the number of articles published in each volume and issue from the `articles` table?

### 3.4. How would you fetch all the users who are working as `Research Scientists`?

### 3.5. How would you fetch all announcements that were made after `2024-01-01` from the `announcements` table?

### 3.6. How would you list the details of articles that were published in a specific volume (e.g., 'Vol 1 Issue 01') of a journal?

### 3.7. How would you fetch the details of articles and their corresponding authors from the `articles` table, joining the `users` table to get author names?

### 3.8. How would you fetch all the journals with `publication_type` as `Research` and `acceptance_rate` as `high`?

### 3.9. How would you get the total number of issues published per journal from the `issues` table?

### 3.10. How would you find the average impact factor of all journals in the `journals` table?

## 4. Alter Table and Constraints Questions

### 4.1. How would you add a new column `language` to the `journals` table?

### 4.2. How would you modify the `users` table to allow a `NULL` value for the `phone` column?

### 4.3. How would you add a constraint to the `articles` table to ensure that the `published_date` is not in the future?

### 4.4. How would you create a unique constraint on the `email` column in the `users` table?

### 4.5. How would you remove the foreign key constraint `editorial_journal_id_fk_journals` from the `editorial` table?

### 4.6. How would you rename the `articles` table to `journal_articles`?

## 5. Data Deletion and Update Questions

### 5.1. How would you delete all articles where the `article_type` is `Review` from the `articles` table?

### 5.2. How would you update the `impact_factor` of a journal in the `journals` table where `journal_id` is 3?

### 5.3. How would you delete a specific user from the `users` table by their `user_id`?

### 5.4. How would you update the `address` of a user in the `users` table based on their `user_id`?

### 5.5. How would you delete all records from the `announcements` table that are older than `2024-01-01`?

### 5.6. How would you delete all issues from the `issues` table related to a specific journal (`journal_id = 2`)?

### 5.7. How would you delete a specific editorial entry from the `editorial` table based on `journal_id` and `user_id`?

## 6. Join and Subquery Questions

### 6.1. How would you retrieve a list of all articles along with their respective journal names using a JOIN between the `articles` and `journals` tables?

### 6.2. How would you find the users who are part of the editorial board of a particular journal, say `journal_id = 3`?

### 6.3. How would you retrieve the titles of articles that were published after `2024-01-01` and their corresponding journal names?

### 6.4. How would you retrieve the authors who have more than one article published, using a subquery in the `articles` table?

### 6.5. How would you fetch the list of articles published in a journal whose name starts with "Botanical" from the `journals` and `articles` tables?

### 6.6. How would you retrieve the details of all announcements related to a specific journal by joining the `announcements` and `journals` tables?

### 6.7. How would you retrieve the number of articles published in each journal, including the journal name, by using a GROUP BY clause in the `articles` table?

### 6.8. How would you fetch the names of the users who are editors for a journal with a specific `journal_id`?

### 6.9. How would you list the journals that have published more than 10 issues?

### 6.10. How would you fetch the latest articles for each journal based on the `published_date`?
