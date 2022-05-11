-- (1) Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd
SELECT model, speed, hd from PC where price < 500

-- (2) Найдите производителей принтеров. Вывести: maker
SELECT DISTINCT maker from Product where type = 'Printer'

-- (3) Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.
SELECT model, ram, screen 
FROM Laptop 
WHERE price > 1000

-- (4) Найдите все записи таблицы Printer для цветных принтеров.
SELECT * 
FROM Printer
WHERE color = 'y'

-- (5) Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.
SELECT model, speed, hd
FROM PC
WHERE (CD = '12x' or CD = '24x') AND price < 600

-- (6) Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.
select distinct
pr.maker as maker,
lp.speed
from Laptop lp
join Product pr
on pr.model = lp.model
where lp.hd >= 10

-- (7) Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).
select pr.model, PC.price
from Product pr
join PC 
on PC.model = pr.model
where pr.maker = 'B'
UNION
select
pr.model,
lp.price
from Product pr
join Laptop lp 
on lp.model = pr.model
where pr.maker = 'B'
UNION
select
pr.model,
Printer.price
from Product pr
join Printer
on Printer.model = pr.model
where pr.maker = 'B'

-- (8) Найдите производителя, выпускающего ПК, но не ПК-блокноты.
SELECT maker
from Product
where type = 'PC'
except
select maker
from Product
where type = 'Laptop'

-- (9) Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker
select distinct maker
from Product pr
join PC
on pr.model = PC.model
where speed >= 450

-- (10) Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price
select model,
price
from Printer pr
where price = (select MAX(price) from Printer)

-- (11) Найдите среднюю скорость ПК.
select ((select SUM(speed) from PC) / (select COUNT(speed) from PC))

-- (12) Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.
select AVG (speed) 
from Laptop
where price > 1000

-- (13) Найдите среднюю скорость ПК, выпущенных производителем A.
select AVG(speed)
from Product pr
join PC
on PC.model = pr.model
where maker = 'A'

-- (14) Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий.
select distinct cl.class,
sh.name,
cl.country
from Ships sh
join Classes cl
on sh.class = cl.class
where cl.numGuns >= 10

-- (15) Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD
select hd
from PC
group by hd
having count(HD) >= 2

-- (16) Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.
select distinct pc1.model, pc2.model, pc1.speed, pc1.ram
from pc pc1, pc pc2
where pc1.speed = pc2.speed and pc1.ram = pc2.ram and pc1.model > pc2.model

-- (17) Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
-- Вывести: type, model, speed
select distinct 'Laptop', lp.model, lp.speed
from Laptop lp
where lp.speed < all (select PC.speed from PC)

-- (18) Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price
select distinct maker, price
from Printer as pr
join Product as p
on pr.model = p.model
where price = (select min(price) from Printer where color = 'y') and pr.color = 'y'

-- (19) Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов.
-- Вывести: maker, средний размер экрана.
Select maker,
avg(screen)
from Product
join Laptop
on Laptop.model = Product.model
group by maker

-- (20) Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.
select distinct
maker,
count(model) as count_model
from Product
where type = 'PC'
group by maker
having count(model) >= 3

-- (21) Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC.
-- Вывести: maker, максимальная цена.
Select maker,
max(price)
from Product p
join PC pc
on p.model = pc.model
group by maker

-- (22) Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.
Select speed, avg(price)
from PC
where speed > 600
group by speed

-- (23) Найдите производителей, которые производили бы как ПК
-- со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
-- Вывести: Maker
Select maker
from Product p
join PC
on PC.model = p.model
where speed >= 750
intersect
select maker
from Product p
join Laptop lp
on p.model = lp.model
where speed >= 750

-- (24) Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.
Select model
from  
( select model, price
from PC
union
select model, price
from Laptop
union
select model, price
from Printer ) t1
where price in (select max (price) from 
( select price
from PC
union
select price
from Laptop
union
select price
from Printer )t2)

-- (25) Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker
with tmp_table (min_ram)
as
( select min(ram) from Laptop ),
speed_table (max_speed)
as
( select max(speed) from pc
	where ram = (
		select min(ram)
		from pc
	)
),
maker_printer (mak_print)
as
(
	select distinct maker from product
	where type = 'printer'
)

