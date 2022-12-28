
--procedure 1
--all books exists in specific category (using view 3)
--drop procedure if exists SP_booksInCategory;

create procedure SP_booksInCategory 
(@category as varchar(50))
AS
BEGIN 
	select bookName
	from booksInCategory
	where Category=@category
	
END

EXEC SP_booksInCategory 'Science Fiction'


--------------------------------------------------------------
--procedure 2 
--all books loaned by specific user
--drop procedure if exists bookLoaned;

create procedure bookLoaned 
(@userID varchar(5))
AS
BEGIN
	select title
	from bookLoanedToUser
	where userID=@userID

END

EXEC bookLoaned '4'
--------------------------------------------------------------
--procedure 3
--get favorite books of specific person 
--drop procedure if exists favoriteBook;

create procedure favoriteBook 
(@userID varchar(5))
AS
BEGIN
	select Book.title
	from (Book inner join category 
	on Book.categoryID=category.categoryID)
	inner join Member 
	on Member.categoryID=category.categoryID
	where Book.valid=1 and Member.userID=@userID and Member.categoryID=Book.categoryID
END


EXEC favoriteBook '4'
--------------------------------------------------------------
--procedure 4
--books of specific publisher
--drop procedure if exists publishersBook;
 create procedure publishersBook
(@publisher varchar(20))
AS
BEGIN

	select Book.title
	from (Book inner join copies 
	on Book.bookID=copies.bookID)
	inner join publisher
	on Book.publisherName=publisher.publisherName
	where Book.valid=1 and publisher.publisherName=@publisher 

END

EXEC publishersBook 'singer'
--------------------------------------------------------------
--procedure 5 
--add new user to database of library
--drop procedure if exists addUser;

create procedure addUser 
@userID varchar(5),
@name varchar(20),
@categoryID varchar(5),
@registrationDate varchar(10),
@gender varchar(8),
@dateOfBirth varchar(10)
AS
BEGIN
	insert into Member(userID,name,categoryID,isActive,registrationDate,gender,dateOfBirth)
	values(@userID,@name,@categoryID,1,@registrationDate,@gender,@dateOfBirth)
END

EXEC addUser @userID='1023',
@name='Nancy Brown',
@categoryID='2',
@registrationDate='01/06/2015',
@gender='female',
@dateOfBirth='02/05/2002'

--select * from Member where userID='1023'

-----------------------------------------------
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
		begin
			insert into book values (@bookID, @title, @gradeID, @categoryID, @penalty, @publisherName,1)
			insert into copies values(@bookID,1);
		end
		ELSE
			RAISERROR('NULL Value is passed',15,1)
	
	END TRY
	BEGIN CATCH
		PRINT('A Null Value is passed')
	END CATCH

end

exec add_book 
@bookID='41',
@title ='hii',
@gradeID='3',
@categoryID='5',
@penalty=2,
@publisherName='Loyly'


--drop procedure add_book

---------

create procedure add_existing_book
(@bookID varchar(5))
as
begin
	
	declare @remain int;

	update copies set numOfCopies=numOfCopies+1
	where bookID=@bookID

	set @remain=(select numOfCopies 
					from copies
					where bookID=@bookID);

	if @remain=1
	begin
		update book set valid=1
		where bookID=@bookID
	end

end

exec add_existing_book @bookID='5';

--drop procedure add_existing_book

----------------------------
--7
--no input
create procedure num_loan_books
as
begin
		
	select Book.bookID, title, count(*) as num_of_loans
	from book inner join loans
	on Book.bookID=loans.bookID
	group by Book.bookID, title
	order by num_of_loans desc

end

exec num_loan_books

--drop procedure num_loan_books

------------------------------------------
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

exec num_loan_a_book @bookID='2';

--drop procedure num_loan_a_book

-----------------------------------------------------
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
	else print('invalid')

end

exec take_book
@bookID='3',
@uID='5'

--select * from loans

--drop procedure take_book

------------------------------------------------
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
	set @ndays=DATEDIFF(DAY, @Dout, @returnD);

	update loans 
	set returnDate=cast(CAST( GETDATE() AS Date ) as varchar),
	isReturned=1,
	numDays=@ndays
	where bookID=@bookID and userID=@uID and isReturned=0 
		

end

exec return_book 
@bookID='3',
@uID='5'

--select * from loans


--drop procedure return_book

--------------------------------------------
--11
create procedure invalid_a_book
@bookID varchar(5)
as
begin
	
	update Book set valid=0
	where bookID=@bookID	
	
	update copies set numOfCopies=0
	where bookID=@bookID

end

exec invalid_a_book @bookID='2'

--drop procedure invalid_a_book

--------------------------------------------
--12
create procedure delete_a_book
@bookID varchar(5)
as
begin
	declare @remain int;

	update copies set numOfCopies=numOfCopies-1
	where bookID=@bookID
	
	set @remain=(select numOfCopies 
					from copies
					where bookID=@bookID);

	if @remain=0
	begin
		update book set valid=0
		where bookID=@bookID
	end

end

exec delete_a_book @bookID='5'

--drop procedure delete_a_book

---------------------------------------
--13
create procedure compute_numDays
as
begin

	update loans 
	set numDays=DATEDIFF(DAY, dateOut, returnDate)
	where numDays is null and isReturned=1		

end

exec compute_numDays;

--select * from loans

--drop procedure compute_numDays