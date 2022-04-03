CREATE DATABASE CMSALUD
go
--Seleccionamos dirección a usar
USE CMSALUD
go

--Creación de tablas

CREATE TABLE PACIENTE 
(
	DNI char(8) PRIMARY KEY,
	Nombres varchar(30),
	Apellidos varchar(30),
	Fecha_de_nacimiento datetime,
	Direccion varchar(55),
	Localidad varchar(55),
	Email varchar(40),
	Celular varchar(20),
	Telefono_fijo varchar(20),
);

CREATE TABLE ESPECIALIDADES
(
	Id int identity (1,1) PRIMARY KEY,
	Nombre varchar(40),
);

CREATE TABLE MEDICOS
(
	Id int identity(1,1) PRIMARY KEY,
	DNI char(8),
	Nombre varchar(30),
	Apellido varchar(30),
	Direccion varchar(55),
	Localidad varchar(55),
	Email varchar(40),
	Celular varchar(20),
	Telefono_fijo varchar(20),
	Especialidad_Id int,
	FOREIGN KEY(Especialidad_Id) REFERENCES ESPECIALIDADES(Id),
	);

CREATE TABLE HORARIOS
(
	Id int identity(1,1) PRIMARY KEY,
	Hora_inicio time NOT NULL,
	Hora_fin time NOT NULL,
	Cupos int CHECK (cupos>=1) NOT NULL,
);

CREATE TABLE DIAS
(
	Dia char(10),
	Medico_id int,
	FOREIGN KEY(Medico_id) REFERENCES MEDICOS (Id),
	Horario_id int,
	FOREIGN KEY(Horario_id) REFERENCES HORARIOS(Id),
	PRIMARY KEY (Dia,Medico_id),
);

CREATE TABLE TURNOS
(
	Id int identity(1,1) PRIMARY KEY,
	Paciente_DNI char(8) NOT NULL,
	FOREIGN KEY (Paciente_DNI) REFERENCES PACIENTE(DNI),
	Medico_id int NOT NULL,
	FOREIGN KEY (Medico_id) REFERENCES MEDICOS(Id),
	Urgente bit DEFAULT 0, --1:TURNO URGENTE--0:Normal
	Fecha_programada datetime NOT NULL,
	Fecha_registro datetime DEFAULT GETDATE(),
	Numero_orden int CHECK (Numero_orden>=1)
);

--Ingresando datos en la BD de CMSALUD

--Para ver la estructura de los datos de la tabla ESPECIALIDADES
	exec sp_columns DIAS;

--Ingreso de datos de las Especialidades
	insert into ESPECIALIDADES (Nombre)
		values('Nutricion');
	insert into ESPECIALIDADES (Nombre)
		values('Medico_general');
	insert into ESPECIALIDADES (Nombre)
		values('Traumatologia');
	insert into ESPECIALIDADES (Nombre)
		values('Odontologia');

DELETE FROM ESPECIALIDADES
		
--Vemos tabla
select *from TURNOS	

--Ingreso de datos de los Médicos
	insert into MEDICOS (DNI,Nombre,Apellido,Direccion,Localidad,Email,Celular,Telefono_fijo,Especialidad_Id)
		values ('12345678','María Mar','Garnica','Florida 001','CABA','mar@gmail.com','1538996547','49876543','13');
	insert into MEDICOS (DNI,Nombre,Apellido,Direccion,Localidad,Email,Celular,Telefono_fijo,Especialidad_Id)
		values ('12345688','Solange','Flores','Gurruchaga 123','CABA','solflores@outlook.es','1502448798','46543210','14');
	insert into MEDICOS (DNI,Nombre,Apellido,Direccion,Localidad,Email,Celular,Telefono_fijo,Especialidad_Id)
		values ('12345698','Rose','Paz','Camargo 656','CABA','paz.ros@gmail.com.ar','1512345587','43216549','15');
	insert into MEDICOS (DNI,Nombre,Apellido,Direccion,Localidad,Email,Celular,Telefono_fijo,Especialidad_Id)
		values ('12345619','Mario','Garcia','Juan B.Justo 987','CABA','mario@live.com','1522356598','49874102','16');

--Ingreso de datos de los Horarios disponibles para turnos
	insert into HORARIOS(Hora_inicio,Hora_fin,Cupos)
		values('11:00','17:00','12');
	insert into HORARIOS(Hora_inicio,Hora_fin,Cupos)
		values('10:00','19:00','18');
	insert into HORARIOS(Hora_inicio,Hora_fin,Cupos)
		values('10:00','15:00','10');
	insert into HORARIOS(Hora_inicio,Hora_fin,Cupos)
		values('09:00','15:00','12');
	
--Ingreso de datos de Días disponibles para asignar turnos
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Lunes','1','1');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Miercoles','1','1');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Martes','2','3');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Jueves','2','3');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Lunes','3','4');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Martes','3','4');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Miercoles','3','4');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Martes','4','5');
	insert into DIAS(Dia, Medico_id, Horario_id)
		values('Viernes','4','5');

--Ingreso de datos del Paciente
	insert into PACIENTE(DNI,Nombres,Apellidos,Fecha_de_nacimiento,Direccion,Localidad,Email,Celular,Telefono_fijo)
		values ('98765485','Roberto','Albarez','02/02/84','Sarandí 000','CABA','al.ro@gmail.ar','1598765425','40908070');
	insert into PACIENTE(DNI,Nombres,Apellidos,Fecha_de_nacimiento,Direccion,Localidad,Email,Celular,Telefono_fijo)
		values ('87654321','Mariela','Cervantes','05/06/85','Maipú 987000','CABA','marce@hotmail.com.ar','1500223344','40001112');
	insert into PACIENTE(DNI,Nombres,Apellidos,Fecha_de_nacimiento,Direccion,Localidad,Email,Celular,Telefono_fijo)
		values ('76543210','Claudia','Blanco','25/12/90','Florida 00300','CABA','Blan_Claudia251290@gmail.com','1501020304','40876054');
	insert into PACIENTE(DNI,Nombres,Apellidos,Fecha_de_nacimiento,Direccion,Localidad,Email,Celular,Telefono_fijo)
		values ('65432109','Manuel','Santillan','18/8/88','Milanes 002','CABA','ManuSan88@outlook.com','1511223344','40321065');

--Ingreso de datos del Turno solicitado por el paciente
	insert into TURNOS(Paciente_DNI,Medico_id,Urgente,Fecha_programada,Numero_orden)
		values ('98765485','4','0','22/03/22','1');
	insert into TURNOS(Paciente_DNI,Medico_id,Urgente,Fecha_programada,Numero_orden)
		values ('87654321','2','1','24/3/22','2');
	insert into TURNOS(Paciente_DNI,Medico_id,Urgente,Fecha_programada,Numero_orden)
		values ('76543210','3','0','13/04/22','3');
	insert into TURNOS(Paciente_DNI,Medico_id,Urgente,Fecha_programada,Numero_orden)
		values ('65432109','1','0','20/4/22','4');