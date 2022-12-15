--function 1
--number of available books in specific category
create function BooksAvailable 
(@category varchar(50))
returns integer
BEGIN 
declare @bookCount integer;

	set @bookCount = (select count(book.bookID) 
	from availableBooks
	where category.name= @category
	)
	return @bookCount

END

--function 2
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

