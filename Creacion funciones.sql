-- CREACION DE FUNCIONES PARA PROYECTO FINAL--
drop function if exists porcentaje_asistencia;
drop function if exists tiempoxestudiante;
use empadb_prueba;

delimiter //
create function porcentaje_asistencia (asistencias int, clases int)
returns float deterministic
begin
declare porcentaje float;
set porcentaje=(asistencias/clases)*100;
return porcentaje;
end; //


delimiter //
create function tiempoxestudiante(estudiantes int, tiempo float) returns numeric(4,2) deterministic
begin
 return tiempo/estudiantes*60;
 end; //

