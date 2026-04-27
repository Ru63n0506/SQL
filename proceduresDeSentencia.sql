use clinica;

/* Diagnóstico más frecuente entre fecha1 y fecha2 */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';

select 
    consultar.diagnostico as Diagnostico,
    count(consultar.folio) as Total_consultas,
    ifnull(
        group_concat(distinct medicamento.nombre separator ', '),
        'Sin medicamentos relacionados'
    ) as Medicamentos_relacionados,
    case
        when count(consultar.folio) >= 10 then 'Muy frecuente'
        when count(consultar.folio) between 5 and 9 then 'Frecuente'
        else 'Poco frecuente'
    end as Nivel_frecuencia
from consultar
left join recetar 
    on consultar.folio = recetar.folio
left join medicamento 
    on recetar.id_medicamento = medicamento.id
where consultar.fecha between @fecha1 and @fecha2
group by consultar.diagnostico
having count(consultar.folio) > 0
order by total_consultas desc
limit 1;


/* Personal que atendió más de n consultas */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';
set @n = 4;

select 
    personal.id as Id_personal,
    concat_ws(' ', personal.nombre, personal.apellido) as Personal,
    personal.cargo as Cargo,
    personal.turno as Turno,
    count(consultar.folio) as Total_consultas,
    count(distinct consultar.id_paciente) as Total_pacientes_atendidos,
    case
        when count(consultar.folio) > 15 then 'Carga alta'
        when count(consultar.folio) between 6 and 15 then 'Carga media'
        else 'Carga baja'
    end as Carga_trabajo
from personal
join consultar 
    on personal.id = consultar.id_personal
where consultar.fecha between @fecha1 and @fecha2
group by 
    personal.id,
    personal.nombre,
    personal.apellido,
    personal.cargo,
    personal.turno
having count(consultar.folio) > @n
order by total_consultas desc;


/* Medicamentos no recetados entre fecha1 y fecha2 */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';
set @stock_minimo = 10;

select 
    medicamento.id as Id_medicamento,
    medicamento.nombre as Medicamento,
    medicamento.gramaje as Gramaje,
    medicamento.cantidad as Stock_actual,
    ifnull(
        group_concat(distinct proveedor.nombre separator ', '),
        'Sin proveedor registrado'
    ) as Proveedor,
    case
        when medicamento.cantidad = 0 then 'Agotado'
        when medicamento.cantidad < @stock_minimo then 'Stock bajo'
        else 'Stock suficiente'
    end as Estado_stock
from medicamento
left join surte 
    on medicamento.id = surte.id_medicamento
left join proveedor 
    on surte.id_proveedor = proveedor.id
where not exists (
    select 1
    from recetar
    join consultar 
        on recetar.folio = consultar.folio
    where recetar.id_medicamento = medicamento.id
    and consultar.fecha between @fecha1 and @fecha2
)
group by 
    medicamento.id,
    medicamento.nombre,
    medicamento.gramaje,
    medicamento.cantidad
order by medicamento.cantidad desc;


/* Pacientes atendidos más de n veces */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';
set @n = 1;

select 
    paciente.id as Id_paciente,
    concat_ws(' ', paciente.nombre, paciente.apellido) as Paciente,
    paciente.sexo as Sexo,
    paciente.tipo_sangre as Tipo_sangre,
    count(consultar.folio) as Total_consultas,
    group_concat(
        consultar.fecha 
        order by consultar.fecha 
        separator ', '
    ) as Fechas_consultas,
    group_concat(
        distinct consultar.diagnostico 
        separator ', '
    ) as Diagnosticos_registrados
from paciente
join consultar 
    on paciente.id = consultar.id_paciente
where consultar.fecha between @fecha1 and @fecha2
group by 
    paciente.id,
    paciente.nombre,
    paciente.apellido,
    paciente.sexo,
    paciente.tipo_sangre
