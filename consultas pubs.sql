USE pubs;
GO

-- 1. INNER JOIN: Autores y sus libros
select A.au_fname + ' ' + A.au_lname as Autor, T.title
from authors A
INNER JOIN titleauthor TA on A.au_id = TA.au_id
INNER JOIN titles T on TA.title_id = T.title_id;

-- 2. INNER JOIN: Libros y sus editoriales
select T.title, P.pub_name
from titles T
INNER JOIN publishers P on T.pub_id = P.pub_id;

-- 3. INNER JOIN: Ventas detalladas
select S.ord_num, T.title, S.qty
from sales S
INNER JOIN titles T on S.title_id = T.title_id;

-- 4. INNER JOIN: Empleados y sus cargos
select E.fname, E.lname, J.job_desc
from employee E
inner join jobs J on E.job_id = J.job_id;

-- 5. INNER JOIN: Tiendas y sus ventas
select ST.stor_name, S.ord_num
from stores ST
inner join sales S on ST.stor_id = S.stor_id;

-- 6. INNER JOIN: Libros y regalías
select T.title, R.royalty
from titles T
inner join roysched R on T.title_id = R.title_id;

-- 7. INNER JOIN: Autores y ciudades coincidentes
select A.au_fname, A.city, P.pub_name
from authors A
inner join publishers P on A.city = P.city;

-- 8. INNER JOIN: Empleados y editoriales
select E.fname, P.pub_name
from employee E
inner join publishers P on E.pub_id = P.pub_id;

-- 9. LEFT JOIN: Títulos sin ventas 
select T.title, S.qty
from titles T
left join sales S on T.title_id = S.title_id
where S.qty is null;

-- 10. RIGHT JOIN: Editoriales sin empleados 
select E.fname, P.pub_name
from employee E
right join publishers P on E.pub_id = P.pub_id
where E.fname is null;