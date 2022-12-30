
--procedure 1
--all books in specific category (using view 3)
--drop procedure if exists SP_booksInCategory;

create procedure SP_booksInCategory 
(@category as varchar(50))
AS
BEGIN 
	select book.bookid,book.title
	from book inner join (select * from category where name=@category) as c
	on book.categoryID=c.categoryID 
END

EXEC SP_booksInCategory 'Science Fiction'


--------------------------------------------------------------
--procedure 2 
--all books is loaned by specific user
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
	select Book.bookid,Book.title
	from Book inner join (select * from Member where userID=@userID) as m
	on m.categoryID=book.categoryID
	where Book.valid=1
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

	select Book.bookid,Book.title
	from book
	where Book.valid=1 and publisherName=@publisher 

END

EXEC publishersBook 'singer'
--------------------------------------------------------------
--procedure 5 
--add new user to database of library
--drop procedure if exists addUser;

create procedure addUser 
@userID varchar(5),
@fname varchar(20),
@lname varchar(20),
@categoryID varchar(5),
@registrationDate varchar(10),
@gender varchar(8),
@dateOfBirth varchar(10)
AS
BEGIN
	insert into Member(userID,firstname,lastname,categoryID,isActive,registrationDate,gender,dateOfBirth)
	values(@userID,@fname,@lname,@categoryID,1,@registrationDate,@gender,@dateOfBirth)
END

EXEC addUser @userID='1023',
@fname='Nancy',
@lname='Brown',
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
@authorID varchar(5),
@publisherName varchar(20))
as
begin

			
	BEGIN TRY
		IF @title IS NOT NULL
		begin
			insert into book values (@bookID, @title, @gradeID, @categoryID, @penalty, @publisherName,@authorID,1)
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
@authorID='1',
@publisherName='Loyly'


--drop procedure add_book

-----------------------------
--7

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
	
	--book num was 0 and after adding will be available and valid
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
--shows times that books are loaned
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
--shows times that a book is loaned
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
	declare @rDate date;

	set @remain= (select dbo.remaining_books(@bookID));
	set @valid = (select valid from Book where bookID=@bookID);

	set @rDate=cast (DATEADD(MONTH, 1,  GETDATE()) as date);

	if @remain>0 and @valid=1
	begin
		
		insert into loans (bookID,userID,returnDate,dateOut, isReturned,numDays) values 
		(@bookID, @uID, @rDate , CAST( GETDATE() AS Date ), 0,0) 

	end
	else print('there is no book of this kind to loan')

end

exec dbo.take_book
@bookID='9',
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
	declare @returnD date;
	declare @now date;
	declare @Dout date;

	set @now=CAST( GETDATE() AS Date);

	set @Dout=(select dateOut
					from loans
					where bookID=@bookID and userID=@uID and isReturned=0 );

	set @returnD=(select returnDate
					from loans
					where bookID=@bookID and userID=@uID and isReturned=0 );

	if @now>@returnD
		set @ndays=DATEDIFF(DAY, @returnD,  @now);
	else
		set @ndays=0;

	update loans 
	set returnDate=@now,
	isReturned=1,
	numDays=@ndays
	where bookID=@bookID and userID=@uID and isReturned=0 
		

end

exec return_book 
@bookID='9',
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
create procedure compute_numdays
as
begin
	
	declare @now date;

	set @now=CAST( GETDATE() AS Date);

	update loans 
	set numDays=case 
					when @now>returnDate then DATEDIFF(DAY, returnDate,  @now)
					else 0
				end
	where isReturned=0 
		

end

exec compute_numdays

--drop procedure compute_numdays
----------------------------------------------
--14
create procedure add_author
@AuthorID varchar(5),
@firstName varchar(40),
@lastName varchar(40),
@nationality varchar(20)
as
begin
	
	insert into authors values (@AuthorID, @firstName, @lastName, @nationality)

end

exec add_author
@AuthorID ='22',
@firstName ='jojo',
@lastName ='',
@nationality ='american';
--select * from authors
--drop procedure add_author
