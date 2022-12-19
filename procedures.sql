
--procedure 1
--all books exists in specific category (using view 3)
drop procedure if exists SP_booksInCategory;

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
drop procedure if exists bookLoaned;

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
drop procedure if exists favoriteBook;

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
drop procedure if exists publishersBook;
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
drop procedure if exists addUser;

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

--------------------------------------------------------------
EXEC addUser @userID='1023',
@name='Nancy Brown',
@categoryID='2',
@registrationDate='01/06/2015',
@gender='female',
@dateOfBirth='02/05/2002'

--select * from Member where userID='1023'