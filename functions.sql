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

----------------------------------------
--6

create function grade_publisher(@Gid varchar(5))
returns table
as

--begin

return 
	(select publisherName, SUM(numOfCopies) as sum
			from copies inner join Book
			on copies.bookID=Book.bookID
			where gradeID=@Gid
			group by publisherName);

--end

-------------------------------------------
--7
create function compute_penalty(@Bid varchar(5), @uid varchar(5))
returns int
as
begin

declare @out int;

set @out = (select numDays*penalty 
				from (select * from Book where bookID=@Bid) as b inner join (select * from loans where bookID=@Bid and userID=@uid) as l
				on b.bookID=l.bookID)

return @out
end
