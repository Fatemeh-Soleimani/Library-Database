--function 1
--number of available books in specific category
DROP FUNCTION IF EXISTS BooksAvailable;

create function BooksAvailable 
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

--function 2

DROP FUNCTION IF EXISTS detailsOfUsers;

create function detailsOfUsers (@UserID varchar(5))
	returns table 
	as
	return(
	select userID,name,categoryID,isActive,registrationDate
	,gender,dateOfBirth
	from Member 
	where Member.userID=@UserID
	);

--function 3
DROP FUNCTION IF EXISTS numAndPublisher;
create function numAndPublisher (@BookID varchar(5))
	returns table
	as
	return(
	select publisher.publisherName,copies.numOfCopies
	from (Book inner join copies 
	on Book.bookID=copies.bookID) 
	inner join publisher 
	on Book.publisherName=publisher.publisherName
	where Book.bookID=@BookID
	);

