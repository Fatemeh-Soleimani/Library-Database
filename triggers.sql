----------------
--1
create trigger invalidBook 
on Book after update
as
begin
	
	with updated (bookid) as
	(select bookid from inserted
	intersect
	select bookid from deleted)

	select * from inserted 
	where bookID in (select bookid from updated)
	
end

--drop trigger invalidBook 

-------------------------
--2
create trigger delete_add_a_book
on copies after update
as
begin


	with updated (bookid) as
	(select bookid from inserted 
	intersect
	select bookid from deleted)

	select * from inserted 
	where bookID in (select bookid from updated)

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

select * from inserted

end

--drop trigger insert_to_copies	

-------------------