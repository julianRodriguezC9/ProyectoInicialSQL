use empadb_prueba;
create view estudiantes_matriculados as (
select legajo,nombre,apellido,asig.descripcion as asignatura from personas pers 
left join estudiantes est on pers.DNI=est.estudiante_id
left join matriculas_asignaturas matric on est.estudiante_id=matric.estudiante_id
left join asignaturas asig on matric.asignatura_id=asig.asignatura_id where pers.DNI=est.estudiante_id);

create view asistencias as (
select legajo,nombre,apellido,comis.comision_id,asig.descripcion as asignatura, aa.fecha,aa.asistencia from personas pers 
left join estudiantes est on pers.DNI=est.estudiante_id
left join matriculas_asignaturas matric on est.estudiante_id=matric.estudiante_id
left join asignaturas asig on matric.asignatura_id=asig.asignatura_id
left join comisiones comis on asig.asignatura_id=comis.asignatura_id 
left join clases on comis.comision_id=clases.comision_id
left join asistencia aa on clases.clase_id=aa.clase_id where (pers.DNI=est.estudiante_id));




create view profesores_cv as
(select pp.legajo,nombre,apellido,usuario ,cv.permiso  from personas pp
left join profesores prof on pp.dni=prof.profesor_id
left join usuarios_cv cv on prof.profesor_id =cv.dni where pp.dni=prof.profesor_id) ;

create view administrativos_cv as (
select pp.legajo,nombre,apellido,usuario ,cv.permiso from personas pp 
left join usuarios_cv cv on pp.dni=cv.dni
left join administrativos aa on aa.admin_id=pp.dni 
where aa.admin_id=pp.dni )

