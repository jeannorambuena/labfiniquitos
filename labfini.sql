-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 25-08-2025 a las 15:30:05
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
  `archivo_cartola` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `codigo` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `estado` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `resumen` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre_caso` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_cierre` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `fk_caso_trabajador` (`trabajador_id`),
  KEY `fk_caso_empleador` (`empleador_id`),
  KEY `idx_caso_fecha_inicio` (`fecha_inicio`),
  KEY `idx_caso_codigo` (`codigo`),
  KEY `idx_caso_estado` (`estado`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `caso`
--

INSERT INTO `caso` (`id`, `codigo`, `trabajador_id`, `empleador_id`, `fecha_inicio`, `estado`, `resumen`, `tipo`, `nombre_caso`, `fecha_creacion`, `fecha_cierre`) VALUES
(1, '30687de8-8038-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'E2E final', '', 'Norambuena/Mariela Farias Leyton - 30687de8-8038-11f0-8046-005056c00001', NULL, NULL),
(2, '38cd3188-8039-11f0-8046-005056c00001', 4, 2, NULL, 'Recolección documental', 'Prueba 2 E2E', '', 'Leyton /Alfredo Norambuena Cerda SPA - 38cd3188-8039-11f0-8046-005056c00001', NULL, NULL),
(3, 'b43a2cea-803d-11f0-8046-005056c00001', 4, 1, NULL, 'Recolección documental', 'E2E prueba final 12:24', '', 'Leyton /Mariela Farias Leyton - b43a2cea-803d-11f0-8046-005056c00001', NULL, NULL),
(4, '2b631596-8042-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e final 12:56', '', 'Norambuena/Mariela Farias Leyton - 2b631596-8042-11f0-8046-005056c00001', NULL, NULL),
(5, '85a3a943-811b-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba e2e para casos.', '', 'Norambuena/Mariela Farias Leyton - 85a3a943-811b-11f0-8046-005056c00001', NULL, NULL),
(6, 'b501eeb2-8126-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'E2E final 24/08/25 16:12', '', 'Norambuena/Mariela Farias Leyton - b501eeb2-8126-11f0-8046-005056c00001', NULL, NULL),
(7, '5cfaaaa0-813b-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'E2E final 18:40', '', 'Norambuena/Mariela Farias Leyton - 5cfaaaa0-813b-11f0-8046-005056c00001', NULL, NULL),
(8, '97304019-813c-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e', '', 'Norambuena/Mariela Farias Leyton - 97304019-813c-11f0-8046-005056c00001', NULL, NULL),
(9, 'df7d3e94-813e-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e', '', 'Norambuena/Mariela Farias Leyton - df7d3e94-813e-11f0-8046-005056c00001', NULL, NULL),
(10, '55109920-8140-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e final', '', 'Norambuena/Mariela Farias Leyton - 55109920-8140-11f0-8046-005056c00001', NULL, NULL),
(11, '5c7734e3-815f-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'Historia completa del tranajador', NULL, 'Norambuena/Mariela Farias Leyton - 5c7734e3-815f-11f0-8046-005056c00001', NULL, NULL);

--
-- Disparadores `caso`
--
DROP TRIGGER IF EXISTS `trg_caso_nombre_default`;
DELIMITER $$
CREATE TRIGGER `trg_caso_nombre_default` BEFORE INSERT ON `caso` FOR EACH ROW BEGIN
  IF NEW.codigo IS NULL OR NEW.codigo = '' THEN
    SET NEW.codigo = UUID();
  END IF;
  IF NEW.nombre_caso IS NULL OR NEW.nombre_caso = '' THEN
    SET NEW.nombre_caso = CONCAT(
      (SELECT COALESCE(t.apellido_paterno,'') FROM trabajador t WHERE t.id = NEW.trabajador_id),
      '/',
      (SELECT COALESCE(e.razon_social,'')   FROM empleador  e WHERE e.id = NEW.empleador_id),
      ' - ', NEW.codigo
    );
  END IF;
END
$$
DELIMITER ;

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
  `tipo_contrato` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cargo` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `jornada` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sueldo_base` decimal(15,2) DEFAULT NULL,
  `porcentaje_viaje` decimal(5,2) DEFAULT NULL,
  `bonos` decimal(15,2) DEFAULT NULL,
  `archivo_contrato` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `tipo_documento` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `destinatario` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `archivo` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto_total` decimal(15,2) DEFAULT NULL,
  `fecha_generacion` datetime DEFAULT (now()),
  `estado` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version` int DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_documentogenerado_trabajador` (`trabajador_id`),
  KEY `fk_documentogenerado_empleador` (`empleador_id`),
  KEY `fk_documentogenerado_caso` (`caso_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento_fuente`
--

DROP TABLE IF EXISTS `documento_fuente`;
CREATE TABLE IF NOT EXISTS `documento_fuente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trabajador_id` int DEFAULT NULL,
  `empleador_id` int DEFAULT NULL,
  `contrato_id` int DEFAULT NULL,
  `caso_id` int DEFAULT NULL,
  `tipo_documento` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emisor` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `periodo_inicio` date DEFAULT NULL,
  `periodo_fin` date DEFAULT NULL,
  `nombre_archivo` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ruta_storage` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash_archivo` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_carga` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_carga` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_doc_hash` (`hash_archivo`),
  KEY `idx_doc_caso` (`caso_id`),
  KEY `idx_doc_tipo` (`tipo_documento`),
  KEY `idx_doc_periodo` (`periodo_inicio`,`periodo_fin`),
  KEY `fk_doc_trabajador` (`trabajador_id`),
  KEY `fk_doc_empleador` (`empleador_id`),
  KEY `fk_doc_contrato` (`contrato_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleador`
--

DROP TABLE IF EXISTS `empleador`;
CREATE TABLE IF NOT EXISTS `empleador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `razon_social` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rut_cuerpo` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut_dv` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_actualizacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut_unico` (`rut_cuerpo`,`rut_dv`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `empleador`
--

INSERT INTO `empleador` (`id`, `razon_social`, `rut_cuerpo`, `rut_dv`, `direccion`, `telefono`, `email`, `fecha_creacion`, `fecha_actualizacion`) VALUES
(1, 'Mariela Farias Leyton', '15130287', '4', 'Ruta J55 km 13', '997718963', 'marelafariasleyton@gmail.com', NULL, NULL),
(2, 'Alfredo Norambuena Cerda SPA', '6906337', '3', 'Liquidambar 2045', '993241494', 'alfredonorambuenac@gmail.com', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `extraccion_campo`
--

DROP TABLE IF EXISTS `extraccion_campo`;
CREATE TABLE IF NOT EXISTS `extraccion_campo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `documento_id` int NOT NULL,
  `ocr_id` int DEFAULT NULL,
  `plantilla_campo_id` int DEFAULT NULL,
  `nombre_campo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor_string` text COLLATE utf8mb4_unicode_ci,
  `valor_date` date DEFAULT NULL,
  `valor_decimal` decimal(15,4) DEFAULT NULL,
  `valor_integer` int DEFAULT NULL,
  `confianza` decimal(5,2) DEFAULT NULL,
  `fuente` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_extraccion` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `idx_ec_doc` (`documento_id`),
  KEY `idx_ec_campo` (`nombre_campo`),
  KEY `idx_ec_pc` (`plantilla_campo_id`),
  KEY `fk_ec_ocr` (`ocr_id`)
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
  `tipo_termino` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto_indemnizacion` decimal(15,2) DEFAULT NULL,
  `monto_vacaciones` decimal(15,2) DEFAULT NULL,
  `monto_semanacorrida` decimal(15,2) DEFAULT NULL,
  `monto_multas` decimal(15,2) DEFAULT NULL,
  `monto_total` decimal(15,2) DEFAULT NULL,
  `moneda` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_uf` decimal(15,4) DEFAULT NULL,
  `valor_utm` decimal(15,2) DEFAULT NULL,
  `extra_data` json DEFAULT NULL,
  `estado` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `resumen_hallazgos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `monto_reclamo` decimal(15,2) DEFAULT NULL,
  `fecha` datetime DEFAULT (now()),
  `archivo_informe` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
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
  `archivo_liquidacion` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_carga` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `fk_liquidacion_trabajador` (`trabajador_id`),
  KEY `fk_liquidacion_empleador` (`empleador_id`),
  KEY `idx_liquidacion_contrato` (`contrato_id`),
  KEY `idx_liquidacion_periodo` (`periodo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ocr_resultado`
--

DROP TABLE IF EXISTS `ocr_resultado`;
CREATE TABLE IF NOT EXISTS `ocr_resultado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `documento_id` int NOT NULL,
  `motor` varchar(40) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idioma` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `texto_full` longtext COLLATE utf8mb4_unicode_ci,
  `json_crudo` json DEFAULT NULL,
  `confianza_media` decimal(5,2) DEFAULT NULL,
  `estado_ocr` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_ocr` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  KEY `idx_ocr_doc` (`documento_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plantilla`
--

DROP TABLE IF EXISTS `plantilla`;
CREATE TABLE IF NOT EXISTS `plantilla` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_documento` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` int DEFAULT '1',
  `activo` tinyint(1) DEFAULT '1',
  `fecha_creacion` datetime DEFAULT (now()),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_plantilla_tipo_version` (`tipo_documento`,`version`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `plantilla`
--

INSERT INTO `plantilla` (`id`, `nombre`, `tipo_documento`, `version`, `activo`, `fecha_creacion`) VALUES
(1, 'Comunicación de Autodespido', 'autodespido_comunicacion', 1, 1, '2025-08-13 14:18:40'),
(2, 'Protocolo Autodespido (Carta)', 'autodespido_protocolo', 1, 1, '2025-08-13 14:18:40'),
(3, 'Proyecto de Finiquito (borrador)', 'proyecto_finiquito_borrador', 1, 1, '2025-08-13 14:18:40'),
(4, 'Cartola Histórica', 'cartola_historica', 1, 1, '2025-08-13 14:18:40'),
(5, 'Resumen Semana Corrida', 'resumen_semana_corrida', 1, 1, '2025-08-13 14:18:40');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plantilla_campo`
--

DROP TABLE IF EXISTS `plantilla_campo`;
CREATE TABLE IF NOT EXISTS `plantilla_campo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `plantilla_id` int NOT NULL,
  `nombre_campo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_dato` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requerido` tinyint(1) DEFAULT '0',
  `heuristica` json DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pc_plantilla` (`plantilla_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trabajador`
--

DROP TABLE IF EXISTS `trabajador`;
CREATE TABLE IF NOT EXISTS `trabajador` (
  `id` int NOT NULL AUTO_INCREMENT,
  `rut_cuerpo` varchar(8) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rut_dv` char(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellido_paterno` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellido_materno` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `email` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(180) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT (now()),
  `fecha_actualizacion` datetime DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `tipo_contribuyente` enum('persona','empresa') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'persona',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rut_unico` (`rut_cuerpo`,`rut_dv`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `trabajador`
--

INSERT INTO `trabajador` (`id`, `rut_cuerpo`, `rut_dv`, `nombre`, `apellido_paterno`, `apellido_materno`, `fecha_nacimiento`, `email`, `telefono`, `direccion`, `fecha_creacion`, `fecha_actualizacion`, `activo`, `tipo_contribuyente`) VALUES
(3, '14326078', 'K', 'Jean', 'Norambuena', 'Chávez', '1977-05-07', 'jeannorambuena@gmail.com', '997718963', 'Ruta J55 km 13', '2025-08-03 17:14:30', NULL, 0, 'persona'),
(4, '7309224', '8', 'Maria Elena', 'Leyton ', 'Diaz', '1956-08-23', 'mariae.leytond@gmail.com', '997718962', 'Isla Victoria 1914', '2025-08-22 09:53:12', NULL, 1, 'persona');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_caso_header`
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vw_caso_header`;
CREATE TABLE IF NOT EXISTS `vw_caso_header` (
`codigo` varchar(36)
,`empleador_id` int
,`empleador_razon_social` varchar(120)
,`estado` varchar(30)
,`fecha_inicio` date
,`id` int
,`nombre_caso` varchar(200)
,`tipo` varchar(60)
,`trabajador_apellido_paterno` varchar(60)
,`trabajador_id` int
,`trabajador_nombre` varchar(202)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_insumos_finiquito`
-- (Véase abajo para la vista actual)
--
DROP VIEW IF EXISTS `vw_insumos_finiquito`;
CREATE TABLE IF NOT EXISTS `vw_insumos_finiquito` (
`caso_id` int
,`empleador_id` int
,`fecha_inicio_contrato` date
,`fecha_termino_contrato` date
,`finiquito_id` int
,`moneda` varchar(10)
,`monto_indemnizacion` decimal(15,2)
,`monto_multas` decimal(15,2)
,`monto_semanacorrida` decimal(15,2)
,`monto_vacaciones` decimal(15,2)
,`semana_corrida_hist` decimal(37,2)
,`sueldo_base_ultimo` decimal(15,2)
,`sueldo_promedio` decimal(19,6)
,`trabajador_id` int
,`valor_uf` decimal(15,4)
,`valor_utm` decimal(15,2)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_caso_header`
--
DROP TABLE IF EXISTS `vw_caso_header`;

DROP VIEW IF EXISTS `vw_caso_header`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_caso_header`  AS SELECT `c`.`id` AS `id`, `c`.`codigo` AS `codigo`, `c`.`nombre_caso` AS `nombre_caso`, `c`.`tipo` AS `tipo`, `c`.`estado` AS `estado`, `c`.`fecha_inicio` AS `fecha_inicio`, `t`.`id` AS `trabajador_id`, concat_ws(' ',`t`.`nombre`,`t`.`apellido_paterno`,`t`.`apellido_materno`) AS `trabajador_nombre`, `t`.`apellido_paterno` AS `trabajador_apellido_paterno`, `e`.`id` AS `empleador_id`, `e`.`razon_social` AS `empleador_razon_social` FROM ((`caso` `c` left join `trabajador` `t` on((`t`.`id` = `c`.`trabajador_id`))) left join `empleador` `e` on((`e`.`id` = `c`.`empleador_id`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_insumos_finiquito`
--
DROP TABLE IF EXISTS `vw_insumos_finiquito`;

DROP VIEW IF EXISTS `vw_insumos_finiquito`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_insumos_finiquito`  AS SELECT `f`.`id` AS `finiquito_id`, `f`.`caso_id` AS `caso_id`, `f`.`trabajador_id` AS `trabajador_id`, `f`.`empleador_id` AS `empleador_id`, `f`.`fecha_inicio_contrato` AS `fecha_inicio_contrato`, `f`.`fecha_termino_contrato` AS `fecha_termino_contrato`, `f`.`monto_indemnizacion` AS `monto_indemnizacion`, `f`.`monto_vacaciones` AS `monto_vacaciones`, `f`.`monto_semanacorrida` AS `monto_semanacorrida`, `f`.`monto_multas` AS `monto_multas`, `f`.`moneda` AS `moneda`, `f`.`valor_uf` AS `valor_uf`, `f`.`valor_utm` AS `valor_utm`, (select sum(`l`.`semana_corrida`) from `liquidacion` `l` where (`l`.`trabajador_id` = `f`.`trabajador_id`)) AS `semana_corrida_hist`, (select avg(`l`.`sueldo_imponible`) from `liquidacion` `l` where (`l`.`trabajador_id` = `f`.`trabajador_id`)) AS `sueldo_promedio`, (select any_value(`c`.`sueldo_base`) from `contrato` `c` where (`c`.`trabajador_id` = `f`.`trabajador_id`) order by `c`.`fecha_creacion` desc limit 1) AS `sueldo_base_ultimo` FROM `finiquito` AS `f` ;

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
-- Filtros para la tabla `documento_fuente`
--
ALTER TABLE `documento_fuente`
  ADD CONSTRAINT `fk_doc_caso` FOREIGN KEY (`caso_id`) REFERENCES `caso` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_contrato` FOREIGN KEY (`contrato_id`) REFERENCES `contrato` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_empleador` FOREIGN KEY (`empleador_id`) REFERENCES `empleador` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_doc_trabajador` FOREIGN KEY (`trabajador_id`) REFERENCES `trabajador` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `extraccion_campo`
--
ALTER TABLE `extraccion_campo`
  ADD CONSTRAINT `fk_ec_doc` FOREIGN KEY (`documento_id`) REFERENCES `documento_fuente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ec_ocr` FOREIGN KEY (`ocr_id`) REFERENCES `ocr_resultado` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ec_pc` FOREIGN KEY (`plantilla_campo_id`) REFERENCES `plantilla_campo` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

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

--
-- Filtros para la tabla `ocr_resultado`
--
ALTER TABLE `ocr_resultado`
  ADD CONSTRAINT `fk_ocr_doc` FOREIGN KEY (`documento_id`) REFERENCES `documento_fuente` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `plantilla_campo`
--
ALTER TABLE `plantilla_campo`
  ADD CONSTRAINT `fk_pc_plantilla` FOREIGN KEY (`plantilla_id`) REFERENCES `plantilla` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
