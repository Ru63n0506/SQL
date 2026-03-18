CREATE PROCEDURE anadir_personal(IN P_NOMBRE VARCHAR(50), IN P_APELLIDO VARCHAR(50), IN P_CARGO VARCHAR(50), IN P_TURNO VARCHAR(20), IN P_TELEFONO VARCHAR(15))
BEGIN
    
    insert into personal (nombre, apellido, cargo, turno, telefono) values (P_NOMBRE, P_APELLIDO, P_CARGO, P_TURNO, P_TELEFONO);

END;

CREATE PROCEDURE anadir_cuarto(IN C_NUMERO INT, IN C_TIPO VARCHAR(50), IN C_CAPACIDAD INT)
BEGIN

    insert into cuarto (numero, tipo, capacidad) values (C_NUMERO, C_TIPO, C_CAPACIDAD);

END;

CREATE PROCEDURE anadir_mobiliario(IN M_NOMBRE VARCHAR(50))
BEGIN

    insert into mobiliario (nombre) values (M_NOMBRE);

END;

CREATE PROCEDURE anadir_medicamento(IN M_NOMBRE VARCHAR(50), IN M_PRECIO DECIMAL(7,2), IN M_CANTIDAD INT, IN M_GRAMAJE VARCHAR(50))
BEGIN

    insert into medicamento (nombre, precio, cantidad, gramaje) values (M_NOMBRE, M_PRECIO, M_CANTIDAD, M_GRAMAJE);

END;

CREATE PROCEDURE anadir_proveedor(IN P_NOMBRE VARCHAR(50), IN P_CONTACTO VARCHAR(10))
BEGIN

    insert into proveedor (nombre, contacto) values (P_NOMBRE, P_CONTACTO);

END;

CREATE PROCEDURE anadir_paciente(IN P_NOMBRE VARCHAR(50), IN P_APELLIDO VARCHAR(50), IN P_SEXO VARCHAR(2), IN P_FECHA_NAC DATE, IN P_TIPO_SANGRE VARCHAR(3))
BEGIN

    insert into paciente (nombre, apellido, sexo, fecha_nac, tipo_sangre) values (P_NOMBRE, P_APELLIDO, P_SEXO, P_FECHA_NAC, P_TIPO_SANGRE);

END;

CREATE PROCEDURE consultar(IN C_ID_PACIENET INT, IN C_ID_PERSONAL INT, IN C_FECHA DATE, IN C_PESO DECIMAL(5,2), IN C_ESTATURA DECIMAL(3,2), IN C_PRESION_ARTERIAL VARCHAR(7), IN C_FRECUENCIA_CARDIACA INT, IN C_FRECUENCIA_RESPIRATORIA INT, IN C_TEMPERATURA DECIMAL(3,1), IN C_DIAGNOSTICO VARCHAR(100))
BEGIN

    insert into consultar(id_paciente, id_personal, fecha, peso, estatura, presion_arterial, frecuencia_cardiaca, frecuencia_respiratoria, temperatura, diagnostico) values (C_ID_PACIENET, C_ID_PERSONAL, C_FECHA, C_PESO, C_ESTATURA, C_PRESION_ARTERIAL, C_FRECUENCIA_CARDIACA, C_FRECUENCIA_RESPIRATORIA, C_TEMPERATURA, C_DIAGNOSTICO);

END;

CREATE PROCEDURE mobiliario_cuarto(IN C_NUMERO INT, IN M_ID INT,IN CANTIDAD INT)
BEGIN

    insert into mobiliario_cuarto(numero_cuarto, id_mobiliario, cantidad) values (C_NUMERO, M_ID, CANTIDAD);

END;

CREATE PROCEDURE recetar(IN R_FOLIO INT, IN R_ID_MEDICAMENTO INT, IN R_CANTIDAD INT)
BEGIN

    insert into recetar(folio, id_medicamento, cantidad) values (R_FOLIO, R_ID_MEDICAMENTO, R_CANTIDAD);

END;    

CREATE PROCEDURE surte(IN S_ID_PROVEEDOR INT, IN S_ID_MEDICAMENTO INT, IN S_FECHA DATE, IN S_CANTIDAD INT)
BEGIN

    insert into surte(id_proveedor, id_medicamento, fecha, cantidad) values (S_ID_PROVEEDOR, S_ID_MEDICAMENTO, S_FECHA, S_CANTIDAD);

END;

CREATE PROCEDURE ocupar_cuarto(IN O_ID_CUARTO INT, IN O_ID_PACIENTE INT, IN O_FECHA_INICIO DATE, IN O_FECHA_FIN DATE)
BEGIN

    insert into ocupar_cuarto(numero_cuarto, id_paciente, fecha_inicio, fecha_fin) values (O_ID_CUARTO, O_ID_PACIENTE, O_FECHA_INICIO, O_FECHA_FIN);

END;

CREATE PROCEDURE mostrar_personal()
BEGIN
    
    select * from personal;

END; 

CREATE PROCEDURE mostrar_cuartos()
BEGIN

    select * from cuarto;

END;

CREATE PROCEDURE mostrar_mobiliarios()
BEGIN
    
    select * from mobiliario;

END; 

CREATE PROCEDURE mostrar_medicamentos()
BEGIN
    
    select * from medicamento;

END; 

CREATE PROCEDURE mostrar_proveedores()
BEGIN
    
    select * from proveedor;

END; 

CREATE PROCEDURE mostrar_pacientes()
BEGIN

    select * from paciente;

END;

CREATE PROCEDURE mostrar_consultas()
BEGIN

    select * from consultar;

END;

CREATE PROCEDURE mostrar_mobiliario_cuarto()
BEGIN

    select * from mobiliario_cuarto;

END;

CREATE PROCEDURE mostrar_recetas()
BEGIN

    select * from recetar;

END;

CREATE PROCEDURE mostrar_surtir()
BEGIN

    select * from surte;

END;

CREATE PROCEDURE mostrar_cuartos_ocupados()
BEGIN

    select * from ocupar;

END;    