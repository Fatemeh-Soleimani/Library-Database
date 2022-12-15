
--procedure 1
--all books exists in specific category (using view 3)
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
create procedure bookLoaned 
(@userID varchar(5))
AS
BEGIN
	select title
	from bookLoanedToUser
	where userID=@userID

END


--------------------------------------------------------------
--procedure 3
--get favorite books of specific person 
create procedure favoriteBook 
(@userID varchar(5))
AS
BEGIN
	select Book.title
	from (Book inner join category 
	on Book.bookID=category.categoryID)
	inner join Member 
	on Member.categoryID=category.categoryID
	where Member.userID=@userID
END

--------------------------------------------------------------
--procedure 4
--books of specific publisher
 create procedure publishersBook
(@publisher varchar(20))
AS
BEGIN

	select Book.title
	from (Book inner join copies 
	on Book.bookID=copies.bookID)
	inner join publisher
	on copies.publisherName=publisher.publisherName
	where publisher.publisherName=@publisher

END

--------------------------------------------------------------
--procedure 5 
--add new user to database of library

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