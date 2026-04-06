DELIMITER //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_cuarto(
    IN C_NUMERO INT,
    IN C_TIPO VARCHAR(50),
    IN C_CAPACIDAD INT
)
BEGIN
    DECLARE existe INT;

    IF C_NUMERO < 100 OR C_NUMERO >= 400 THEN
        SELECT "Numero de cuarto invalido" AS Mensaje;
    ELSEIF C_CAPACIDAD <= 0 THEN
        SELECT "La capacidad debe ser positiva" AS Mensaje;
    ELSEIF C_TIPO = '' THEN
        SELECT "No se puede dejar el tipo vacio" AS Mensaje;
    ELSE
        SELECT COUNT(*) INTO existe 
        FROM cuarto 
        WHERE numero = C_NUMERO;

        IF existe > 0 THEN
            SELECT "El cuarto ya existe" AS Mensaje;
        ELSE
            INSERT INTO cuarto(numero, tipo, capacidad)
            VALUES (C_NUMERO, C_TIPO, C_CAPACIDAD);
            SELECT "Cuarto agregado correctamente!" AS Mensaje;
        END IF;
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_medicamento(
    IN M_NOMBRE VARCHAR(50),
    IN M_PRECIO DECIMAL(7,2),
    IN M_CANTIDAD INT,
    IN M_GRAMAJE VARCHAR(50)
)
BEGIN
    IF M_PRECIO < 0 THEN
        SELECT "El precio debe de ser positivo" AS Mensaje;
    ELSEIF M_CANTIDAD < 0 THEN
        SELECT "La cantidad debe de ser positiva" AS Mensaje;
    ELSE
        INSERT INTO medicamento(nombre, precio_venta, cantidad, gramaje)
        VALUES (M_NOMBRE, M_PRECIO, M_CANTIDAD, M_GRAMAJE);
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_mobiliario(
    IN M_NOMBRE VARCHAR(50)
)
BEGIN
    INSERT INTO mobiliario(nombre)
    VALUES (M_NOMBRE);
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_paciente(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_SEXO VARCHAR(2),
    IN P_FECHA_NAC DATE,
    IN P_TIPO_SANGRE VARCHAR(3)
)
BEGIN
    INSERT INTO paciente(nombre, apellido, sexo, fecha_nac, tipo_sangre)
    VALUES (P_NOMBRE, P_APELLIDO, P_SEXO, P_FECHA_NAC, P_TIPO_SANGRE);
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_personal(
    IN P_NOMBRE VARCHAR(50),
    IN P_APELLIDO VARCHAR(50),
    IN P_CARGO VARCHAR(50),
    IN P_TURNO VARCHAR(20),
    IN P_TELEFONO VARCHAR(15)
)
BEGIN
    INSERT INTO personal(nombre, apellido, cargo, turno, telefono)
    VALUES (P_NOMBRE, P_APELLIDO, P_CARGO, P_TURNO, P_TELEFONO);
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_proveedor(
    IN P_NOMBRE VARCHAR(50),
    IN P_CONTACTO VARCHAR(10)
)
BEGIN
    INSERT INTO proveedor(nombre, contacto)
    VALUES (P_NOMBRE, P_CONTACTO);
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE anadir_consulta(
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
    IF peso <= 0 THEN
        SELECT "El peso debe de ser positivo" AS Mensaje;
    ELSEIF estatura <= 0 THEN
        SELECT "La estatura debe de ser positiva" AS Mensaje;
    ELSEIF temperatura <= 0 THEN
        SELECT "La temperatura debe de ser positiva" AS Mensaje;
    ELSEIF frec_card <= 0 THEN
        SELECT "La frecuencia cardiaca debe de ser positiva" AS Mensaje;
    ELSEIF frec_respi <= 0 THEN
        SELECT "La frecuencia respiratoria debe de ser positiva" AS Mensaje;
    ELSE
        SET @cli = (SELECT COUNT(*) FROM paciente WHERE id = idPac);

        IF @cli = 0 THEN
            SELECT "No existe el paciente" AS Mensaje;
        ELSE
            SET @per = (SELECT COUNT(*) FROM personal WHERE id = idPer);

            IF @per = 0 THEN
                SELECT "No existe el personal" AS Mensaje;
            ELSE
                INSERT INTO consultar(id_paciente, id_personal, fecha, peso, estatura, presion_arterial,
                frecuencia_cardiaca, frecuencia_respiratoria, temperatura, diagnostico)
                VALUES (idPac,idPer, fecha, peso, estatura, presion_art, frec_card, frec_respi, temperatura, diagnostico);

                SELECT "Consulta registrada exitosamente!" AS Mensaje;
            END IF;
        END IF;
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE mobiliario_cuarto(
    IN C_NUMERO INT,
    IN M_ID INT,
    IN CANTIDAD INT
)
BEGIN
    DECLARE C_CUARTO INT;
    DECLARE C_MOBILIARIO INT;
    DECLARE C_EXISTE INT;
    
    IF CANTIDAD <= 0 THEN
        SELECT "La cantidad de mobiliario debe de ser positiva" AS Mensaje;
    ELSE
        SELECT COUNT(*) INTO C_CUARTO FROM cuarto WHERE numero = C_NUMERO;

        IF C_CUARTO = 0 THEN
            SELECT "El cuarto no existe" AS Mensaje;
        ELSE
            SELECT COUNT(*) INTO C_MOBILIARIO FROM mobiliario WHERE id = M_ID;

            IF C_MOBILIARIO = 0 THEN
                SELECT "El mobiliario no existe" AS Mensaje;
            ELSE
                SELECT COUNT(*) INTO C_EXISTE
                FROM mobiliario_cuarto
                WHERE numero_cuarto = C_NUMERO AND id_mobiliario = M_ID;

                IF C_EXISTE > 0 THEN
                    SELECT "Ese mobiliario ya está asignado al cuarto" AS Mensaje;
                ELSE
                    INSERT INTO mobiliario_cuarto(numero_cuarto, id_mobiliario, cantidad)
                    VALUES (C_NUMERO, M_ID, CANTIDAD);

                    SELECT "Mobiliario añadido con exito!" AS Mensaje;
                END IF;
            END IF;
        END IF;
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE ocupar_cuarto(
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

            SELECT "Cuarto ocupado con exito!" AS Mensaje;
        END IF;
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE recetar(
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

                SELECT "Medicamento recetado con exito!!" AS Mensaje;
            END IF;
        END IF;
    END IF;
END //

CREATE DEFINER=`root`@`localhost` PROCEDURE surte(
    IN S_ID_PROVEEDOR INT,
    IN S_ID_MEDICAMENTO INT,
    IN S_FECHA DATE,
    IN S_CANTIDAD INT,
    IN S_PRECIO_COMPRA DECIMAL(7,2)
)
BEGIN
    SET @Vmedicamento = (SELECT COUNT(*) FROM medicamento WHERE id = S_ID_MEDICAMENTO);
    SET @Vproveedor = (SELECT COUNT(*) FROM proveedor WHERE id = S_ID_PROVEEDOR);

    IF @Vmedicamento = 0 THEN
        SELECT "El id del medicamento no existe!" AS Mensaje;
    ELSEIF @Vproveedor = 0 THEN
        SELECT "El id del proveedor no existe!" AS Mensaje;
    ELSE
        INSERT INTO surte(id_proveedor, id_medicamento, fecha, precio_compra, cantidad)
        VALUES (S_ID_PROVEEDOR, S_ID_MEDICAMENTO, S_FECHA, S_PRECIO_COMPRA, S_CANTIDAD);

        SELECT "Medicamento surtido con exito!" AS Mensaje;
    END IF;
END //

DELIMITER ;
