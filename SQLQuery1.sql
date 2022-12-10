create table Book(
	bookID varchar(5),
	title varchar(30) not null,
	publisherName varchar(20) not null,
	branchName varchar(5),
	gradeID varchar(10),
	categoryID varchar(20),
	penalty float,
	primary key (bookID),
	foreign key (publisherName) references publisher,
	foreign key (bookID) references loans,
	foreign key (bookID) references Authors,
	foreign key (bookID) references copies,
	foreign key (categoryID) references ctegory,

);

create table Authors(
	bookID varchar(5) not null,
	Name varchar(40) not null,
	nationality varchar(20),


);

create table publisher(
	publisherName varchar(20) not null,
	address varchar(150),
	phone varchar(20),
	--grade varchar(10),
	--id

);

create table copies(
	bookID varchar(5) not null,
	numOfCopies int,
);

 create table category(
	categoryID varchar(20) primary key,
	name varchar(50),
	description varchar(200),

 );

 create table loans(
	bookID varchar(5) not null,
	userID varchar(10) not null,
	returnDate char(10),
	dateOut char(10),
	isReturned int check (isReturned in(0,1)),
	numDays int,
 );

 create table Member(
	userID varchar(10) primary key,
	name varchar(10) not null,
	categoryID varchar(20),
	isActive int check (isActive in(0,1)),
	registrationDate varchar(10),
	gender varchar(8) check (gender in ('female','male')),
	dateOfBirth varchar(10),
	foreign key (categoryID), references category,
	foreign key (userID) references loans,
 )