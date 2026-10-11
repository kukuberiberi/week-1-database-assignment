-- ====================================================================
-- Assignment: Week 1 Database Assignment
-- Topic: Library Management System
-- File Name: answer.sql
-- ====================================================================

-- 1. Database Setup
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- 2. Drop existing tables safely (in reverse order of dependencies)
DROP TABLE IF EXISTS borrowings;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS authors;

-- 3. Table Definitions
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_year INT
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT NOT NULL,
    category_id INT NOT NULL,
    published_year INT,
    available_copies INT NOT NULL DEFAULT 1,
    CONSTRAINT fk_book_author FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE,
    CONSTRAINT fk_book_category FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    joined_date DATE NOT NULL
);

CREATE TABLE borrowings (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrow_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    CONSTRAINT fk_borrow_book FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_borrow_member FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- 4. Seed Data Insertion
INSERT INTO authors (first_name, last_name, birth_year) VALUES 
('J.K.', 'Rowling', 1965),
('George', 'Orwell', 1903),
('Agatha', 'Christie', 1890);

INSERT INTO categories (category_name) VALUES 
('Fantasy'),
('Dystopian'),
('Mystery');

INSERT INTO books (title, author_id, category_id, published_year, available_copies) VALUES 
('Harry Potter and the Sorcerer''s Stone', 1, 1, 1997, 4),
('1984', 2, 2, 1949, 3),
('Murder on the Orient Express', 3, 3, 1934, 2);

INSERT INTO members (first_name, last_name, email, joined_date) VALUES 
('Alice', 'Smith', 'alice.smith@example.com', '2025-01-10'),
('Bob', 'Johnson', 'bob.johnson@example.com', '2025-02-15');

INSERT INTO borrowings (book_id, member_id, borrow_date, due_date, return_date) VALUES 
(1, 1, '2026-03-01', '2026-03-15', '2026-03-10'),
(2, 2, '2026-03-05', '2026-03-19', NULL);

-- 5. Verification Queries
SELECT 
    b.book_id, 
    b.title, 
    CONCAT(a.first_name, ' ', a.last_name) AS author_name, 
    c.category_name, 
    b.available_copies
FROM books b
JOIN authors a ON b.author_id = a.author_id
JOIN categories c ON b.category_id = c.category_id;

SELECT 
    br.borrow_id,
    CONCAT(m.first_name, ' ', m.last_name) AS member_name,
    bk.title AS book_title,
    br.borrow_date,
    br.due_date
FROM borrowings br
JOIN members m ON br.member_id = m.member_id
JOIN books bk ON br.book_id = bk.book_id
WHERE br.return_date IS NULL;
