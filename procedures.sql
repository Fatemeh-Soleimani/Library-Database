--defaulf values
--???????????? publisher,copies
--6
create procedure add_book
(@bookID varchar(5),
@title varchar(30),
@gradeID varchar(5),
@categoryID varchar(5),
@penalty float)
as
begin

			
	BEGIN TRY
		IF @title IS NOT NULL
			insert into book values (@bookID, @title, @gradeID, @categoryID, @penalty)
		ELSE
			RAISERROR('NULL Value is passed',15,1)
	
	END TRY
	BEGIN CATCH
		PRINT('A Null Value is passed')
	END CATCH

end

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

---------------------------------
--8
create procedure num_loan_a_book
@bookID varchar(5)
as
begin
		
	select b.bookID, title, count(*) as count
	from (select * from book where Book.bookID=@bookID) as b inner join loans
	on b.bookID=loans.bookID
	group by b.bookID, title

end

------------------------------
--9 ????

create procedure take_book
@bookID varchar(5),
@publisherName varchar(20),
@uID varchar(5)
as
begin
	

	declare @remain int;
	--set @remain= function
	if @remain>0
	begin
		
		insert into loans (bookID,userID,dateOut, isReturned) values (@bookID, @uID, cast(CAST( GETDATE() AS Date ) as varchar), 0) 

	end

end

---------------------------
--10
create procedure return_book
@bookID varchar(5),
@publisherName varchar(20),
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

