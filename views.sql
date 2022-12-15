
--view 1 
--name and category of books loaned to each user
create view bookLoanedToUser as 
select  Member.userID, Member.name ,Book.title ,category.name
from ((Book inner join loans on Book.bookID=loans.bookID) 
inner join Member on loans.userID=Member.userID) 
inner join category on category.categoryID=Book.categoryID


--view 2
--books of Author from diffrent publishers with num of copies of them exist in library
create view booksFromDiffrentPublisher as
select Book.title,publisher.publisherName, Authors.Name,copies.numOfCopies
from 
((Book inner join Authors 
on Book.bookID=Authors.bookID) 
inner join copies 
on Book.bookID=copies.bookID) 
inner join publisher 
on copies.publisherName=publisher.publisherName


--view 3
--title and num of copies of books in each category
create view booksInCategory as 
select Book.title,category.name,copies.numOfCopies
from 
(Book inner join category 
on Book.categoryID=category.categoryID)
inner join copies
on copies.bookID=Book.bookID



--view 4
--number of books loaned in each category
create view numOfBooksEachCategory as
select category.name, count(loans.bookID) as numOfLoanedBook
from ((Book inner join loans
on Book.bookID = loans.bookID)
inner join category 
on category.categoryID=Book.categoryID)
group by category.name


--view 5 
--total late penalty of each user
create view totalPenalty as
select Member.userID,Member.name,sum(penalty*numDays) as Penalty
from 
(Book inner join loans 
on Book.bookID=loans.bookID)
inner join Member 
on loans.userID=Member.userID
group by Member.userID , Member.name