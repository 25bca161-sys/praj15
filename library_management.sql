-- ==========================================
-- LIBRARY MANAGEMENT SYSTEM
-- BCA DBMS MINI PROJECT
-- DATABASE: librarydb
-- ==========================================

-- 1. CREATE DATABASE

CREATE DATABASE librarydb;
USE librarydb;

-- 2. CREATE MEMBERS TABLE

CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    member_type VARCHAR(20),
    joined_date DATE
);

-- 3. CREATE BOOKS TABLE

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    copies_available INT
);

-- 4. CREATE ISSUES TABLE

CREATE TABLE issues (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- 5. INSERT MEMBERS

INSERT INTO members
(member_name, member_type, joined_date)
VALUES
('Arun','Student','2025-01-10'),
('Bhuvana','Student','2025-01-12'),
('Rahul','Student','2025-02-01'),
('Priya','Faculty','2025-02-05'),
('Kiran','Student','2025-02-10'),
('Sneha','Student','2025-03-01'),
('Amit','Faculty','2025-03-05'),
('Divya','Student','2025-03-10'),
('Ravi','Student','2025-04-01'),
('Anu','Faculty','2025-04-05'),
('Manoj','Student','2025-04-10'),
('Neha','Student','2025-05-01');

-- 6. INSERT BOOKS

INSERT INTO books
(title, author, category, price, copies_available)
VALUES
('Python Basics','John','Programming',450,5),
('Java Programming','James','Programming',500,4),
('SQL Guide','Smith','Database',350,3),
('DBMS Concepts','Ramesh','Database',400,2),
('Computer Networks','Andrew','Networking',550,3),
('C Programming','Dennis','Programming',300,4),
('Mathematics','Ravi','Mathematics',250,2),
('Science Today','David','Science',200,3),
('Wings of Fire','APJ Abdul Kalam','Fiction',300,2),
('Data Science','Tom','Programming',600,4),
('Operating System','Galvin','Computer Science',500,3),
('Artificial Intelligence','Russell','AI',700,2),
('Statistics','Gupta','Mathematics',350,3),
('Internet Basics','Peter','Networking',250,2),
('Machine Learning','Tom Mitchell','AI',650,3);

-- 7. INSERT ISSUE RECORDS

INSERT INTO issues
(member_id, book_id, issue_date, due_date, return_date)
VALUES
(1,1,'2025-01-01','2025-01-15','2025-01-18'),
(2,2,'2025-01-02','2025-01-16','2025-01-16'),
(3,3,'2025-01-03','2025-01-17',NULL),
(4,4,'2025-01-04','2025-02-03','2025-02-05'),
(5,5,'2025-01-05','2025-01-19','2025-01-19'),
(6,6,'2025-01-06','2025-01-20','2025-01-22'),
(7,7,'2025-01-07','2025-02-06',NULL),
(8,8,'2025-01-08','2025-01-22','2025-01-22'),
(9,9,'2025-01-09','2025-01-23','2025-01-25'),
(10,10,'2025-01-10','2025-02-09',NULL),
(11,11,'2025-01-11','2025-01-25','2025-01-25'),
(12,12,'2025-01-12','2025-01-26','2025-01-29'),
(1,2,'2025-02-01','2025-02-15','2025-02-15'),
(2,3,'2025-02-02','2025-02-16',NULL),
(3,4,'2025-02-03','2025-02-17','2025-02-20'),
(4,5,'2025-02-04','2025-03-06','2025-03-06'),
(5,6,'2025-02-05','2025-02-19','2025-02-19'),
(6,7,'2025-02-06','2025-02-20',NULL),
(7,8,'2025-02-07','2025-03-09','2025-03-12'),
(8,9,'2025-02-08','2025-02-22','2025-02-22'),
(9,10,'2025-02-09','2025-02-23',NULL),
(10,11,'2025-02-10','2025-03-12','2025-03-12'),
(11,12,'2025-02-11','2025-02-25','2025-02-28'),
(12,13,'2025-02-12','2025-02-26',NULL),
(1,14,'2025-03-01','2025-03-15','2025-03-15'),
(2,15,'2025-03-02','2025-03-16','2025-03-18'),
(3,1,'2025-03-03','2025-03-17',NULL),
(4,2,'2025-03-04','2025-04-03','2025-04-03'),
(5,3,'2025-03-05','2025-03-19','2025-03-22'),
(6,4,'2025-03-06','2025-03-20',NULL),
(7,5,'2025-03-07','2025-04-06','2025-04-06'),
(8,6,'2025-03-08','2025-03-22','2025-03-22');

-- 8. DISPLAY ALL RECORDS

SELECT * FROM members;
SELECT * FROM books;
SELECT * FROM issues;

-- 9. COUNT TOTAL RECORDS

SELECT COUNT(*) AS total_members FROM members;
SELECT COUNT(*) AS total_books FROM books;
SELECT COUNT(*) AS total_issues FROM issues;

-- 10. BOOKS IN EACH CATEGORY

SELECT category,
COUNT(*) AS total_titles,
SUM(copies_available) AS available_copies
FROM books
GROUP BY category;

-- 11. TOP 5 BORROWED BOOKS

SELECT b.title,
COUNT(i.issue_id) AS borrowed
FROM books b
JOIN issues i ON b.book_id = i.book_id
GROUP BY b.book_id, b.title
ORDER BY borrowed DESC
LIMIT 5;

-- 12. MEMBERS WHO NEVER BORROWED

SELECT m.member_name
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id
WHERE i.issue_id IS NULL;

-- 13. CURRENTLY ISSUED BOOKS

SELECT m.member_name, b.title, i.due_date
FROM issues i
JOIN members m ON i.member_id = m.member_id
JOIN books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL;

-- 14. LATE RETURN FINE (RS.2 PER DAY)

SELECT issue_id,
DATEDIFF(return_date, due_date) AS late_days,
DATEDIFF(return_date, due_date) * 2 AS fine
FROM issues
WHERE return_date > due_date;

-- 15. TOTAL FINE PER MEMBER

SELECT m.member_name,
SUM(GREATEST(DATEDIFF(i.return_date,i.due_date),0)*2)
AS total_fine
FROM members m
JOIN issues i ON m.member_id = i.member_id
GROUP BY m.member_id, m.member_name;

-- 16. STUDENT AND FACULTY COMPARISON

SELECT m.member_type,
COUNT(i.issue_id) AS total_borrowed
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id
GROUP BY m.member_type;

-- 17. RANK MEMBERS

SELECT m.member_name,
COUNT(i.issue_id) AS total_books,
RANK() OVER (
ORDER BY COUNT(i.issue_id) DESC
) AS ranking
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id
GROUP BY m.member_id, m.member_name;

-- 18. MOST POPULAR CATEGORY

SELECT b.category,
COUNT(i.issue_id) AS total_borrowed
FROM books b
JOIN issues i ON b.book_id = i.book_id
GROUP BY b.category
ORDER BY total_borrowed DESC
LIMIT 1;

-- 19. BOOKS WITH ZERO AVAILABLE COPIES

SELECT * FROM books
WHERE copies_available = 0;

-- 20. BOOKS WITH ZERO COPIES AND PENDING ISSUES

SELECT b.title,
COUNT(i.issue_id) AS pending_issues
FROM books b
JOIN issues i ON b.book_id = i.book_id
WHERE b.copies_available = 0
AND i.return_date IS NULL
GROUP BY b.book_id, b.title;

-- 21. STORED PROCEDURE

DELIMITER //

CREATE PROCEDURE MemberHistory(IN mid INT)
BEGIN
    SELECT m.member_name, b.title,
    i.issue_date, i.due_date, i.return_date
    FROM issues i
    JOIN members m ON i.member_id = m.member_id
    JOIN books b ON i.book_id = b.book_id
    WHERE m.member_id = mid;
END //

DELIMITER ;

CALL MemberHistory(1);

-- 22. TRIGGER

DELIMITER //

CREATE TRIGGER reduce_copies
AFTER INSERT ON issues
FOR EACH ROW
BEGIN
    UPDATE books
    SET copies_available = copies_available - 1
    WHERE book_id = NEW.book_id
    AND copies_available > 0;
END //

DELIMITER ;

-- 23. FINAL OUTPUT

SELECT * FROM members;
SELECT * FROM books;
SELECT * FROM issues;

-- END OF PROJECT