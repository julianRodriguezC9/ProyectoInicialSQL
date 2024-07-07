drop database if  exists empadb_prueba;
create database empadb_prueba;
use empadb_prueba;

-- CREACION PERSONAS ROLES DENTRO DE LA EMPA--
drop table  if exists personas;
create table personas (
DNI int unsigned unique,
Apellido varchar(30),
Nombre varchar(30),
Provincia varchar(35),
Localidad varchar(30),
Direccion varchar(30),
Legajo int unsigned auto_increment primary key,
Edad tinyint unsigned,
Sexo enum('M','F','X') not null,
fecha_nacimiento date,
contacto_num varchar(20)
) auto_increment=4444;
-- Realizar importancion de 'datos personas.csv' --

create table roles(
ID int unsigned primary key,
rol_profesor bool not null ,
rol_estudiante bool not null,
rol_admin bool not null, 
permiso bool default false,
foreign key (ID) references personas(DNI)
on delete cascade on update cascade
);
-- Realizar importancion de 'datos roles.csv' --

-- CREACION TABLAS ESTUDIANTES,PROFESORES,ADMINISTRATIVOS Y USUARIOS CV--
create table estudiantes (
estudiante_id int unsigned primary key,
foreign key (estudiante_id) references personas(DNI)
);
Insert into estudiantes (
select ID from roles where rol_estudiante=true
);

create table profesores(
profesor_id int unsigned primary key,
foreign key (profesor_id) references personas(DNI)
on delete cascade on update cascade
);


create table administrativos (
admin_id int unsigned primary key,
foreign key (admin_id) references personas(DNI)
on delete cascade on update cascade
);


create table usuarios_cv(
usuario int not null primary key auto_increment,
dni int unsigned,
permiso bool default false,
password varchar(30), 
foreign key (dni) references personas(dni)
)auto_increment=1111;




-- Creacion tablas de areas, carreras, instrmentos y asignaturas--
create table areas (
area_id tinyint primary key,
descripcion varchar(20)
);
-- Realizar importancion de 'datos areas.csv' --
create table carreras (
carrera_id tinyint primary key,
descripcion varchar(40)
);
-- Realizar importancion de 'datos carreras.csv' --
create table instrumentos (
instrumento_id tinyint primary key,
descripcion varchar(20)
);
-- Realizar importancion de 'datos instrumentos.csv' --
create table asignaturas (
asignatura_id int unsigned primary key,
descripcion varchar(60),
año varchar(20) not null,
carrera_id tinyint not null,
area_id tinyint default null,
instrumento_id tinyint default null,
foreign key (carrera_id) references carreras(carrera_id) on update cascade on delete restrict,
foreign key (area_id) references areas(area_id) on update cascade on delete restrict,
foreign key (instrumento_id) references instrumentos(instrumento_id) on update cascade on delete restrict
);
-- Realizar importancion de 'datos asignaturas.csv' --

create table aulas(
num_aula smallint unsigned primary key,
descripcion varchar(30) null
);

create table horarios(
horario_id tinyint unsigned not null primary key,
descripcion varchar(40)
);

-- Realizar importancion de 'datos aulas.csv' y 'datos horarios.csv ' --

create table comisiones(
comision_id int unsigned not null unique,
asignatura_id int unsigned not null,
horario tinyint unsigned not null,
num_aula smallint unsigned, 
descripcion varchar(100),
primary key(horario,num_aula), /* Clave compuesta, asi no hay una clase ubicada en el mismo espaciotiempo que otra*/
foreign key (asignatura_id) references asignaturas(asignatura_id) on update restrict on delete restrict,
foreign key (num_aula) references aulas(num_aula) on update cascade on delete restrict,
foreign key (horario) references horarios(horario_id) on update cascade on delete restrict
);
-- Realizar importancion de 'datos comisiones.csv' --

create table matriculas_carreras (
carr_matricula int unsigned auto_increment primary key,
estudiante_id int unsigned,
area_id tinyint,
carrera_id tinyint,
instrumento_id tinyint,
foreign key (estudiante_id) references estudiantes(estudiante_id) on update cascade on delete cascade,
foreign key (carrera_id) references carreras(carrera_id) on update cascade on delete restrict,
foreign key (area_id) references areas(area_id) on update cascade on delete restrict,
foreign key (instrumento_id) references instrumentos(instrumento_id) on update cascade on delete restrict
);

create table matriculas_asignaturas(
matricula_id int unsigned auto_increment not null unique , /* Clave compuesta*/
estudiante_id int unsigned,
asignatura_id  int unsigned,
comision_id int unsigned,
primary key (estudiante_id,asignatura_id),
foreign key (estudiante_id) references estudiantes(estudiante_id) on delete cascade on update cascade,
foreign key (asignatura_id) references asignaturas(asignatura_id) on delete restrict on update cascade,
foreign key (comision_id) references comisiones(comision_id) on delete restrict on update cascade
);
-- Realizar importancion de 'datos matriculas carrera.csv' y 'datos matriculas asignaturas.csv'--


drop table if exists clases;
create table clases(
clase_id int unsigned not null auto_increment unique ,
comision_id int unsigned not null  ,
fecha date,
foreign key (comision_id) references comisiones(comision_id),
primary key (comision_id,fecha)
);
-- Realizar importancion de 'datos clases.csv' --
create table asistencia(
asistencia_id int unsigned not null unique,
estudiante_id int unsigned not null,
asistencia bool not null,
clase_id int unsigned not null,
fecha date ,
notused int,
primary key (estudiante_id,clase_id),
foreign key (estudiante_id) references estudiantes(estudiante_id),
foreign key (clase_id) references clases(clase_id)


 -- Me aseguro que no se repita asistencia de mismo estudiante en misma clase--
);
-- Realizar importacion de datos del archivo de datos asistencia--

create table bitacora_matriculas(
`matricula_id` int unsigned NOT NULL,
  `estudiante_id` int unsigned NOT NULL,
  `asignatura_id` int unsigned NOT NULL,
  `comision_id` int unsigned DEFAULT NULL,
  `asignatura` varchar(60),
  `carrera` varchar(40)

);
create table bitacora_eliminacion(
	ID_eliminacion int not null auto_increment primary key ,
  `DNI` int unsigned NOT NULL,
  `Apellido` varchar(30) DEFAULT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Provincia` varchar(35) DEFAULT NULL,
  `Localidad` varchar(30) DEFAULT NULL,
  `Direccion` varchar(30) DEFAULT NULL,
  `Legajo` varchar(20) NOT NULL

);
/* Crear tabla de materias cursadas y sus notas (una ), y un trigger que evite que se pongan notas de mas de 3 */
drop  table if exists historial_academico;
create table historial_academico (
id int unsigned auto_increment primary key ,
estudiante_id int unsigned ,
asignatura_id int unsigned,
Nota_final int unsigned,
foreign key (estudiante_id) references estudiantes(estudiante_id), 
foreign key (asignatura_id) references asignaturas(asignatura_id)
);
drop table if exists  ingresantes;
create table ingresantes (
Inscripcion_id smallint unsigned auto_increment primary key,
DNI varchar(20),
Apellido varchar(30),
Nombre varchar(30),
Carrera_descr varchar(40),
Instrumento_descr varchar(20),
Direccion varchar(30),
Sexo enum('M','F','X'),
Contacto_num varchar(20)
);
