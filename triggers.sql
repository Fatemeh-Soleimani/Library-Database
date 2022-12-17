--trigger 3
--show deleted book
drop trigger deletebook;

alter trigger deleteBook
on Book
after delete
as
begin
select *  from deleted
end

--insert into grade values ('1', 'kids')  
--select * from grade
--delete from grade where gradeID='1'
--trigger 2
--delete book from copies when deleted from book

create trigger change_copies
on Book
after delete
as 
begin
	update copies
	set numOfCopies=case
						when numOfCopies <>0 and copies.bookID=deleted.bookID then numOfCopies-1 --why deleted cause error???
						else numOfCopies
						end;
	
end


--trigger 1
--change copies table when adding book
create trigger change_copies
on Book 
after insert 
as
begin 
	case
		when inserted.bookID exists in copies then  
		else
	end;
end
	



