create table publisher(
	publisherName varchar(20) primary key,
	address varchar(150),
	
);

create table publisher_phone(
	publisherName varchar(20),
	phone varchar(20),
	primary key(publisherName,phone),
	foreign key(publisherName) references publisher(publisherName)

);


 create table category(
	categoryID varchar(5) primary key,
	name varchar(50),
	

 );

 create table Member(
	userID varchar(5) primary key,
	firstname varchar(20) not null,
	lastname varchar(20) not null,
	categoryID varchar(5),
	isActive int check (isActive in(0,1)),
	registrationDate varchar(10),
	gender varchar(8) check (gender in ('female','male')),
	dateOfBirth varchar(10),
	foreign key (categoryID) references category(categoryID),
	
 );

  create table grade(
	gradeID varchar(5) check (gradeID in ('1','2','3')),
	name varchar(20),
	primary key (gradeID),
 );

 create table Authors(
	AuthorID varchar(5) primary key,
	firstName varchar(40) not null,
	lastName varchar(40) not null,
	nationality varchar(20),
);

 create table Book(
	bookID varchar(5),
	title varchar(30) not null,
	gradeID varchar(5),
	categoryID varchar(5),
	penalty float,
	publisherName varchar(20),
	AuthorID varchar(5),
	valid int check (valid in(0,1)),
	primary key (bookID),
	foreign key (publisherName) references publisher(publisherName),
	foreign key (categoryID) references category(categoryID),
	foreign key (gradeID) references grade(gradeID),
	foreign key (AuthorID) references Authors(AuthorID)

);


create table copies(
	bookID varchar(5) not null,
	numOfCopies int,
	primary key(bookID),

	foreign key (bookID) references Book(bookID),
);

create table loans(
	bookID varchar(5) not null,
	userID varchar(5) not null,
	returnDate date,
	dateOut date,
	isReturned int check (isReturned in(0,1)),
	numDays int,
	primary key(bookID,userID,dateOut),
	foreign key (bookID) references Book(bookID),
	foreign key (userID) references Member(userID),
 );

 drop table loans
 drop table Member
 drop table copies
 drop table Book
 drop table Authors
 drop table grade
 drop table category
 drop table publisher

--for drop all tables
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

DECLARE @sql NVARCHAR(max)=''

SELECT @sql += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql
