//Procedimientos modificados acorde a los comentarios de la 2da Entrega

// Copiar y pegar tal cual en el procedimiento de cada uno en Workbench

// anadir_cuarto

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_cuarto`(
    IN C_NUMERO INT,
    IN C_TIPO VARCHAR(50),
    IN C_CAPACIDAD INT
)
BEGIN
	DECLARE existe int;

	IF C_NUMERO < 100 OR C_NUMERO >= 400 
		THEN SELECT "Numero de cuarto invalido" as Mensaje;
	ELSE 
		IF C_CAPACIDAD <= 0
			THEN SELECT "La capacidad debe ser positiva" as Mensaje;
		ELSE 
			IF C_TIPO = ''
				THEN SELECT "No se puede dejar el tipo vacio" as Mensaje;
			ELSE
				SELECT COUNT(*) INTO existe 
				FROM cuarto 
				WHERE numero = C_NUMERO;

				IF existe > 0
					THEN SELECT "El cuarto ya existe" AS Mensaje;
				ELSE
					INSERT INTO cuarto(numero, tipo, capacidad)
					VALUES (C_NUMERO, C_TIPO, C_CAPACIDAD);
                    SELECT "Cuarto agregadl correctamente!" as Mensaje;
				END IF;
			END IF;
		END IF;
	END IF;
END

// anadir_medicamento

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_medicamento`(
    IN M_NOMBRE VARCHAR(50),
    IN M_PRECIO DECIMAL(7,2),
    IN M_CANTIDAD INT,
    IN M_GRAMAJE VARCHAR(50)
)
BEGIN
	IF M_PRECIO < 0 
		THEN SELECT "El precio debe de ser positivo" AS Mensaje;
	ELSE 
		IF M_CANTIDAD < 0 
			THEN SELECT "La cantidad debe de ser positiva" AS Mensaje;
		ELSE 
			IF M_GRAMAJE < 0 
				THEN SELECT "El gramaje debe de ser positivo" AS Mensaje;
			ELSE
				INSERT INTO medicamento(nombre, precio_venta, cantidad, gramaje)
				VALUES (M_NOMBRE, M_PRECIO, M_CANTIDAD, M_GRAMAJE);
			END IF;
		END IF;
	END IF;
END

// anadir_mobiliario

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_mobiliario`(
    IN M_NOMBRE VARCHAR(50)
)
BEGIN
    INSERT INTO mobiliario(nombre)
    VALUES (M_NOMBRE);
END

// anadir_paciente

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_paciente`(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_SEXO VARCHAR(2),
    IN P_FECHA_NAC DATE,
    IN P_TIPO_SANGRE VARCHAR(3)
)
BEGIN
    INSERT INTO paciente(nombre, apellido, sexo, fecha_nac, tipo_sangre)
    VALUES (P_NOMBRE, P_APELLIDO, P_SEXO, P_FECHA_NAC, P_TIPO_SANGRE);
END

