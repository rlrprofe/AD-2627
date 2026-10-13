-- ============================================================
--  SCRIPT SOBRE LA BASE DE DATOS "curso"
-- ============================================================
--  Autor: Ruth Lospitao
--  Módulo: Acceso a Datos (JDBC)
--  Descripción: define los procedimientos almacenados necesarios para los proyectos JDBC de ejemplo.
-- ============================================================



USE curso;

USE curso;

-- Los usuarios y permisos se configuran fuera de este script.

-- ============================================================
-- 3️⃣ TABLA LOG_ACCIONES
-- ============================================================

DROP TABLE IF EXISTS log_acciones;

CREATE TABLE log_acciones (
  ID INT AUTO_INCREMENT PRIMARY KEY,
  ACCION VARCHAR(200) NOT NULL,
  FECHA TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4️⃣ PROCEDIMIENTOS ALMACENADOS
-- ============================================================

-- Aumentar salario según departamento
DROP PROCEDURE IF EXISTS aumentarSalario;
DELIMITER //
CREATE PROCEDURE aumentarSalario(IN p_dep INT, IN p_porcentaje DECIMAL(5,2))
BEGIN
  UPDATE empleados
  SET salario = salario * (1 + p_porcentaje / 100)
  WHERE dep_no = p_dep;

  INSERT INTO log_acciones (ACCION)
  VALUES (CONCAT('Aumento de salario del ', p_porcentaje, '% en departamento ', p_dep));
END //
DELIMITER ;

-- Contar total de empleados
DROP PROCEDURE IF EXISTS contarEmpleados;
DELIMITER //
CREATE PROCEDURE contarEmpleados(OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM empleados;
END //
DELIMITER ;

-- Doblar número (ejemplo INOUT)
DROP PROCEDURE IF EXISTS doblarNumero;
DELIMITER //
CREATE PROCEDURE doblarNumero(INOUT valor INT)
BEGIN
  SET valor = valor * 2;
END //
DELIMITER ;

-- Calcular salario anual
-- Recibe un salario mensual (p_salario) y devuelve el salario anual (multiplica por 12).
DELIMITER //
CREATE FUNCTION calcularSalarioAnual(p_salario DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
  RETURN p_salario * 12;
END //
DELIMITER ;

-- Obtener salario medio de un dpto
DELIMITER //
CREATE FUNCTION salarioMedioDepartamento(p_dep INT)
RETURNS DECIMAL(10,2)
NOT DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE media DECIMAL(10,2);
  SELECT AVG(salario) INTO media FROM empleados WHERE dep_no = p_dep;
  RETURN IFNULL(media, 0);
END //
DELIMITER ;



-- ============================================================
-- 5️⃣ COMPROBACIÓN
-- ============================================================

-- Probar que la conexión y datos funcionan
SELECT * FROM empleados;
CALL contarEmpleados(@total);
SELECT @total AS 'Total de empleados';
