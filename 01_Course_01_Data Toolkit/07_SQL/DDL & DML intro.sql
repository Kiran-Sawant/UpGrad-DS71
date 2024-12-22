-- Creating a database
create database market_star_schema;

-- run all commands on this DB
use market_star_schema;

-- Creating a table with 3 attributes
create table shipping_mode_dim (
	ship_mode varchar(25),
    toll_required boolean,
    vehical_company varchar(20)
    );

-- Assigning a primary key
alter table shipping_mode_dim add constraint primary key(ship_mode);

-- Adding a new column
alter table shipping_mode_dim
add vehicle_number varchar(20);

-- Removing an existing column
alter table shipping_mode_dim
drop column vehicle_number;

-- Change the data type and name of a column
alter table shipping_mode_dim
change toll_required toll_amount int;
-----------------------------------------------------------------------------------
-- DML commands
-- INSERT command
insert into shipping_mode_dim
values 
	("Delivery Truck", "LeyLand", False),
    ("Air", "Lauda Airlines", True);
    
insert into shipping_mode_dim (toll_required, ship_mode, vehical_company)
values 
	(False, "Delivery Truck", "LeyLand"),
    ( True, "Air", "Lauda Airlines");
    
-- UPDATE command
-- Make sure update and delete have a where clause regardless of DBMS saftey features
update shipping_mode_dim
set toll_required = True
where ship_mode = "Delivery Truck";

-- DELETE command
-- Be careful with deleting values in a table with foreign key constraints.
-- MySQL will not allow such deletions as it will violate the constraint.
delete from shipping_mode_dim
where ship_mode = "Air India";

-- dropping a table
drop table shipping_mode_dim