// anadir_personal

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_personal`(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_CARGO VARCHAR(50),
    IN P_TURNO VARCHAR(20),
    IN P_TELEFONO VARCHAR(15)
)
BEGIN
    INSERT INTO personal(nombre, apellido, cargo, turno, telefono)
    VALUES (P_NOMBRE, P_APELLIDO, P_CARGO, P_TURNO, P_TELEFONO);
END

// anadir_proveedor

CREATE DEFINER=`root`@`localhost` PROCEDURE `anadir_proveedor`(
    IN P_NOMBRE VARCHAR(50),
    IN P_CONTACTO VARCHAR(10)
)
BEGIN
    INSERT INTO proveedor(nombre, contacto)
    VALUES (P_NOMBRE, P_CONTACTO);
END

// añadir_consulta

CREATE DEFINER=`root`@`localhost` PROCEDURE `añadir_consulta`(
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
	if peso <= 0 
		then select "El peso debe de ser positivo" as Mensaje;
	else 
		if estatura <= 0
			then select "La estatura debe de ser positiva" as Mensaje;
		else
			if temperatura <= 0
				then select "La temperatura debe de ser positiva" as Mensaje;
			else
				if frec_card <= 0
					then select "La frecuencia cardiaca debe de ser positiva" as Mensaje;
				else 
					if frec_respi <= 0 
						then select "La frecuencia respiratoria debe de ser positiva" as Mensaje;
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
                                select "Consulta registrada exitosamente!" as Mensaje;
							end if;
						end if;
					end if;
				end if;
			end if;
		end if;
	end if;
END

// mobiliario_cuarto

CREATE DEFINER=`root`@`localhost` PROCEDURE `mobiliario_cuarto`(
    IN C_NUMERO INT,
    IN M_ID INT,
    IN CANTIDAD INT
)
BEGIN
	DECLARE C_CUARTO INT;
	DECLARE C_MOBILIARIO INT;
	DECLARE C_EXISTE INT;
	
	IF CANTIDAD <=0
		THEN SELECT "La cantidad de mobiliario debe de ser positiva" AS Mensaje;
	ELSE
		SELECT COUNT(*) INTO C_CUARTO
		FROM cuarto WHERE numero = C_NUMERO;

		IF C_CUARTO = 0
			THEN SELECT "El cuarto no existe" AS Mensaje;
		ELSE
			SELECT COUNT(*) INTO C_MOBILIARIO
			FROM mobiliario WHERE id = M_ID;

			IF C_MOBILIARIO = 0
				THEN SELECT "El mobiliario no existe" AS Mensaje;
			ELSE
				SELECT COUNT(*) INTO C_EXISTE
                FROM mobiliario_cuarto
                WHERE numero_cuarto = C_NUMERO AND id_mobiliario = M_ID;

                IF C_EXISTE > 0 
					THEN SELECT "Ese mobiliario ya está asignado al cuarto" AS Mensaje;
                ELSE
    				INSERT INTO mobiliario_cuarto(numero_cuarto, id_mobiliario, cantidad)
    				VALUES (C_NUMERO, M_ID, CANTIDAD);
                    select "Mobiliario añadido con exito!" as Mensaje;
				END IF;
			END IF;
		END IF;
	END IF;
END

// ocupar_cuarto

CREATE DEFINER=`root`@`localhost` PROCEDURE `ocupar_cuarto`(
    IN O_ID_CUARTO INT,
    IN O_ID_PACIENTE INT,
    IN O_FECHA_INICIO DATE,
    IN O_FECHA_FIN DATE
)
BEGIN
    SET @cuarto = (SELECT COUNT(*) FROM cuarto WHERE numero = O_ID_CUARTO);

    IF @cuarto = 0 THEN
        SELECT "El cuarto no existe" AS Mensaje;
    ELSE
        SET @paciente = (SELECT COUNT(*) FROM paciente WHERE id = O_ID_PACIENTE);

        IF @paciente = 0 THEN
            SELECT "El paciente no existe" AS Mensaje;
        ELSE
            INSERT INTO ocupar(id_cuarto, id_paciente, fecha_inicio, fecha_fin)
            VALUES (O_ID_CUARTO, O_ID_PACIENTE, O_FECHA_INICIO, O_FECHA_FIN);
            select "Cuarto ocupado con exito!" as Mensaje;
        END IF;
    END IF;
END

// recetar

CREATE DEFINER=`root`@`localhost` PROCEDURE `recetar`(
    IN R_FOLIO INT,
    IN R_ID_MEDICAMENTO INT,
    IN R_CANTIDAD INT
)
BEGIN
    IF R_CANTIDAD <= 0 THEN
        SELECT "La cantidad debe ser positiva" AS Mensaje;
    ELSE
        SET @folio = (SELECT COUNT(*) FROM consultar WHERE folio = R_FOLIO);

        IF @folio = 0 THEN
            SELECT "El folio no existe" AS Mensaje;
        ELSE
            SET @med = (SELECT COUNT(*) FROM medicamento WHERE id = R_ID_MEDICAMENTO);

            IF @med = 0 THEN
                SELECT "El medicamento no existe" AS Mensaje;
            ELSE
                INSERT INTO recetar(folio, id_medicamento, cantidad)
                VALUES (R_FOLIO, R_ID_MEDICAMENTO, R_CANTIDAD);
                select "Medicamento recetado con exito!!" as Mensaje;
            END IF;
        END IF;
    END IF;
END

// surte

CREATE DEFINER=`root`@`localhost` PROCEDURE `surte`(
    IN S_ID_PROVEEDOR INT,
    IN S_ID_MEDICAMENTO INT,
    IN S_FECHA DATE,
    IN S_CANTIDAD INT,
	IN S_PRECIO_COMPRA DECIMAL(7,2)
)
BEGIN
    set @Vmedicamento = (select count(*) from medicamento where  id = s_id_medicamento);
    set @Vproveedor = (select count(*) from proveedor where  id = s_id_proveedor);

    if @Vmedicamento = 0 
		then select "El id del medicamento no existe!" as Mensaje;
	else
		if @Vproveedor = 0 
			then select "El id del provedor no existe!" as Mensaje;
		else 
			INSERT INTO surte(id_proveedor, id_medicamento, fecha, precio_compra, cantidad)
			VALUES (S_ID_PROVEEDOR, S_ID_MEDICAMENTO, S_FECHA, S_PRECIO_COMPRA, S_CANTIDAD);
			select "Medicamento surtido con exito!" as Mensaje;
		end if;
	end if;
END
