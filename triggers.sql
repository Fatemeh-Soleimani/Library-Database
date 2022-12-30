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

--invalid--
exec invalid_a_book @bookID='1'
--or
--do it till num of it be 0
exec delete_a_book @bookID='5'
-----------

--validation -> if book is invalid ,just add a coy to it ---
exec add_existing_book @bookID='1';
---------------

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

exec add_existing_book @bookID='5';
--or
exec delete_a_book @bookID='6'
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


exec add_book 
@bookID='45',
@title ='hello',
@gradeID='3',
@categoryID='5',
@penalty=2,
@authorID='1',
@publisherName='Loyly'

--drop trigger insert_to_copies	

-------------------