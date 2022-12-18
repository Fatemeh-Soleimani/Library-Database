--trigger 3
--show deleted book
drop trigger deletedbook;

create trigger deletedBook 
on Book after delete
as
begin
select *  from deleted
end

--insert into book values ('50', 'Alchemist', '3', '1', '2', 'Dada')

delete from book where bookID='50'
 
--cant delete because of foreign keys

--trigger 2
--delete book from copies when deleted from book

create trigger change_copies
on Book
after delete
as 
declare 
	@id varchar(5),
	@num int;

select @id = d.bookID from deleted d;
select @num = copies.numOfCopies from deleted d inner join copies on d.bookID=copies.bookID;
begin
	update copies
	set numOfCopies=case
						when @num <>0 and copies.bookID=@id then numOfCopies-1 --why deleted cause error???
						else numOfCopies
						end;

	delete from copies where copies.numOfCopies=0
	
end

--insert into book values ('50', 'Alchemist', '3', '1', '2', 'Dada')

--delete from book where bookID='50'

--trigger 1
--change copies table when adding book
drop trigger change_copies;
create trigger change_copies
on Book 
after insert 
as
begin
declare 
	@id varchar(5),
	@num int;
select @id = i.bookID from inserted i;

 
--case
	if @id exists in copies 
	begin
	update copies set copies.numOfCopies=numOfCopies+1 where copies.bookID=@id 
	end
	else 
	insert into copies(bookID,numOfCopies) values(@id,1)
	end;
	
end
	



