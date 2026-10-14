CREATE DATABASE IF NOT EXISTS ut3_componentes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ut3_componentes;

CREATE TABLE IF NOT EXISTS productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);
