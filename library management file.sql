use library_management_db;
CREATE TABLE publisher (
	publisherName  varchar(100)  PRIMARY KEY, publisheraddress text, phoneNo text);
    
    select * from library_branch;
    drop table books;

create table books( book_id INT auto_increment PRIMARY KEY,
              book_title text,
            bookpublisherName varchar(100),
             FOREIGN KEY (bookpublisherName) REFERENCES library_management_db.publisher(publisherName) ON DELETE CASCADE ON UPDATE CASCADE
);    

create table library_branch( branch_id  INT auto_increment PRIMARY KEY, branchName varchar(100), branchaddress varchar(100)
);

create table customer(cardNo INT auto_increment PRIMARY KEY, Name varchar(100), Address varchar(100), phone varchar(100));
  
create table loan( loan_id INT auto_increment PRIMARY KEY, book_id int, branch_id int, cardNo int, dateout text, datedue text,
FOREIGN KEY (book_id) REFERENCES library_management_db.books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (branch_id) REFERENCES library_management_db.library_branch(branch_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (cardNo) REFERENCES library_management_db.customer(cardNo) ON DELETE CASCADE ON UPDATE CASCADE
);

create table book_copies( copies_id INT auto_increment PRIMARY KEY, book_id int, branch_id int,no_of_copies int,
FOREIGN KEY (book_id) REFERENCES library_management_db.books(book_id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (branch_id) REFERENCES library_management_db.library_branch(branch_id) ON DELETE CASCADE ON UPDATE CASCADE);

create table tbl_book_authors(AuthorID  INT auto_increment PRIMARY KEY, book_id int, AuthorName varchar(100),
FOREIGN KEY (book_id) REFERENCES library_management_db.books(book_id) ON DELETE CASCADE ON UPDATE CASCADE);


show tables;
select * from tbl_book_authors;

#1.	How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?


SELECT COUNT(copies_id) AS num_copies
FROM book_copies 
JOIN books  ON book_copies.book_id = books.book_id
JOIN library_branch  ON book_copies.branch_id = library_branch.branch_id
WHERE books.book_title = 'The Lost Tribe' AND library_branch.BranchName = 'Sharpstown';

#2.	How many copies of the book titled "The Lost Tribe" are owned by each library branch? 
    
SELECT library_branch.BranchName, COUNT(copies_id) AS num_copies
FROM book_copies 
JOIN books  ON book_copies.book_id = books.book_id
JOIN library_branch  ON book_copies.branch_id = library_branch.branch_id
WHERE books.book_title = 'The Lost Tribe'
GROUP BY library_branch.BranchName;

#3.	Retrieve the names of all borrowers who do not have any books checked out?

SELECT customer.name AS borrower_name
FROM customer 
LEFT JOIN loan  ON customer.cardNo = loan.cardNo
WHERE loan.loan_id IS NULL;

#3.	Retrieve the names of all borrowers who do not have any books checked out?

SELECT name AS borrower_name
FROM customer
WHERE cardNo NOT IN (
    SELECT DISTINCT (cardNo)
    FROM loan
);


#5.for each book that is loaned out from the "Sharpstown" branch and whose DueDate is today,
# retrieve the book title, the borrower's name, and the borrower's address.

SELECT books.book_title AS book_title, customer.name AS borrower_name, customer.address AS borrower_address
FROM books 
JOIN loan  ON books.book_id = loan.book_id
JOIN library_branch  ON loan.branch_id = library_branch.branch_id
JOIN customer  ON loan.cardNo = customer.cardNo
WHERE library_branch.BranchName = 'Sharpstown' AND loan.datedue = CURDATE();

#6.	For each library branch, retrieve the branch name and the total number of books loaned out from that branch?

SELECT library_branch.BranchName, COUNT(loan.book_id) AS total_books_loaned
FROM library_branch 
LEFT JOIN loan  ON library_branch.branch_id = loan.branch_id
GROUP BY library_branch.BranchName;

#7.	Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out?

SELECT customer.name AS borrower_name, customer.address AS borrower_address, COUNT(loan.loan_id) AS num_books_checked_out
FROM customer 
JOIN loan  ON customer.cardNo = loan.cardNo
GROUP BY customer.cardNo
HAVING COUNT(loan.loan_id) > 5;

#8.	For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central"?

SELECT books.book_title AS book_title, COUNT(book_copies.copies_id) AS num_copies_owned
FROM books 
JOIN tbl_book_authors  ON books.book_id = tbl_book_authors.Book_id
#JOIN author  ON ba.AuthorName = a.author_name
JOIN book_copies  ON books.book_id = book_copies.book_id
JOIN library_branch  ON book_copies.branch_id = library_branch.branch_id
WHERE tbl_book_authors.authorname = 'Stephen King' AND library_branch.BranchName = 'Central'
GROUP BY books.book_title;

#9.	How many copies of the book titled "The Hobbit" are owned by every branch?

SELECT library_branch.BranchName, COALESCE(SUM(book_copies.no_of_copies), 0) AS num_copies_owned
FROM library_branch 
LEFT JOIN book_copies  ON library_branch.branch_id = book_copies.branch_id
LEFT JOIN books  ON book_copies.book_id = books.book_id
WHERE books.book_title = 'The Hobbit'
GROUP BY library_branch.BranchName;

#10.	Find number of books loaned by customer “Joe Smith”?

SELECT COUNT(*) AS num_books_loaned
FROM loan 
JOIN customer  ON loan.cardNo = customer.cardNo
WHERE customer.name = 'Joe Smith';






