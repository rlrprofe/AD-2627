-- ===========================================================
-- UT2.4 - Transacciones (MySQL/InnoDB)
-- Script de preparación de datos para pruebas del tema 2.4
-- Crea BD, tabla y datos iniciales. Idempotente.
-- ===========================================================

-- 1) Base de datos de trabajo
CREATE DATABASE IF NOT EXISTS empresa
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE empresa;

-- 2) Tabla de cuentas (InnoDB para soporte transaccional)
--    Nota: El CHECK(saldo >= 0) se aplica en MySQL >= 8.0.16.
--    En versiones antiguas se ignora; por eso añadimos triggers
--    para reforzar la regla de negocio.
CREATE TABLE IF NOT EXISTS cuentas (
  id             INT          NOT NULL,
  titular        VARCHAR(80)  NOT NULL,
  saldo          DECIMAL(12,2) NOT NULL,
  fecha_apertura DATE         NOT NULL DEFAULT (CURRENT_DATE),
  CONSTRAINT pk_cuentas PRIMARY KEY (id),
  CONSTRAINT chk_saldo_nonneg CHECK (saldo >= 0)
) ENGINE=InnoDB;

-- 3) Triggers de seguridad (evitan saldo negativo en INSERT/UPDATE)
--    Se eliminan y recrean para que el script sea relanzable.
DROP TRIGGER IF EXISTS empresa.cuentas_no_negativo_ins;
DROP TRIGGER IF EXISTS empresa.cuentas_no_negativo_upd;

DELIMITER //

CREATE TRIGGER cuentas_no_negativo_ins
BEFORE INSERT ON cuentas
FOR EACH ROW
BEGIN
  IF NEW.saldo < 0 THEN
    SIGNAL SQLSTATE '45000' -- 45000 porque es el código estándar para errores personalizados; es claro, portable y seguro
      SET MESSAGE_TEXT = 'Saldo no puede ser negativo (INSERT).';
  END IF;
END;
//

CREATE TRIGGER cuentas_no_negativo_upd
BEFORE UPDATE ON cuentas
FOR EACH ROW
BEGIN
  IF NEW.saldo < 0 THEN
    SIGNAL SQLSTATE '45000' -- 45000 porque es el código estándar para errores personalizados; es claro, portable y seguro
      SET MESSAGE_TEXT = 'Saldo no puede ser negativo (UPDATE).';
  END IF;
END;
//

DELIMITER ;

-- 4) Datos iniciales (idempotentes). Si ya existen, se reponen saldos.
INSERT INTO cuentas (id, titular, saldo, fecha_apertura)
VALUES
  (1, 'Cuenta Origen', 1000.00, CURRENT_DATE),
  (2, 'Cuenta Destino',  500.00, CURRENT_DATE),
  (3, 'Cuenta Auxiliar', 750.00, CURRENT_DATE)
ON DUPLICATE KEY UPDATE
  titular = VALUES(titular),
  saldo   = VALUES(saldo),
  fecha_apertura = VALUES(fecha_apertura);

-- 5) Verificación rápida
SELECT id, titular, saldo FROM cuentas ORDER BY id;


-- -----------------------------------------------------------------------
-- Creación de tablas necesarias para ejemplo de SavePoint del tema 2.4
-- -----------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS pedidos (
  id      INT PRIMARY KEY,
  estado  VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS albaranes (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido   INT NOT NULL,
  fecha       DATETIME NOT NULL,
  CONSTRAINT fk_alb_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id)
) ENGINE=InnoDB;

-- Insertamos datos
INSERT INTO pedidos (id, estado) VALUES (1001, 'PENDIENTE')
ON DUPLICATE KEY UPDATE estado=VALUES(estado); -- Si no existe el id=1001, lo inserta; si ya existe, lo actualiza a 'PENDIENTE'.
												-- estado= VALUES (estado)=> values(estado) usa el valor que tiene en la parte del insert

select * from pedidos;                                                
select * from albaranes;
