--view 1 
--name and category of books loaned to each user
--drop view if exists bookLoanedToUser;

create view bookLoanedToUser as 
select  Member.userID ,Book.title ,category.name as category
from ((Book inner join loans on Book.bookID=loans.bookID) 
inner join Member on loans.userID=Member.userID) 
inner join category on category.categoryID=Book.categoryID
--where Book.valid=1

select * from bookLoanedToUser order by userID

---------------------------------------------------------------------------------

--view 2
--books of Author from diffrent publishers with num of copies of them 
--drop view if exists booksFromDiffrentPublisher;
create view booksFromDiffrentPublisher as
select Book.title,Book.publisherName, Authors.firstName+' '+Authors.lastName as author,copies.numOfCopies
from 
(Book inner join Authors 
on Book.AuthorID=Authors.AuthorID
inner join copies 
on Book.bookID=copies.bookID) 
inner join publisher 
on publisher.publisherName=Book.publisherName
where Book.valid=1

select * from booksFromDiffrentPublisher

---------------------------------------------------------------------------------

--view 3
--title and num of copies of books in each category
--drop view if exists booksInCategory;
create view booksInCategory as 
select category.name as Category,sum(copies.numOfCopies) as num
from Book inner join category 
on Book.categoryID=category.categoryID
inner join copies
on copies.bookID=Book.bookID
where Book.valid=1
group by category.name

select * from booksInCategory
--drop view booksInCategory

---------------------------------------------------------------------------------

--view 4
--number of books loaned in each category
--drop view if exists numOfBooksLoanedInEachCategory;
create view numOfBooksLoanedInEachCategory as
select category.name, count(loans.bookID) as numOfLoanedBook
from Book inner join loans
on Book.bookID = loans.bookID
inner join category 
on category.categoryID=Book.categoryID
where Book.valid=1
group by category.name

select * from numOfBooksLoanedInEachCategory

---------------------------------------------------------------------------------

--view 5 
--total late penalty of each user
--drop view if exists totalPenalty;
create view totalPenalty as
select Member.userID,Member.firstname+' '+Member.lastname as name,sum(penalty*numDays) as Penalty
from 
Book inner join loans 
on Book.bookID=loans.bookID
inner join Member 
on loans.userID=Member.userID
--where Book.valid=1
group by Member.userID,Member.firstname+' '+Member.lastname

--return penalty null
select * from totalPenalty

--drop view totalPenalty

---------------------------------------------------------------------------------

--view 6
--uses function 9
--available books
--drop view if exists availableBooks;
create view availableBooks as
(select Book.bookID ,book.title, dbo.remaining_books(Book.bookID) as num
from Book
where Book.valid=1
)

select * from availableBooks
order by bookID
