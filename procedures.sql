--defaulf values
--???????????? publisher,copies
--6
create procedure add_book
(@bookID varchar(5),
@title varchar(30),
@gradeID varchar(5),
@categoryID varchar(5),
@penalty float,
@publisherName varchar(20))
as
begin

			
	BEGIN TRY
		IF @title IS NOT NULL
			insert into book values (@bookID, @title, @gradeID, @categoryID, @penalty, @publisherName,1)
		ELSE
			RAISERROR('NULL Value is passed',15,1)
	
	END TRY
	BEGIN CATCH
		PRINT('A Null Value is passed')
	END CATCH

end

--drop procedure add_book
--

create procedure add_existing_book
(@bookID varchar(5))
as
begin
	
	update copies set numOfCopies=
	numOfCopies+1
	where bookID=@bookID

end

--drop procedure add_existing_book
----------------------------
--7
--no input
create procedure num_loan_books
as
begin
		
	select Book.bookID, title, count(*) as count
	from book inner join loans
	on Book.bookID=loans.bookID
	group by Book.bookID, title
	order by count desc

end

--drop procedure num_loan_books
---------------------------------
--8
create procedure num_loan_a_book
@bookID varchar(5)
as
begin
		
	select b.bookID, title, count(*) as count
	from (select * from book where Book.bookID=@bookID) as b inner join (select * from loans where @bookID=loans.bookID) as l
	on b.bookID=l.bookID
	group by b.bookID, title

end

--drop procedure num_loan_a_book


----------------
--9

create procedure take_book
@bookID varchar(5),
@uID varchar(5)
as
begin
	

	declare @remain int;
	declare @valid int;

	set @remain= (select dbo.remaining_books(@bookID));
	set @valid = (select valid from Book where bookID=@bookID);

	if @remain>0 and @valid=1
	begin
		
		insert into loans (bookID,userID,dateOut, isReturned) values (@bookID, @uID, cast(CAST( GETDATE() AS Date ) as varchar), 0) 

	end

end

--drop procedure take_book
---------------------------
--10
create procedure return_book
@bookID varchar(5),
@uID varchar(5)
as
begin
	
	declare @ndays int;
	declare @returnD varchar(10);
	declare @Dout varchar(10);

	set @returnD=cast(CAST( GETDATE() AS Date ) as varchar);

	set @Dout=(select dateOut
					from loans
					where bookID=@bookID and userID=@uID and isReturned=0 );

	--???????????
	set @ndays=DATEDIFF(DAY, @returnD, @Dout);

	update loans 
	set returnDate=cast(CAST( GETDATE() AS Date ) as varchar),
	isReturned=1,
	numDays=@ndays
	where bookID=@bookID and userID=@uID and isReturned=0 
		

end

--drop procedure return_book


--------------------
--11
create procedure invalid_a_book
@bookID varchar(5)
as
begin
	
	update Book set valid=0
	where bookID=@bookID		

end

--drop procedure invalid_a_book
------------------------
--12
create procedure delete_a_book
@bookID varchar(5)
as
begin
	
	update copies set numOfCopies=numOfCopies-1
	where bookID=@bookID		

end

--drop procedure delete_a_book