use empadb_prueba;
drop procedure if exists usos_aulas2;
drop procedure if exists busqueda_alumno;
drop procedure if exists horarios_aulas;
drop procedure if exists asistencias;
-- CREACION STORED PROCEDURES --
-- Procedimiento de busqueda de un alumno y que asignaturas tiene--

delimiter //
create procedure busqueda_alumno(dni_busqueda int)
begin
select nombre,apellido,dni,asignaturas.descripcion from personas
left join estudiantes on dni=estudiante_id 
left join matriculas on estudiantes.estudiante_id=matriculas.estudiante_id 
left join asignaturas on matriculas.asignatura_id=asignaturas.asignatura_id where dni=dni_busqueda; 

end//

delimiter //
create procedure usos_aulas2( aula smallint)

begin
select comisiones.comision_id,asignaturas.descripcion,horarios.descripcion,num_aula ,
     count(estudiantes.estudiante_id) as cantidad 
	from estudiantes
	left join matriculas_asignaturas matr 
	on estudiantes.estudiante_id=matr.estudiante_id 
	left join asignaturas on matr.asignatura_id=asignaturas.asignatura_id
	left join comisiones on asignaturas.asignatura_id=comisiones.asignatura_id
	left join horarios on comisiones.horario=horarios.horario_id where num_aula=aula
	group by comisiones.comision_id  order by cantidad ;

end//


delimiter //
create procedure horarios_aulas( aula smallint)

begin
select cc.comision_id, cc.descripcion as asignatura ,hh.descripcion as horario from asignaturas aa 
left join comisiones cc on aa.asignatura_id=cc.asignatura_id 
left join horarios hh on cc.horario= hh.horario_id where num_aula=aula;
end//

call horarios_aulas(13);

delimiter //
create procedure asistencias()
begin
select nombre,apellido,dni,
porcentaje_asistencia(sum(asistencia),count(estudiante_id)) as asistencia from personas
left join asistencia on dni=estudiante_id  where dni=estudiante_id group by dni;
end;
//