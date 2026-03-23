DELIMITER $$

DROP PROCEDURE IF EXISTS anadir_personal $$
CREATE PROCEDURE anadir_personal(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_CARGO VARCHAR(50),
    IN P_TURNO VARCHAR(20),
    IN P_TELEFONO VARCHAR(15)
)
BEGIN
    INSERT INTO personal(nombre, apellido, cargo, turno, telefono)
    VALUES (P_NOMBRE, P_APELLIDO, P_CARGO, P_TURNO, P_TELEFONO);
END $$


DROP PROCEDURE IF EXISTS anadir_cuarto $$
CREATE PROCEDURE anadir_cuarto(
    IN C_NUMERO INT,
    IN C_TIPO VARCHAR(50),
    IN C_CAPACIDAD INT
)
BEGIN
    INSERT INTO cuarto(numero, tipo, capacidad)
    VALUES (C_NUMERO, C_TIPO, C_CAPACIDAD);
END $$


DROP PROCEDURE IF EXISTS anadir_mobiliario $$
CREATE PROCEDURE anadir_mobiliario(
    IN M_NOMBRE VARCHAR(50)
)
BEGIN
    INSERT INTO mobiliario(nombre)
    VALUES (M_NOMBRE);
END $$


DROP PROCEDURE IF EXISTS anadir_medicamento $$
CREATE PROCEDURE anadir_medicamento(
    IN M_NOMBRE VARCHAR(50),
    IN M_PRECIO DECIMAL(7,2),
    IN M_CANTIDAD INT,
    IN M_GRAMAJE VARCHAR(50)
)
BEGIN
    INSERT INTO medicamento(nombre, precio, cantidad, gramaje)
    VALUES (M_NOMBRE, M_PRECIO, M_CANTIDAD, M_GRAMAJE);
END $$


DROP PROCEDURE IF EXISTS anadir_proveedor $$
CREATE PROCEDURE anadir_proveedor(
    IN P_NOMBRE VARCHAR(50),
    IN P_CONTACTO VARCHAR(10)
)
BEGIN
    INSERT INTO proveedor(nombre, contacto)
    VALUES (P_NOMBRE, P_CONTACTO);
END $$


DROP PROCEDURE IF EXISTS anadir_paciente $$
CREATE PROCEDURE anadir_paciente(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_SEXO VARCHAR(2),
    IN P_FECHA_NAC DATE,
    IN P_TIPO_SANGRE VARCHAR(3)
)
BEGIN
    INSERT INTO paciente(nombre, apellido, sexo, fecha_nac, tipo_sangre)
    VALUES (P_NOMBRE, P_APELLIDO, P_SEXO, P_FECHA_NAC, P_TIPO_SANGRE);
END $$


DROP PROCEDURE IF EXISTS consultar $$
CREATE PROCEDURE consultar(
    IN C_ID_PACIENTE INT,
    IN C_ID_PERSONAL INT,
    IN C_FECHA DATE,
    IN C_PESO DECIMAL(5,2),
    IN C_ESTATURA DECIMAL(3,2),
    IN C_PRESION_ARTERIAL VARCHAR(7),
    IN C_FRECUENCIA_CARDIACA INT,
    IN C_FRECUENCIA_RESPIRATORIA INT,
    IN C_TEMPERATURA DECIMAL(3,1),
    IN C_DIAGNOSTICO VARCHAR(100)
)
BEGIN
    INSERT INTO consultar(
        id_paciente, id_personal, fecha, peso, estatura,
        presion_arterial, frecuencia_cardiaca,
        frecuencia_respiratoria, temperatura, diagnostico
    )
    VALUES (
        C_ID_PACIENTE, C_ID_PERSONAL, C_FECHA, C_PESO, C_ESTATURA,
        C_PRESION_ARTERIAL, C_FRECUENCIA_CARDIACA,
        C_FRECUENCIA_RESPIRATORIA, C_TEMPERATURA, C_DIAGNOSTICO
    );
END $$


DROP PROCEDURE IF EXISTS mobiliario_cuarto $$
CREATE PROCEDURE mobiliario_cuarto(
    IN C_NUMERO INT,
    IN M_ID INT,
    IN CANTIDAD INT
)
BEGIN
    INSERT INTO mobiliario_cuarto(numero_cuarto, id_mobiliario, cantidad)
    VALUES (C_NUMERO, M_ID, CANTIDAD);
END $$


DROP PROCEDURE IF EXISTS recetar $$
CREATE PROCEDURE recetar(
    IN R_FOLIO INT,
    IN R_ID_MEDICAMENTO INT,
    IN R_CANTIDAD INT
)
BEGIN
    INSERT INTO recetar(folio, id_medicamento, cantidad)
    VALUES (R_FOLIO, R_ID_MEDICAMENTO, R_CANTIDAD);
END $$


DROP PROCEDURE IF EXISTS surte $$
CREATE PROCEDURE surte(
    IN S_ID_PROVEEDOR INT,
    IN S_ID_MEDICAMENTO INT,
    IN S_FECHA DATE,
    IN S_CANTIDAD INT
)
BEGIN
    INSERT INTO surte(id_proveedor, id_medicamento, fecha, cantidad)
    VALUES (S_ID_PROVEEDOR, S_ID_MEDICAMENTO, S_FECHA, S_CANTIDAD);
END $$


DROP PROCEDURE IF EXISTS ocupar_cuarto $$
CREATE PROCEDURE ocupar_cuarto(
    IN O_ID_CUARTO INT,
    IN O_ID_PACIENTE INT,
    IN O_FECHA_INICIO DATE,
    IN O_FECHA_FIN DATE
)
BEGIN
    INSERT INTO ocupar(id_cuarto, id_paciente, fecha_inicio, fecha_fin)
    VALUES (O_ID_CUARTO, O_ID_PACIENTE, O_FECHA_INICIO, O_FECHA_FIN);
END $$

DELIMITER ;