having count(consultar.folio) > @n
order by total_consultas desc;

/* Medicamentos con mayor volumen de prescripción por diagnóstico */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';

select 
    consultar.diagnostico as Diagnostico,
    medicamento.nombre as Medicamento,
    medicamento.gramaje as Gramaje,
    sum(recetar.cantidad) as Total_recetado,
    count(recetar.folio) as Veces_recetado,
    max(medicamento.precio) as Precio_maximo,
    min(medicamento.precio) as Precio_minimo,
    avg(medicamento.precio) as Precio_promedio,
    sum(recetar.cantidad * medicamento.precio) as Valor_total_recetado,
    case
        when sum(recetar.cantidad) >= 20 then 'Alta demanda'
        when sum(recetar.cantidad) between 10 and 19 then 'Demanda media'
        else 'Baja demanda'
    end as Nivel_demanda
from consultar
join recetar using(folio)
join medicamento 
    on recetar.id_medicamento = medicamento.id
where consultar.fecha between @fecha1 and @fecha2
group by 
    consultar.diagnostico,
    medicamento.id,
    medicamento.nombre,
    medicamento.gramaje
having sum(recetar.cantidad) > 0
order by total_recetado desc;


/* Proveedores que surtieron medicamentos recetados y superan n pesos */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';
set @monto_minimo = 500;

select 
    proveedor.id as Id_proveedor,
    proveedor.nombre as Proveedor,
    proveedor.contacto as Contacto,
    ifnull(
        group_concat(distinct medicamento.nombre separator ', '),
        'Sin medicamentos'
    ) as Medicamentos_recetados,
    count(distinct consultar.folio) as Total_consultas_relacionadas,
    sum(recetar.cantidad * medicamento.precio) as Valor_total_recetado
from proveedor
join (
    select distinct id_proveedor, id_medicamento
    from surte
) as Surtidos_unicos
    on proveedor.id = surtidos_unicos.id_proveedor
join medicamento 
    on surtidos_unicos.id_medicamento = medicamento.id
join recetar 
    on medicamento.id = recetar.id_medicamento
join consultar 
    on recetar.folio = consultar.folio
where consultar.fecha between @fecha1 and @fecha2
group by 
    proveedor.id,
    proveedor.nombre,
    proveedor.contacto
having sum(recetar.cantidad * medicamento.precio) > @monto_minimo
order by Valor_total_recetado desc;

/* Medicamentos con existencia menor a n unidades */

set @stock_minimo = 100;

select 
    medicamento.id as Id_medicamento,
    medicamento.nombre as Medicamento,
    medicamento.gramaje as Gramaje,
    medicamento.cantidad as Stock_actual,

    ifnull(
        group_concat(distinct proveedor.nombre separator ', '),
        'Sin proveedor'
    ) as Proveedor,

    if(
        medicamento.cantidad < @stock_minimo,
        @stock_minimo - medicamento.cantidad,
        0
    ) as Cantidad_recomendada_reponer,

    case
        when medicamento.cantidad = 0 then 'Agotado'
        when medicamento.cantidad < @stock_minimo then 'Stock bajo'
        else 'Stock suficiente'
    end as Estado_stock

from medicamento
left join surte 
    on medicamento.id = surte.id_medicamento
left join proveedor 
    on proveedor.id = surte.id_proveedor

where medicamento.cantidad < @stock_minimo

group by 
    medicamento.id,
    medicamento.nombre,
    medicamento.gramaje,
    medicamento.cantidad

order by medicamento.cantidad asc;


/* Cuartos disponibles actualmente */

