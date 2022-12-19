--function 1
--number of available books in specific category
--DROP FUNCTION IF EXISTS BooksAvailable;

create function dbo.BooksAvailable 
(@category varchar(50))
returns integer
BEGIN 
declare @bookCount integer;

	set @bookCount = (select count(*) 
	from availableBooks
	where CATN= @category
	)
	return @bookCount

END

select CATN,dbo.BooksAvailable(CATN)
from availableBooks

---------------------------------------------------------------------------------

--function 2

--DROP FUNCTION IF EXISTS detailsOfUsers;

create function detailsOfUsers (@UserID varchar(5))
	returns table 
	as
	return(
	select userID,Member.name as fullName,category.name as favoriteCategory,isActive,registrationDate
	,gender,dateOfBirth
	from Member inner join category on Member.categoryID=category.categoryID
	where Member.userID=@UserID
	);

select * from detailsOfUsers('7')
select * from detailsOfUsers('10')

---------------------------------------------------------------------------------

--function 3
--show num of book and publisher of that
--DROP FUNCTION IF EXISTS numAndPublisher;
create function numAndPublisher (@BookID varchar(5))
	returns table
	as
	return(
	select publisher.publisherName,copies.numOfCopies
	from (Book inner join copies 
	on Book.bookID=copies.bookID) 
	inner join publisher 
	on Book.publisherName=publisher.publisherName
	where Book.valid=1 and Book.bookID=@BookID
	);

select * from numAndPublisher('8')

---------------------------------------------------------------------------------
--function 4 
--usefull for get id of book when inserting
--DROP FUNCTION IF EXISTS getIDAndDetailsOfBook;

create function getIDAndDetailsOfBook(@BookTitle varchar(30))
returns table 
as
return (
	select Book.bookID,Book.title,publisherName
	from Book 
	where Book.valid=1 and Book.title=@BookTitle
);
select * from getIDAndDetailsOfBook('Apples to Oranges')