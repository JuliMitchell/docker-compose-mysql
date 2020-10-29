USE `classicmodels`;

/* Usuario sin permisos */
CREATE USER 'test001'@'%' IDENTIFIED BY 'test001-pass';

/* Usuario con todos los permisos sobre la base classicmodels */
CREATE USER 'test002'@'%' IDENTIFIED BY 'test002-pass';
GRANT ALL ON classicmodels.* TO 'test002'@'%';

/* Usuario con todos los permisos sobre la tabla employees */
CREATE USER 'test003'@'%' IDENTIFIED BY 'test003-pass';
GRANT ALL ON classicmodels.employees TO 'test003'@'%';

/* Usuario con todos los permisos sobre la columna employeeNumber */
CREATE USER 'test004'@'%' IDENTIFIED BY 'test004-pass';
GRANT SELECT (employeeNumber) ON classicmodels.employees TO 'test004'@'%';

/* Usuario con permiso de lectura sobre la base classicmodels */
CREATE USER 'test005'@'%' IDENTIFIED BY 'test005-pass';
GRANT SELECT ON classicmodels.* TO 'test005'@'%';

FLUSH PRIVILEGES;