select 
    cuarto.numero as Numero_cuarto,
    cuarto.tipo as Tipo_cuarto,
    cuarto.capacidad as Capacidad,

    ifnull(count(distinct ocupar.id_paciente), 0) as Pacientes_ocupando,

    cuarto.capacidad - ifnull(count(distinct ocupar.id_paciente), 0) as Espacios_disponibles,

    ifnull(
        group_concat(
            distinct concat(mobiliario.nombre, ' x', mobiliario_cuarto.cantidad)
            separator ', '
        ),
        'Sin mobiliario registrado'
    ) as Mobiliario,

    case
        when cuarto.capacidad - ifnull(count(distinct ocupar.id_paciente), 0) > 0 
        then 'Disponible'
        else 'Ocupado'
    end as Estado_cuarto

from cuarto
left join ocupar 
    on cuarto.numero = ocupar.id_cuarto
    and curdate() between ocupar.fecha_inicio and ifnull(ocupar.fecha_fin, curdate())
left join mobiliario_cuarto 
    on cuarto.numero = mobiliario_cuarto.numero_cuarto
left join mobiliario 
    on mobiliario_cuarto.id_mobiliario = mobiliario.id

group by 
    cuarto.numero,
    cuarto.tipo,
    cuarto.capacidad

having espacios_disponibles > 0

order by cuarto.numero;


/* Reporte de ganancias por año */

set @fecha1 = '2025-01-01';
set @fecha2 = '2026-12-31';

select 
    year(consultar.fecha) as `Año`,

    sum(recetar.cantidad * medicamento.precio) as Ingresos,

    sum(recetar.cantidad * ifnull(compras.precio_promedio_compra, 0)) as Costo_estimado,

    sum(recetar.cantidad * medicamento.precio) 
    - sum(recetar.cantidad * ifnull(compras.precio_promedio_compra, 0)) as Ganancia,

    case
        when sum(recetar.cantidad * medicamento.precio) 
             - sum(recetar.cantidad * ifnull(compras.precio_promedio_compra, 0)) > 0
        then 'Ganancia'

        when sum(recetar.cantidad * medicamento.precio) 
             - sum(recetar.cantidad * ifnull(compras.precio_promedio_compra, 0)) = 0
        then 'Sin ganancia'

        else 'Pérdida'
    end as Resultado

from consultar
join recetar 
    on consultar.folio = recetar.folio
join medicamento 
    on recetar.id_medicamento = medicamento.id
left join (
    select 
        id_medicamento,
        avg(precio_compra) as precio_promedio_compra
    from surte
    group by id_medicamento
) as compras
    on medicamento.id = compras.id_medicamento

where consultar.fecha between @fecha1 and @fecha2

group by year(consultar.fecha)

order by `Año`;


/* Buscar qué mobiliario está en qué cuarto */

set @mobiliario = 'Cama';

select 
    mobiliario.nombre as Mobiliario,
    cuarto.numero as Numero_cuarto,
    cuarto.tipo as Tipo_cuarto,
    cuarto.capacidad as Capacidad,
    mobiliario_cuarto.cantidad as Cantidad

from mobiliario
join mobiliario_cuarto 
    on mobiliario.id = mobiliario_cuarto.id_mobiliario
join cuarto 
    on mobiliario_cuarto.numero_cuarto = cuarto.numero

where mobiliario.nombre like concat('%', @mobiliario, '%')

group by 
    mobiliario.nombre,
    cuarto.numero,
    cuarto.tipo,
    cuarto.capacidad,
    mobiliario_cuarto.cantidad

order by cuarto.numero;


/* Qué empleado consultó a un paciente en una fecha */

set @fecha_busqueda = '2025-09-17';
set @nombre_paciente = 'Natalia';

select 
    consultar.folio as Folio,
    consultar.fecha as Fecha,

    concat_ws(' ', paciente.nombre, paciente.apellido) as Paciente,

    concat_ws(' ', personal.nombre, personal.apellido) as Empleado_que_atendio,
    personal.cargo as Cargo,
    personal.turno as Turno,

    consultar.diagnostico as Diagnostico

from consultar
join paciente 
    on consultar.id_paciente = paciente.id
join personal 
    on consultar.id_personal = personal.id

