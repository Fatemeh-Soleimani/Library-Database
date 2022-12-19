
----------------
--1
create trigger invalidBook 
on Book after update
as
begin
	
	with updated (bookid,valid) as
	(select bookid,valid from inserted
	intersect
	select bookid,valid from deleted)

	update copies set numOfCopies=0
	where bookID in (select bookid from updated where valid =0)
	

end

--drop trigger invalidBook 

-------------------------
--2
create trigger delete_add_a_book
on copies after update
as
begin


	with updated (bookid,num) as
	(select bookid,numOfCopies from inserted 
	intersect
	select bookid,numOfCopies from deleted)

	--delete -> num--
	update book set valid=0
	where bookID in (select bookid from updated where num=0);

	--add -> num++
	update book set valid=1
	where bookID in (select bookid from updated where num=1);

end

--drop trigger delete_add_a_book

-----------------------------------------
--3

--change(insert to) copies table when adding book

create trigger insert_to_copies
on Book 
after insert 
as
begin


declare	@id varchar(5);
select @id = (select bookID from inserted);

insert into copies values(@id,1);

end

--drop trigger insert_to_copies	

-------------------