select distinct maker
from Product
where model in 
(
select model
from PC
where ram in (select distinct * from tmp_table)
and speed in (select distinct * from speed_table)
)
and maker in (select distinct * from maker_printer)

-- (26) Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
select avg(price) as AVG_price
from (select price 
from PC join Product p on p.model = pc.model where maker = 'A'
union all
select price
from Laptop lp join Product p on p.model = lp.model where maker = 'A') t

-- (27) Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
Select product.maker, avg(PC.hd)
from Product, PC
where product.model = pc.model and product.maker in (select distinct maker from Product where product.type = 'Printer')
group by maker

-- (28) Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
Select count(maker)
from Product
where maker in 
(
 select maker
 from Product
 group by maker
 having count(model) = 1
)

-- (29) В предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], 
-- написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
select i.point, i.date, inc, out
from income_o i left join outcome_o o on i.point = o.point and i.date = o.date
union
select o.point, o.date, inc, out
from outcome_o o left join income_o i on o.point = i.point and o.date = i.date

-- (30) В предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
-- Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).
select t1.point, t1.date, sum (out_s), sum (inc_s)
from 
(
select point, date, sum(out) as out_s, null as inc_s
from Outcome
group by point, date
union
select point, date, null as out_s, sum (inc) as inc_s
from Income
group by point, date
) as t1
group by t1.point, t1.date
order by t1.point

-- (31) Для классов кораблей, калибр орудий которых не менее 16 дюймов, укажите класс и страну.
Select class, country
from Classes 
where bore >= 16

-- (32) Одной из характеристик корабля является половина куба калибра его главных орудий (mw). 
-- С точностью до 2 десятичных знаков определите среднее значение mw для кораблей каждой страны, у которой есть корабли в базе данных.

select country, cast(avg(0.5 * bore * bore * bore) as numeric(6, 2))
from 
(
	select country, name, bore from classes cl join ships sh on sh.class = cl.class
	union
	select country, ship as name, bore from classes cl join outcomes o on o.ship = cl.class
) as tmp
group by country

-- (33) Укажите корабли, потопленные в сражениях в Северной Атлантике (North Atlantic). Вывод: ship.
select ship
from outcomes
where battle = 'North Atlantic' and result = 'sunk'

-- (34) По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. 
--Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
select s.name
from ships s
join classes cl on s.class = cl.class
where displacement > 35000 and launched >= 1922 and type = 'bb'

-- (35) В таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
-- Вывод: номер модели, тип модели.
select model, type
from product
where model not like '%[^0-9]%' or
upper(model) not like '%[^A-Z]%'

-- (36) Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
select out.ship
from outcomes out
join classes cl on cl.class = out.ship
union
select sh.name
from classes cl
join ships sh on sh.name = cl.class

-- (37) Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
select class  
from(select name,class from ships  
union  
select class as name,class  from classes,outcomes  where classes.class=outcomes.ship) A   
group by class  having count(A.name)=1

-- (38) Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
select country
from classes
where type = 'bb'
intersect
select country
from classes
where type = 'bc'

-- (39) Найдите корабли, `сохранившиеся для будущих сражений`; 
-- т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.

select distinct o.ship
from outcomes o, Battles b
where o.battle = b.name 
and o.ship in 
(
	select o1.ship
	from outcomes o1, battles b1
	where o1.battle = b1.name and b.date > b1.date and result = 'damaged'
)

-- (40) Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
-- Вывести: maker, type
select maker, max(type)
from product
group by maker
having count(distinct type) = 1 and count(model) > 1

-- (41) Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
-- определить максимальную цену на его продукцию.
-- Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
-- иначе максимальную цену.
select maker, case when count(price) = count(*) then max(price) end
from 
(
select prod.maker, prod.model, code, price
from product prod
join laptop lp on prod.model = lp.model
union 
select prod.maker, prod.model, code, price 
from product prod
join pc on prod.model = pc.model
union
select prod.maker, prod.model, code, price 
from product prod
join printer p on prod.model = p.model
) as tmp
group by maker

