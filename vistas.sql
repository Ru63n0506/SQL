-- Vista para detalle de consultas
CREATE VIEW v_consultas_detalle AS
SELECT
    c.folio,
    c.fecha,
    c.diagnostico,
    c.peso,
    c.estatura,
    c.presion_arterial,
    c.frecuencia_cardiaca,
    c.frecuencia_respiratoria,
    c.temperatura,
    c.id_paciente,
    CONCAT_WS(' ', pac.nombre, pac.apellido) AS paciente,
    pac.sexo,
    pac.tipo_sangre,
    c.id_personal,
    CONCAT_WS(' ', per.nombre, per.apellido) AS empleado,
    per.cargo,
    per.turno
FROM consultar c
JOIN paciente pac ON c.id_paciente = pac.id
JOIN personal per ON c.id_personal = per.id;

-- Vista para carga de personal
CREATE VIEW v_carga_personal AS
SELECT
    per.id AS id_personal,
    CONCAT_WS(' ', per.nombre, per.apellido) AS personal,
    per.cargo,
    per.turno,
    c.fecha,
    c.folio,
    c.id_paciente
FROM personal per
JOIN consultar c ON per.id = c.id_personal;
