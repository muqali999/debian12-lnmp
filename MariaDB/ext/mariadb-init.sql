--
-- Update user:root password
--
USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED BY '1f3eaca3c2c42fce20ed56e0bb795b6d';

--
-- Create New Account And Set Permissions
--
CREATE USER 'dump_user'@'localhost' IDENTIFIED BY 'c9c3a312089f628ede1bad7f560bcbe9';
GRANT SELECT, LOCK TABLES ON *.* TO 'dump_user'@'localhost';

CREATE USER 'gentleman'@'localhost' IDENTIFIED BY '1f066e52329503694f92512c6bcab726';
GRANT ALL PRIVILEGES ON *.* TO 'gentleman'@'localhost';

FLUSH PRIVILEGES;

--
-- Select User List
--
use mysql;
select host, user from user; 
select Host, Db, User from db;