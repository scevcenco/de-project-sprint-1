--creation of tables' views in schema analysis 

create view analysis.users as select * from production.users;

create view analysis.OrderItems as select * from production.orderitems;

create view analysis.OrderStatuses as select * from production.orderstatuses;

create view analysis.Products as select * from production.products;

create view analysis.Orders as select * from production.orders;

