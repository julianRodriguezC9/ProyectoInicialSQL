use empadb_prueba;
drop trigger if exists bitacora_matriculas;
drop trigger if exists bitacora_delete;
drop trigger if exists matricula_valida;
drop trigger if exists replica_rol;
drop trigger if exists replica_estudiantes;

/* Trigger para guardar info de las asignaturas que cursó */
create trigger bitacora_matriculas before delete on personas
for each row
insert into bitacora_matriculas (matricula_id,estudiante_id,asignatura_id,comision_id,asignatura,carrera)
select mm.matricula_id,DNI,mm.asignatura_id,mm.comision_id,aa.descripcion as asignaturas, cc.descripcion as carrera
from personas
left join estudiantes ee on dni=estudiante_id 
left join matriculas_asignaturas mm on ee.estudiante_id=mm.estudiante_id
left join asignaturas aa on mm.asignatura_id=aa.asignatura_id 
left join carreras cc on aa.carrera_id=cc.carrera_id 
where ee.estudiante_id=old.dni;

/* Trigger para guardar info de la persona*/
create trigger bitacora_delete before delete on personas
for each row 
insert into bitacora_eliminacion (DNI,Apellido,nombre,provincia,localidad,direccion,legajo) values
(old.dni,old.apellido,old.nombre,old.provincia,old.localidad,old.direccion,old.legajo)
;


/* Trigger para no poder ingresar una matricula asig si en historial_academico hay una con nota superior o igual a 4 */
delimiter //
create trigger matricula_valida before insert on matriculas_asignaturas for each row
begin
if exists (select nota_final from historial_academico 
where (estudiante_id=new.estudiante_id) and (nota_final>=4) and (asignatura_id=new.asignatura_id)) then
	signal sqlstate '45000'
	set message_text="Asignatura ya cursada y aprobada" ;
	end if;
if not exists (select comision_id,asignatura_id from comisiones 
where (asignatura_id=new.asignatura_id and comision_id=new.comision_id)) then
    signal sqlstate '45000'
	set message_text="La comision no corresponde a la asignatura solicitada" ;
	end if;
    
    
end; //


/* Trigger que al ingresar un estudiante mande a roles un registro con su rol*/
create trigger replica_rol after insert on ingresantes
for each row
insert into roles (ID,rol_profesor,rol_estudiante,rol_admin) values (new.DNI,0,1,0); //

/*Trigger para replica est */
create trigger replica_estudiantes after insert on roles for each row
insert into estudiantes (estudiante_id) values (new.ID); //