where consultar.fecha = @fecha_busqueda
and concat_ws(' ', paciente.nombre, paciente.apellido) like concat('%', @nombre_paciente, '%');


/* Consultas aumentaron o disminuyeron por año */

select 
    datos.`Año`,
    datos.consultas_del_año,

    ifnull(datos.consultas_año_anterior, 0) as Consultas_año_anterior,

    case
        when datos.consultas_año_anterior is null then 'Sin año anterior'
        when datos.consultas_del_año > datos.consultas_año_anterior then 'Aumentó'
        when datos.consultas_del_año < datos.consultas_año_anterior then 'Disminuyó'
        else 'Igual'
    end as Comportamiento

from (
    select 
        year(fecha) as `Año`,
        count(*) as Consultas_del_año,
        lag(count(*)) over (order by year(fecha)) as Consultas_año_anterior
    from consultar
    group by year(fecha)
) as Datos

order by Datos.`Año`;


/* Saber con qué proveedor conviene comprar */

select 
    medicamento.nombre as Medicamento,
    medicamento.gramaje as Gramaje,
    proveedor.nombre as Proveedor,
    surte.precio_compra as Precio_compra,

    case
        when surte.precio_compra = (
            select min(s2.precio_compra)
            from surte s2
            where s2.id_medicamento = medicamento.id
        ) then 'Proveedor más conveniente'
        else 'Proveedor normal'
    end as Recomendacion

from medicamento
join surte 
    on medicamento.id = surte.id_medicamento
join proveedor 
    on proveedor.id = surte.id_proveedor

where surte.precio_compra = (
    select min(s2.precio_compra)
    from surte s2
    where s2.id_medicamento = medicamento.id
)

group by 
    medicamento.id,
    medicamento.nombre,
    medicamento.gramaje,
    proveedor.nombre,
    surte.precio_compra

order by medicamento.nombre, surte.precio_compra;


/* Historial completo de un paciente */

set @id_paciente = 164;

select 
    paciente.id as Id_paciente,
    concat_ws(' ', paciente.nombre, paciente.apellido) as Paciente,
    paciente.sexo as Sexo,
    paciente.fecha_nac as Fecha_nacimiento,
    paciente.tipo_sangre as Tipo_sangre,

    consultar.folio as Folio,
    consultar.fecha as Fecha_consulta,
    consultar.peso as Peso,
    consultar.estatura as Estatura,
    consultar.presion_arterial as Presion_arterial,
    consultar.frecuencia_cardiaca as Frecuencia_cardiaca,
    consultar.frecuencia_respiratoria as Frecuencia_respiratoria,
    consultar.temperatura as Temperatura,
    consultar.diagnostico as Diagnostico,

    concat_ws(' ', personal.nombre, personal.apellido) as Atendido_por,
    personal.cargo as Cargo,

    ifnull(
        group_concat(
            concat(medicamento.nombre, ' ', medicamento.gramaje, ' Cantidad: ', recetar.cantidad)
            separator ', '
        ),
        'Sin medicamentos'
    ) as Medicamentos_recetados

from paciente
join consultar 
    on paciente.id = consultar.id_paciente
join personal 
    on consultar.id_personal = personal.id
left join recetar 
    on consultar.folio = recetar.folio
left join medicamento 
    on recetar.id_medicamento = medicamento.id

where paciente.id = @id_paciente

group by 
    paciente.id,
    paciente.nombre,
    paciente.apellido,
    paciente.sexo,
    paciente.fecha_nac,
    paciente.tipo_sangre,
    consultar.folio,
    consultar.fecha,
    consultar.peso,
    consultar.estatura,
    consultar.presion_arterial,
    consultar.frecuencia_cardiaca,
    consultar.frecuencia_respiratoria,
    consultar.temperatura,
    consultar.diagnostico,
    personal.nombre,
    personal.apellido,
    personal.cargo

order by consultar.fecha desc;