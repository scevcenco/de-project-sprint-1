# Витрина RFM

## 1.1. Выясните требования к целевой витрине.

{См. задание на платформе}
-----------

{Исходные таблицы находятся в схеме production, итоговая витрина должна располагаться в схеме analysis и называться dm_rfm_segments.

В витрине 4 поля:
1) user_id - от 0 до 999, всего 1000 пользователей. int4, not null
2) recency - число от 1 до 5, сколько времени прошло с момента последнего заказа. int
3) frequency - число от 1 до 5, количество заказов. int
4) monetary_value - число от 1 до 5,  сумма затрат клиента. int
   
   Ппоказатели 2, 3 и 4 рассчитываются: 1 - минимум, 5 - максимум. Должно быть равное количество юзеров в когорте, т.е. так как их 1000, по 200 в каждом сегменте от 1 до 5.

   Учитываются закрытые заказы, т.к. Closed.
   Не нужно обновление.
}



## 1.2. Изучите структуру исходных данных.

{См. задание на платформе}

-----------

{1) user_id есть в таблице users и в таблице orders. Для проверки качества данных будем использовать join users с orders.

 2) Для рассчета recency - нужны даты заказов со статусом closed на юзера. Нужно отсортировать их.
   status_id будет=4, так как интересуют заказы closed (из orderstatuses).
   т.е. используем из таблицы order:
   -order_ts, status, user_id

3) Для рассчета frequency надо посчитать количество заказов на каждого клиента (group by), для этого user_id и order_id из таблицы orders.
   Далее Ntile по минимум 1, макс 5

4) Для рассчета monetary_value понадобится посчитать сумму потраченных каждым клиентом денег - колонка payment, группировка по user_id, далее как с frequency.

}


## 1.3. Проанализируйте качество данных

{См. задание на платформе}
-----------

{## Оцените, насколько качественные данные хранятся в источнике.
Опишите, как вы проверяли исходные данные и какие выводы сделали.
1) Проверили таблицы users и orders на наличие дублей:

select count(id), count (distinct id) from users;
select count(order_id), count (distinct order_id) from orders;

Данные в count и count distinct совпадают, дублей нет.

2) Проверили колонки, необходимые для рассчета витрины, на наличие null:
   select payment 
   from orders
   where payment is null; - нет null в payment

   select order_ts  
   from orders
   where order_ts  is null; - нет null в order_ts

   в принципе. данные проверки избыточны, так как в properties можно увидеть, что у всех колонок стоит ограничение not null и у всех колонок платежей дефолтное значение 0

3) проверили, что все пользователи делали заказ: все из таблицы users присутствуют в orders и нет пользователей без заказов:
select u.id, o.order_id
from users u 
left join orders o 
on u.id=o.user_id
where order_id is null; 

## Укажите, какие инструменты обеспечивают качество данных в источнике.
Ответ запишите в формате таблицы со следующими столбцами:
- `Наименование таблицы` - наименование таблицы, объект которой рассматриваете.
- `Объект` - Здесь укажите название объекта в таблице, на который применён инструмент. Например, здесь стоит перечислить поля таблицы, индексы и т.д.
- `Инструмент` - тип инструмента: первичный ключ, ограничение или что-то ещё.
- `Для чего используется` - здесь в свободной форме опишите, что инструмент делает.

1) Наименование таблицы - production.orders
   Объект -  ALTER TABLE production.orders ADD CONSTRAINT orders_check CHECK ((cost = (payment + bonus_payment)));
   Инструмент - ограничение типа CHECK
   Для чего используется - для исключения ошибок в подсчете значения 

2) Наименование таблицы - production.orders
   Объект -  ALTER TABLE production.orders ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);
   Инструмент - ограничение - первичный ключ 
   Для чего используется - для обеспечения уникальности записей}


## 1.4. Подготовьте витрину данных

{См. задание на платформе}
### 1.4.1. Сделайте VIEW для таблиц из базы production.**

{См. задание на платформе}
```SQL
--Впишите сюда ваш ответ
create view analysis.users as select * from production.users;

create view analysis.OrderItems as select * from production.orderitems;

create view analysis.OrderStatuses as select * from production.orderstatuses;

create view analysis.Products as select * from production.products;

create view analysis.Orders as select * from production.orders;

```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

{См. задание на платформе}
```SQL
--Впишите сюда ваш ответ
CREATE TABLE analysis.dm_rfm_segments (
	user_id int4 NOT NULL,
	recency smallint not null,
	frequency smallint not null,
	monetary_value smallint not null,
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
); 

```

### 1.4.3. Напишите SQL запрос для заполнения витрины

{См. задание на платформе}
```SQL
--Впишите сюда ваш ответ
insert into analysis.dm_rfm_segments (
user_id,
recency,
frequency,
monetary_value)
select rec.user_id as user_id, rec.recency as recency, fre.frequency as frequency, mv.monetary_value as monetary_value
from analysis.tmp_rfm_recency rec
inner join analysis.tmp_rfm_frequency fre on rec.user_id=fre.user_id
inner join analysis.tmp_rfm_monetary_value mv on mv.user_id = rec.user_id;

```



