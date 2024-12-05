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
