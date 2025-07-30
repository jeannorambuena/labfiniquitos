-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 26-07-2025 a las 20:03:22
-- Versión del servidor: 8.3.0
-- Versión de PHP: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `labfini`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bitacora`
--

DROP TABLE IF EXISTS `bitacora`;
CREATE TABLE IF NOT EXISTS `bitacora` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `accion` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `fecha` datetime DEFAULT (now()),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cartolaafp`
--

DROP TABLE IF EXISTS `cartolaafp`;
CREATE TABLE IF NOT EXISTS `cartolaafp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `periodo_inicio` date DEFAULT NULL,
  `periodo_fin` date DEFAULT NULL,
  `cotizaciones_pagadas` int DEFAULT NULL,
  `lagunas_previsionales` int DEFAULT NULL,
  `archivo_cartola` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_carga` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `fk_cartolaafp_trabajador` (`trabajador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caso`
--

DROP TABLE IF EXISTS `caso`;
CREATE TABLE IF NOT EXISTS `caso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resumen` text COLLATE utf8mb4_unicode_ci,
  `tipo` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `fk_caso_trabajador` (`trabajador_id`),
  KEY `fk_caso_empleador` (`empleador_id`),
  KEY `idx_caso_fecha_inicio` (`fecha_inicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contrato`
--

DROP TABLE IF EXISTS `contrato`;
CREATE TABLE IF NOT EXISTS `contrato` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_termino` date DEFAULT NULL,
  `tipo_contrato` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cargo` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jornada` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sueldo_base` decimal(15,2) DEFAULT NULL,
  `porcentaje_viaje` decimal(5,2) DEFAULT NULL,
  `bonos` decimal(15,2) DEFAULT NULL,
  `archivo_contrato` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_contrato_trabajador` (`trabajador_id`),
  KEY `fk_contrato_empleador` (`empleador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentogenerado`
--

DROP TABLE IF EXISTS `documentogenerado`;
CREATE TABLE IF NOT EXISTS `documentogenerado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `caso_id` int DEFAULT NULL,
  `tipo_documento` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `archivo` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto_total` decimal(15,2) DEFAULT NULL,
  `fecha_generacion` datetime DEFAULT (now()),
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_documentogenerado_trabajador` (`trabajador_id`),
  KEY `fk_documentogenerado_empleador` (`empleador_id`),
  KEY `fk_documentogenerado_caso` (`caso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleador`
--

DROP TABLE IF EXISTS `empleador`;
CREATE TABLE IF NOT EXISTS `empleador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `razon_social` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rut` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `finiquito`
--

DROP TABLE IF EXISTS `finiquito`;
CREATE TABLE IF NOT EXISTS `finiquito` (
  `id` int NOT NULL AUTO_INCREMENT,
  `documento_generado_id` int DEFAULT NULL,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `caso_id` int DEFAULT NULL,
  `fecha_finiquito` date DEFAULT NULL,
  `fecha_inicio_contrato` date DEFAULT NULL,
  `fecha_termino_contrato` date DEFAULT NULL,
  `tipo_termino` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto_indemnizacion` decimal(15,2) DEFAULT NULL,
  `monto_vacaciones` decimal(15,2) DEFAULT NULL,
  `monto_semanacorrida` decimal(15,2) DEFAULT NULL,
  `monto_multas` decimal(15,2) DEFAULT NULL,
  `monto_total` decimal(15,2) DEFAULT NULL,
  `moneda` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_uf` decimal(15,4) DEFAULT NULL,
  `valor_utm` decimal(15,2) DEFAULT NULL,
  `extra_data` json DEFAULT NULL,
  `estado` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int DEFAULT '1',
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_finiquito_documento` (`documento_generado_id`),
  KEY `fk_finiquito_trabajador` (`trabajador_id`),
  KEY `fk_finiquito_empleador` (`empleador_id`),
  KEY `fk_finiquito_caso` (`caso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `informerevision`
--

DROP TABLE IF EXISTS `informerevision`;
CREATE TABLE IF NOT EXISTS `informerevision` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `contrato_id` int DEFAULT NULL,
  `caso_id` int DEFAULT NULL,
  `resumen_hallazgos` text COLLATE utf8mb4_unicode_ci,
  `monto_reclamo` decimal(15,2) DEFAULT NULL,
  `fecha` datetime DEFAULT (now()),
  `archivo_informe` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_informerevision_trabajador` (`trabajador_id`),
  KEY `fk_informerevision_empleador` (`empleador_id`),
  KEY `fk_informerevision_contrato` (`contrato_id`),
  KEY `fk_informerevision_caso` (`caso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `liquidacion`
--

DROP TABLE IF EXISTS `liquidacion`;
CREATE TABLE IF NOT EXISTS `liquidacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `contrato_id` int DEFAULT NULL,
  `periodo` date DEFAULT NULL,
  `sueldo_imponible` decimal(15,2) DEFAULT NULL,
  `gratificacion` decimal(15,2) DEFAULT NULL,
  `comisiones` decimal(15,2) DEFAULT NULL,
  `bonos` decimal(15,2) DEFAULT NULL,
  `descuentos` decimal(15,2) DEFAULT NULL,
  `semana_corrida` decimal(15,2) DEFAULT NULL,
  `total_pago` decimal(15,2) DEFAULT NULL,
  `archivo_liquidacion` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_carga` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `fk_liquidacion_trabajador` (`trabajador_id`),
  KEY `fk_liquidacion_empleador` (`empleador_id`),
  KEY `idx_liquidacion_contrato` (`contrato_id`),
  KEY `idx_liquidacion_periodo` (`periodo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trabajador`
--

DROP TABLE IF EXISTS `trabajador`;
CREATE TABLE IF NOT EXISTS `trabajador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rut` varchar(12) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellido_paterno` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellido_materno` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut` (`rut`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cartolaafp`
--
ALTER TABLE `cartolaafp`
  ADD CONSTRAINT `fk_cartolaafp_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `caso`
--
ALTER TABLE `caso`
  ADD CONSTRAINT `fk_caso_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_caso_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `contrato`
--
ALTER TABLE `contrato`
  ADD CONSTRAINT `fk_contrato_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_contrato_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `documentogenerado`
--
ALTER TABLE `documentogenerado`
  ADD CONSTRAINT `fk_documentogenerado_caso` FOREIGN KEY (`caso_id`) REFERENCES `caso` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_documentogenerado_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_documentogenerado_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `finiquito`
--
ALTER TABLE `finiquito`
  ADD CONSTRAINT `fk_finiquito_caso` FOREIGN KEY (`caso_id`) REFERENCES `caso` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_finiquito_documento` FOREIGN KEY (`documento_generado_id`) REFERENCES `documentogenerado` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_finiquito_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_finiquito_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `informerevision`
--
ALTER TABLE `informerevision`
  ADD CONSTRAINT `fk_informerevision_caso` FOREIGN KEY (`caso_id`) REFERENCES `caso` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_informerevision_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_informerevision_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_informerevision_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `liquidacion`
--
ALTER TABLE `liquidacion`
  ADD CONSTRAINT `fk_liquidacion_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_liquidacion_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_liquidacion_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
