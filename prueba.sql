create database clinica;

use clinica;

drop table consultar;
drop table cuarto;
drop table medicamento;
drop table mobiliario;
drop table mobiliario_cuarto;
drop table ocupar;
drop table paciente;
drop table personal;
drop table proveedor;
drop table recetar;
drop table surte;

create table personal
(
    id int PRIMARY KEY AUTO_INCREMENT not null,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    cargo varchar(50) NOT NULL,
    turno varchar(50) Not NULL,
    telefono varchar(50) NOT NULL
);

create table cuarto
(
    numero int PRIMARY KEY not null,
    tipo varchar(50) not null,
    capacidad int not null
);

create table mobiliario
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) NOT NULL
);

create table medicamento
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) not null,
    precio DECIMAL(7,2) not null,
    cantidad int not null,
    gramaje varchar(50) not null
);

create table proveedor
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) not null,
    contacto varchar(10) not null
);

create table paciente
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    sexo varchar(2) not null,
    fecha_nac date not null,
    tipo_sangre varchar(3) not null
);

create table consultar
(
    folio int primary key AUTO_INCREMENT not null,
    id_paciente int not null,
    id_personal int not null,
    fecha date not null,
    peso DECIMAL(5,2) not null,
    estatura DECIMAL(3,2) not null,
    presion_arterial VARCHAR(7) not null,
    frecuencia_cardiaca int not null,
    frecuencia_respiratoria int not null,
    temperatura DECIMAL(3,1) not null,
    diagnostico varchar(100) not null,

    foreign key (id_paciente) references paciente(id),
    foreign key (id_personal) references personal(id)
);

create table mobiliario_cuarto
(
    numero_cuarto int not null,
    id_mobiliario int not null,
    cantidad int not null,

    primary key (numero_cuarto, id_mobiliario),
    
    foreign key (numero_cuarto) references cuarto(numero),
    foreign key (id_mobiliario) references mobiliario(id)
);

create table recetar
(
    folio int not null,
    id_medicamento int not null,
    cantidad int not null,

    primary key (folio, id_medicamento),

    foreign key (folio) references consultar(folio),
    Foreign Key (id_medicamento) REFERENCES medicamento(id)
);

create table surte
(
    id_proveedor int not null,
    id_medicamento int not null,
    fecha date not null,
    cantidad int not null,    

    primary key (id_proveedor, id_medicamento, fecha),

    foreign key (id_proveedor) references proveedor(id),
    foreign key (id_medicamento) references medicamento(id)
);

create table ocupar
(
    id_cuarto int not null,
    id_paciente int not null,
    fecha_inicio date not null,
    fecha_fin date,

    primary key (id_cuarto, id_paciente, fecha_inicio),

    foreign key (id_cuarto) references cuarto(numero),
    foreign key (id_paciente) references paciente(id)
);

CALL anadir_personal('Álvaro', 'Camacho', 'Enfermero', 'Vespertino', '2218439270');
CALL anadir_personal('Mónica', 'Treviño', 'Cardióloga', 'Vespertino', '2229183745');
CALL anadir_personal('César', 'Haro', 'Camillero', 'Nocturno', '2216574928');
CALL anadir_personal('Rocío', 'Manríquez', 'Enfermera', 'Vespertino', '2227041539');
CALL anadir_personal('Damián', 'Arellano', 'Médico General', 'Matutino', '2219843207');
CALL anadir_personal('Araceli', 'Salmerón', 'Recepcionista', 'Vespertino', '2215039476');
CALL anadir_personal('Braulio', 'Castañeda', 'Paramédico', 'Matutino', '2221358740');
CALL anadir_personal('Jimena', 'Calvillo', 'Enfermera', 'Vespertino', '2226943801');
CALL anadir_personal('Omar', 'Toscano', 'Cirujano', 'Nocturno', '2228471903');
CALL anadir_personal('Susana', 'Mendieta', 'Psicóloga', 'Matutino', '2217426198');
CALL anadir_personal('Elías', 'Torales', 'Ortopedista', 'Vespertino', '2224198750');
CALL anadir_personal('Abril', 'Sepúlveda', 'Trabajadora Social', 'Vespertino', '2215309472');
CALL anadir_personal('Diego', 'Alfaro', 'Técnico Rayos X', 'Matutino', '2216405839');
CALL anadir_personal('Julieta', 'Covarrubias', 'Enfermera', 'Nocturno', '2229548617');
CALL anadir_personal('Mauricio', 'Zepeda', 'Anestesiólogo', 'Vespertino', '2219037462');
CALL anadir_personal('Nadia', 'Pastrana', 'Nutrióloga', 'Matutino', '2227815409');
CALL anadir_personal('Héctor', 'Tinoco', 'Paramédico', 'Matutino', '2218924703');
CALL anadir_personal('Leticia', 'Sabines', 'Ginecóloga', 'Vespertino', '2224679310');
CALL anadir_personal('Javier', 'Bedolla', 'Camillero', 'Matutino', '2227103489');
CALL anadir_personal('Karina', 'Alcántara', 'Enfermera', 'Nocturno', '2218539740');
CALL mostrar_personal();