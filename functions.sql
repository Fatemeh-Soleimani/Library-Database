------------------------------------------
--4

create function num_of_a_book(@id varchar(5))
returns int
as
begin

declare @out int;

set @out = (select sum(numOfCopies)
				from copies
				where bookID=@id)

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
				where gradeID=@Gid)

return @out
end

--drop function numOf_books_of_a_grade

--or
--???? it dos not need input
create function numOf_books_of_grades(@Gid varchar(5))
returns table
as
--begin

return 
	(select grade.name,COUNT(*) as num
			from Book inner join grade
			on Book.gradeID=grade.gradeID
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
			where gradeID=@Gid
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

set @taken=(select count(*)
				from loans
				where bookID=@bookid and isReturned='0')

set @out=(select numOfCopies-@taken
			from copies
			where bookID=@bookid)

return @out;

end

--drop function remaining_books
