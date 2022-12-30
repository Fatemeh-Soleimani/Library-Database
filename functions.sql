
--1

--DROP FUNCTION IF EXISTS detailsOfUsers;

create function detailsOfUser (@UserID varchar(5))
	returns table 
	as
	return(
	select userID,Member.firstname+' '+Member.lastname as Name,category.name as favoriteCategory,isActive,registrationDate
	,gender,dateOfBirth
	from Member inner join category on Member.categoryID=category.categoryID
	where Member.userID=@UserID
	);

select * from detailsOfUser('7')
select * from detailsOfUser('10')

---------------------------------------------------------------------------------
--2
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


--------------------------------------
--3

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

select dbo.numOf_books_of_a_grade(3) as books_in_grade

--drop function numOf_books_of_a_grade

--or

create function numOf_books_of_grades()
returns table
as
return 
	(select grade.name,COUNT(*) as num
			from Book inner join grade
			on Book.gradeID=grade.gradeID
			where valid=1
			group by grade.name);


--drop function numOf_books_of_grades

select * from dbo.numOf_books_of_grades()

-------------------------------------------
--4
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

select dbo.compute_penalty(1, 4 , '2016-09-19') as penalty

--drop function compute_penalty

-------------------------
--5
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

select dbo.remaining_books(1) as remainig

--drop function remaining_books