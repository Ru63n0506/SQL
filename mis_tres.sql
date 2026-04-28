-- =========================================================
-- VISTAS
-- =========================================================

-- Vista base para consultas enriquecidas con paciente y personal
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


-- Vista base para consultas con medicamentos recetados
CREATE VIEW v_consultas_medicamentos AS
SELECT
    c.folio,
    c.fecha,
    c.diagnostico,
    c.id_paciente,
    c.id_personal,
    med.id   AS id_medicamento,
    med.nombre AS medicamento
FROM consultar c
LEFT JOIN recetar r   ON c.folio = r.folio
LEFT JOIN medicamento med ON r.id_medicamento = med.id;


-- Vista base de carga de trabajo por personal
CREATE VIEW v_carga_personal AS
SELECT
    per.id                              AS id_personal,
    CONCAT_WS(' ', per.nombre, per.apellido) AS personal,
    per.cargo,
    per.turno,
    c.fecha,
    c.folio,
    c.id_paciente
FROM personal per
JOIN consultar c ON per.id = c.id_personal;


-- =========================================================
-- PROCEDIMIENTOS
-- =========================================================

DELIMITER $$


-- ---------------------------------------------------------
-- 1. Diagnóstico más frecuente entre dos fechas
-- ---------------------------------------------------------
CREATE PROCEDURE sp_diagnostico_mas_frecuente(
    IN p_fecha1 DATE,
    IN p_fecha2 DATE
)
BEGIN
    SELECT
        vm.diagnostico                                          AS Diagnostico,
        COUNT(vm.folio)                                        AS Total_consultas,
        IFNULL(
            GROUP_CONCAT(DISTINCT vm.medicamento SEPARATOR ', '),
            'Sin medicamentos relacionados'
        )                                                      AS Medicamentos_relacionados,
        CASE
            WHEN COUNT(vm.folio) >= 10 THEN 'Muy frecuente'
            WHEN COUNT(vm.folio) BETWEEN 5 AND 9 THEN 'Frecuente'
            ELSE 'Poco frecuente'
        END                                                    AS Nivel_frecuencia
    FROM v_consultas_medicamentos vm
    WHERE vm.fecha BETWEEN p_fecha1 AND p_fecha2
    GROUP BY vm.diagnostico
    HAVING COUNT(vm.folio) > 0
    ORDER BY Total_consultas DESC
    LIMIT 1;
END$$


-- ---------------------------------------------------------
-- 2. Empleado que consultó a un paciente en una fecha
-- ---------------------------------------------------------
CREATE PROCEDURE sp_empleado_por_paciente_fecha(
    IN p_fecha       DATE,
    IN p_nombre_paciente VARCHAR(50)
)
BEGIN
    SELECT
        vd.folio                AS Folio,
        vd.fecha                AS Fecha,
        vd.paciente             AS Paciente,
        vd.empleado             AS Empleado_que_atendio,
        vd.cargo                AS Cargo,
        vd.turno                AS Turno,
        vd.diagnostico          AS Diagnostico
    FROM v_consultas_detalle vd
    WHERE vd.fecha = p_fecha
      AND vd.paciente LIKE CONCAT('%', p_nombre_paciente, '%');
END$$


-- ---------------------------------------------------------
-- 3. Personal con más de n consultas en un rango de fechas
-- ---------------------------------------------------------
CREATE PROCEDURE sp_personal_por_carga(
    IN p_fecha1 DATE,
    IN p_fecha2 DATE,
    IN p_n      INT
)
BEGIN
    SELECT
        vcp.id_personal                             AS Id_personal,
        vcp.personal                                AS Personal,
        vcp.cargo                                   AS Cargo,
        vcp.turno                                   AS Turno,
        COUNT(vcp.folio)                            AS Total_consultas,
        COUNT(DISTINCT vcp.id_paciente)             AS Total_pacientes_atendidos,
        CASE
            WHEN COUNT(vcp.folio) > 15      THEN 'Carga alta'
            WHEN COUNT(vcp.folio) BETWEEN 6
                 AND 15                     THEN 'Carga media'
            ELSE                                 'Carga baja'
        END                                         AS Carga_trabajo
    FROM v_carga_personal vcp
    WHERE vcp.fecha BETWEEN p_fecha1 AND p_fecha2
    GROUP BY
        vcp.id_personal,
        vcp.personal,
        vcp.cargo,
        vcp.turno
    HAVING COUNT(vcp.folio) > p_n
    ORDER BY Total_consultas DESC;
END$$


DELIMITER ;


-- =========================================================
-- EJEMPLOS DE USO
-- =========================================================

CALL sp_diagnostico_mas_frecuente('2025-01-01', '2026-12-31');

CALL sp_empleado_por_paciente_fecha('2025-09-17', 'Natalia');

CALL sp_personal_por_carga('2025-01-01', '2026-12-31', 4);
