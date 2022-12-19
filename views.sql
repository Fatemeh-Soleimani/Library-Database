
--view 1 
--name and category of books loaned to each user
drop view if exists bookLoanedToUser;

create view bookLoanedToUser as 
select  Member.userID ,Book.title ,category.name
from ((Book inner join loans on Book.bookID=loans.bookID) 
inner join Member on loans.userID=Member.userID) 
inner join category on category.categoryID=Book.categoryID
where Book.valid=1
select * from bookLoanedToUser

--view 2
--books of Author from diffrent publishers with num of copies of them 
drop view if exists booksFromDiffrentPublisher;
create view booksFromDiffrentPublisher as
select Book.title,Book.publisherName, Authors.Name,copies.numOfCopies
from 
((Book inner join Authors 
on Book.bookID=Authors.bookID) 
inner join copies 
on Book.bookID=copies.bookID) 
inner join publisher 
on publisher.publisherName=Book.publisherName
where Book.valid=1

select * from booksFromDiffrentPublisher

--drop view booksFromDiffrentPublisher

--view 3
--title and num of copies of books in each category
drop view if exists booksInCategory;
create view booksInCategory as 
select Book.title as bookName,category.name as Category,copies.numOfCopies
from 
(Book inner join category 
on Book.categoryID=category.categoryID)
inner join copies
on copies.bookID=Book.bookID
where Book.valid=1

select * from booksInCategory
--drop view booksInCategory

--view 4
--number of books loaned in each category
drop view if exists numOfBooksEachCategory;
create view numOfBooksEachCategory as
select category.name, count(loans.bookID) as numOfLoanedBook
from ((Book inner join loans
on Book.bookID = loans.bookID)
inner join category 
on category.categoryID=Book.categoryID)
where Book.valid=1
group by category.name

select * from numOfBooksEachCategory

--view 5 
--total late penalty of each user
drop view if exists totalPenalty;
create view totalPenalty as
select Member.userID,Member.name,sum(penalty*numDays) as Penalty
from 
(Book inner join loans 
on Book.bookID=loans.bookID)
inner join Member 
on loans.userID=Member.userID
where Book.valid=1
group by Member.userID , Member.name

--return penalty null
select * from totalPenalty
drop view totalPenalty

--view 6
--available books
drop view if exists availableBooks;
create view availableBooks as
(select Book.bookID ,category.name as CATN
from Book inner join category 
on Book.bookID=category.categoryID
where Book.valid=1)
EXCEPT
(select Book.bookID , category.name as CATN
from (Book inner join loans 
on Book.bookID=loans.bookID) 
inner join category 
on category.categoryID=Book.categoryID
where loans.isReturned=0 
)

select * from availableBooks
