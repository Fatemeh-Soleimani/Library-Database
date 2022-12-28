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

------------------------------------------
--4

create function num_of_a_book(@id varchar(5))
returns int
as
begin

declare @out int;
declare @valid int;

set @valid = (select valid from Book where bookID=@id);

set @out = case @valid 
				when 1 then(select sum(numOfCopies)
				from copies
				where bookID=@id)
				else 0
			end

return @out
end
--drop function num_of_a_book

--------------------------------------
--5

create function numOf_books_of_a_grade(@Gid varchar(5))
returns int
as
begin

declare @out int;

set @out = (select COUNT(*)
				from Book
				where gradeID=@Gid and valid=1)

return @out
end

--drop function numOf_books_of_a_grade

--or
--???? it dos not need input
create function numOf_books_of_grades()
returns table
as
--begin

return 
	(select grade.name,COUNT(*) as num
			from Book inner join grade
			on Book.gradeID=grade.gradeID
			where valid=1
			group by grade.name);

--end

--drop function numOf_books_of_grades

----------------------------------------
--6

create function grade_publisher(@Gid varchar(5))
returns table
as

--begin

return 
	(select publisherName, count(*) as sum
			from Book
			where gradeID=@Gid and valid=1
			group by publisherName);

--end

--drop function grade_publisher

-------------------------------------------
--7
create function compute_penalty(@Bid varchar(5), @uid varchar(5) , @Rdate varchar(10))
returns int
as
begin

declare @out int;

set @out = (select numDays*penalty 
				from (select * from Book where bookID=@Bid) as b inner join (select * from loans where bookID=@Bid and userID=@uid and @Rdate=returnDate) as l
				on b.bookID=l.bookID)

return @out
end

--drop function compute_penalty
-------------------------

--remaining books
create function remaining_books(@bookid varchar(5))
returns int
as
begin

declare @out int;
declare @taken int;
declare @valid int;

set @valid = (select valid from Book where bookID=@bookid);

set @taken=(select count(*)
				from loans
				where bookID=@bookid and isReturned='0')

set @out=case @valid
			when 1 then (select numOfCopies-@taken
			from copies
			where bookID=@bookid)
			else 0
		end

return @out;

end

--drop function remaining_books