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
	IF M_PRECIO < 0 OR M_CANTIDAD < 0 OR M_GRAMAJE < 0 THEN 
		SELECT "Los valores ingresados deben ser positivos" AS Mensaje;
	ELSE
	    INSERT INTO medicamento(nombre, precio_venta, cantidad, gramaje)
	    VALUES (M_NOMBRE, M_PRECIO, M_CANTIDAD, M_GRAMAJE);
	END IF;
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


DROP PROCEDURE IF EXISTS añadir_consulta $$
CREATE PROCEDURE añadir_consulta(
    IN idPac INT,
    IN idPer INT,
    IN fecha DATE,
    IN peso DECIMAL(5,2),
    IN estatura DECIMAL(3,2),
    IN presion_art VARCHAR(7),
    IN frec_card INT,
    IN frec_respi INT,
    IN temperatura DECIMAL(3,1),
    IN diagnostico VARCHAR(100)
)
BEGIN
	if peso <= 0 or estatura <= 0 or temperatura <= 0 
       or frec_card <= 0 or frec_respi <= 0 then
       
        select "Valores del paciente inválidos, deben ser positivos" AS Mensaje;
	else 
		set @cli = (select count(*) from paciente where id = idPac);
		if @cli = 0 then 
			select "No existe el paciente" as Mensaje;
		else
			set @per = (select count(*) from personal where id = idPer);
			if @per = 0 then
				select "No existe el personal" as Mensaje;
			else 
				insert into consultar(id_paciente, id_personal, fecha, peso, estatura, presion_arterial,
				frecuencia_cardiaca, frecuencia_respiratoria, temperatura, diagnostico)
				values (idPac,idPer, fecha, peso, estatura, presion_art, frec_card, frec_respi, temperatura,
				diagnostico);
			end if;
		end if;
	end if;
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
    IN S_CANTIDAD INT,
	IN S_PRECIO_COMPRA DECIMAL(7,2)
)
BEGIN
    set @Vmedicamento = (select count(*) from medicamento where  id = s_id_medicamento);
    set @Vproveedor = (select count(*) from proveedor where  id = s_id_proveedor);

    if(@Vmedicamento = 0 or @Vproveedor = 0) then select "El id del medicamento o del provedor no existen";
    else INSERT INTO surte(id_proveedor, id_medicamento, fecha, precio_compra, cantidad)
    VALUES (S_ID_PROVEEDOR, S_ID_MEDICAMENTO, S_FECHA, S_PRECIO_COMPRA, S_CANTIDAD);
    end if;
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