-- (42) Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.
select ship, battle 
from Outcomes
where result = 'sunk'

-- (43) Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
select name 
from Battles
where DATEPART(year, date) not in (
select launched
from ships
where launched is not null
)

-- (44) Найдите названия всех кораблей в базе данных, начинающихся с буквы R.
select ship
from Outcomes
where ship LIKE 'R%'
union
select name
from Ships
where name LIKE 'R%'

-- (45) Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
-- Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.
select name
from ships
where name like '% % %'
union
select ship
from Outcomes
where ship like '% % %'

-- (46) Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.
SELECT o.ship, displacement, numGuns FROM
(SELECT name AS ship, displacement, numGuns
FROM Ships s JOIN Classes c ON c.class=s.class
UNION
SELECT class AS ship, displacement, numGuns
FROM Classes c) AS a
RIGHT JOIN Outcomes o
ON o.ship=a.ship
WHERE battle = 'Guadalcanal'

-- (47) Определить страны, которые потеряли в сражениях все свои корабли

with names as
(
	select c.country, s.name from classes c join ships s on c.class=s.class
	union
	select c.country, o.ship from outcomes o join classes c on c.class=o.ship
),
sunkships as 
(
	select country, count(*) as num_sunk
	from names
	left join Outcomes o on o.ship = names.name
	where result = 'sunk'
	group by country
),
total_num as 
(
	select country, count(*) as t_num
	from names
	group by country
)

select shs.country
from sunkships shs 
join total_num tn on tn.country = shs.country
where tn.t_num = shs.num_sunk


-- (48) Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.
select class
from Ships sh
join Outcomes o on o.ship = sh.name
where result = 'sunk'
union
select class
from Outcomes o
join Classes cl on cl.class = o.ship
where result = 'sunk'

-- (49) Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).
select sh.name
from Ships sh
join Classes cl on sh.class = cl.class
where cl.bore = 16 
union 
select ship
from Outcomes o
join Classes cl on cl.class = o.ship
where bore = 16

-- (50) Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
select distinct battle
from 
 (
 select o.battle, sh.name, sh.class
 from Ships sh
 join Outcomes o on o.ship = sh.name
 ) as tmp
 join Battles b on b.name = tmp.battle
 join Classes cl on cl.class = tmp.class
 where cl.class = 'Kongo'

 -- (51) Найдите названия кораблей, имеющих наибольшее число орудий среди всех имеющихся кораблей 
 -- такого же водоизмещения (учесть корабли из таблицы Outcomes).
select name
from (
select name, numGuns, displacement
from Ships sh
join Classes cl on cl.class = sh.class
union 
select ship as name, numGuns, displacement
from Outcomes o
join Classes cl on o.ship = cl.class
) tmp
where numGuns >= ALL (select numGuns from Classes where displacement = tmp.displacement)

-- (52) Определить названия всех кораблей из таблицы Ships, которые могут быть линейным японским кораблем,
-- имеющим число главных орудий не менее девяти, калибр орудий менее 19 дюймов и водоизмещение не более 65 тыс.тонн

select sh.name from Classes cl
join Ships sh on sh.class = cl.class
where (numGuns >= 9 or numGuns is NULL)
and (bore < 19 or bore is NULL)
and (displacement <= 65000 or displacement is NULL)
and country = 'Japan'
and type = 'bb'

-- (53) Определите среднее число орудий для классов линейных кораблей.
-- Получить результат с точностью до 2-х десятичных знаков.

select cast(avg(numGuns * 1.0) as numeric(6,2)) as avg_numGuns
from Classes cl
where type = 'bb'

-- (54) С точностью до 2-х десятичных знаков определите среднее число орудий всех линейных кораблей (учесть корабли из таблицы Outcomes).

with all_ships as
(
	select name, class from ships
    union
    select ship, ship from outcomes
)

select cast(avg(numGuns * 1.0) as numeric(6, 2)) as avg_numguns 
from all_ships
join Classes cl on cl.class = all_ships.class
where type = 'bb'

-- (55) Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. 
-- Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select cl.class, min(launched) 
from Classes cl
full join Ships sh on cl.class =  sh.class
group by cl.class


