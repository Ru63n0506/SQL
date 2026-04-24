create table personal
(
    id int PRIMARY KEY AUTO_INCREMENT not null,
    nombre varchar(50) NOT NULL,
    apellido varchar(50) NOT NULL,
    cargo varchar(50) NOT NULL,
    turno varchar(50) Not NULL,
    telefono varchar(50) NOT NULL
)AUTO_INCREMENT=308;

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
    gramaje varchar(50) not null,
    fecha_caducidad date not null
)AUTO_INCREMENT=110;

create table proveedor
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) not null,
    contacto varchar(10) not null
)AUTO_INCREMENT=1001;

create table paciente
(
    id int primary key AUTO_INCREMENT not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    sexo varchar(2) not null,
    fecha_nac date not null,
    tipo_sangre varchar(3) not null
)AUTO_INCREMENT=151;

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
)AUTO_INCREMENT=1051;

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
