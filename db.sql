---------------------------------------------------------------------------
--
-- Execute this script before before running the app
-- Stored procedures for inventory
-- Database: Postgresql
--
-- Author: Roselle Ebarle
-- http://roselleebarle.com
--
-----------------------------------------------------------------
create table products (
   product_id serial primary key,
   title text,
   description text,
   date_added timestamp without time zone NOT NULL DEFAULT now(),
   ordering int DEFAULT 0,
   supplier_id int,
   category_id int,
   site_id int,
   product_type_id int,
   on_hand int,
   re_order_level int,
   is_active boolean DEFAULT TRUE
);
-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION products_upsert(in par_product_id int, in par_title text, in par_description text, in par_supplier_id int, in par_category_id int, in par_site_id int, in par_product_type_id int, in par_on_hand int, in par_re_order_level int) returns text as $$
  DECLARE
    loc_response text;
  BEGIN

    -- If no product_category_id was passed, then create a new row else update the row
    if par_product_id isnull then
      insert into products(title, description, supplier_id, category_id, site_id, product_type_id, on_hand, re_order_level) values (par_title, par_description,par_supplier_id, par_category_id, par_site_id, par_product_type_id, par_on_hand, par_re_order_level);
      loc_response = 'ok';
    else
      update products set title=par_title, description=par_description, supplier_id=par_supplier_id, category_id=par_category_id, site_id=par_site_id, product_type_id=par_product_type_id, on_hand=par_on_hand, re_order_level=par_re_order_level where product_id=par_product_id;
    loc_response = 'ok';
    end if;

    return loc_response;
  END;
$$ LANGUAGE 'plpgsql';
--------------------------------------------------------------------------------------------------------
select products_upsert(null, 'test','description',1,1,1,1,100,10);
--------------------------------------------------------------------------------------------------------
create or replace function products_get(in par_product_id int) returns setof products as $$
  BEGIN
    if par_product_id isnull then
      return query select * from products;
    else
      return query select * from products where product_id = par_product_id;
    end if;
  END;
$$ LANGUAGE 'plpgsql';
-----------------------------------------------------------------
-- select * from products_get();
-----------------------------------------------------------------








