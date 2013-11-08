create table products(
  id integer primary key,
  shortdesc varchar(255),
  description text,
  image_url varchart(2083),
  category_id int(11) NOT NULL,
  foreign key (category_id) references categories(id));

create table categories(
  id integer primary key,
  name varchar(255)
  );

create table votes(
  id integer primary key,
  product_id integer NOT NULL,
  upvote int(11) NOT NULL DEFAULT 0,
  downvote int(11) NOT NULL DEFAULT 0,
  foreign key (product_id) references products(id)
  );

insert into categories (name) values ("gadget");
insert into products (shortdesc, description, image_url, category_id) values ("iPhone5", "really cool", "http://asset1.cbsistatic.com/cnwk.1d/i/tim/2012/09/17/06_archimedes_35438535_620x433.jpg", 1);
insert into products (shortdesc, description, image_url, category_id) values ("HelloKittyHeadPhone", "really cool kitty", "http://blog.aerial7.com/wp-content/uploads/2010/06/AERIAL7_Hello_Kitty_Headphones.jpg", 1);
insert into votes (product_id) values (1);
insert into votes (product_id) values (2);

