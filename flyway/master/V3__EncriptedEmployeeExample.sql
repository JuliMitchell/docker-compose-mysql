USE `classicmodels`;

INSERT INTO classicmodels.employees (employeeNumber,lastName,firstName,extension,email,officeCode,reportsTo,jobTitle)
VALUES
(9999,'Perez','Juan','x5899',aes_encrypt('dmurphy@classicmodelcars.com','passEmployeeEmail'),'1',NULL,'President');

/* SELECT aes_decrypt(email, 'passEmployeeEmail') FROM classicmodels.employees WHERE employeeNumber = '9999' */