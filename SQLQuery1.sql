create table publisher(
	publisherName varchar(20) primary key,
	address varchar(150),
	phone varchar(20),
	
);

 create table category(
	categoryID varchar(5) primary key,
	name varchar(50),
	

 );
 create table Member(
	userID varchar(5) primary key,
	name varchar(20) not null,
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

 create table Book(
	bookID varchar(5),
	title varchar(30) not null,
	gradeID varchar(5),
	categoryID varchar(5),
	penalty float,

	primary key (bookID),
	
	foreign key (categoryID) references category(categoryID),
	foreign key (gradeID) references grade(gradeID),
);

create table copies(
	bookID varchar(5) not null,
	numOfCopies int,
	publisherName varchar(20) not null,
	foreign key (bookID) references Book(bookID),
	foreign key (publisherName) references publisher(publisherName),
);

create table Authors(
	bookID varchar(5) not null,
	Name varchar(40) not null,
	nationality varchar(20),
	foreign key (bookID) references Book(bookID),

);
create table loans(
	bookID varchar(5) not null,
	userID varchar(5) not null,
	returnDate char(10),
	dateOut char(10),
	isReturned int check (isReturned in(0,1)),
	numDays int,
	foreign key (bookID) references Book(bookID),
	foreign key (userID) references Member(userID),
 );

--for drop all tables
EXEC sp_msforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"

DECLARE @sql NVARCHAR(max)=''

SELECT @sql += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql