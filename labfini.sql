-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 23-08-2025 a las 15:37:47
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `caso`
--

INSERT INTO `caso` (`id`, `codigo`, `trabajador_id`, `empleador_id`, `fecha_inicio`, `estado`, `resumen`, `tipo`, `nombre_caso`, `fecha_creacion`, `fecha_cierre`) VALUES
(2, '2982081e-786b-11f0-8903-005056c00001', 3, 1, '2025-08-13', 'abierto', NULL, 'autodespido', 'Norambuena/Mariela Farias Leyton - 2982081e-786b-11f0-8903-005056c00001', '2025-08-13 13:30:10', NULL),
(3, 'f1ae741a-7b8b-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'asjapjfalskjalkfjalsjfdlasjdlalskdjlakjd', '', 'Norambuena/Mariela Farias Leyton - f1ae741a-7b8b-11f0-8b2e-005056c00001', NULL, NULL),
(4, 'c41b0b48-7b8e-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'alsdkjadlkjaldkjalkdjlas', '', 'Norambuena/Mariela Farias Leyton - c41b0b48-7b8e-11f0-8b2e-005056c00001', NULL, NULL),
(5, '50d4ce31-7b91-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'kdjalsdkjalskdalkdjalkdjlakdjaldjlakdjalkdjaldjaldjacasdasdasdasdadadsadasda', '', 'Norambuena/Mariela Farias Leyton - 50d4ce31-7b91-11f0-8b2e-005056c00001', NULL, NULL),
(6, 'a0b2fb08-7bb5-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'ñfljkwafkjsc wosfdnsñcnañofnwvsoñcjlqna{cqkm{aclnkwsñlfknqal', '', 'Norambuena/Mariela Farias Leyton - a0b2fb08-7bb5-11f0-8b2e-005056c00001', NULL, NULL),
(7, 'b29db1be-7ca2-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'sdlñfksdfñlkjsdfsldkjfsldñkfjslfkjlsñdfvjnñkjnbasdkñJABNSASÑALSKNFÑLSDKFNSLSKNDAKAJNDKAJFN{SLDKV{LAKSXXS,DMNDS,A,SM', '', 'Norambuena/Mariela Farias Leyton - b29db1be-7ca2-11f0-8b2e-005056c00001', NULL, NULL),
(8, 'acd0be46-7cb2-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'aaaajjapospdfosfñdlkj{slñfjs{fdñlkjs{lkfj{lfksjflskjflsñkdfjñsldkjfsñlkjsñldkfjsñlfkjsñflkjsñlkjdfñlksjdfñlskfjsñlfkjsñlkfjsñlfkjslfkjsldkfjslñfkjslkfjsldkjslñdfkjslkfjsñlkfjsñlfkjslfkjsñlfkjl', '', 'Norambuena/Mariela Farias Leyton - acd0be46-7cb2-11f0-8b2e-005056c00001', NULL, NULL),
(9, '89041390-7db4-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', '.mz.,cmz.xc,mz.,mz.xcmz.x,cm.z,m.z,xc', '', 'Norambuena/Mariela Farias Leyton - 89041390-7db4-11f0-8b2e-005056c00001', NULL, NULL),
(10, '2b38b241-7dcd-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', '.mz.,cmz.xc,mz.,mz.xcmz.x,cm.z,m.z,xc', '', 'Norambuena/Mariela Farias Leyton - 2b38b241-7dcd-11f0-8b2e-005056c00001', NULL, NULL),
(11, 'ce711fe5-7dcd-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', '.mz.,cmz.xc,mz.,mz.xcmz.x,cm.z,m.z,xc', '', 'Norambuena/Mariela Farias Leyton - ce711fe5-7dcd-11f0-8b2e-005056c00001', NULL, NULL),
(12, '8296fe81-7dd7-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'añlkañdslkañdlkañdlkañsldkañlkañdkañsldkañsldkañsdlkañsldk', '', 'Norambuena/Mariela Farias Leyton - 8296fe81-7dd7-11f0-8b2e-005056c00001', NULL, NULL),
(13, 'cd8b11f1-7dde-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'lsldakjdlkjsalkjdlakjsdlakjdslakjddsddfsf{sasñwpod{askgñtjgeojd kac mvñnñpejiwouhdbh ckldñfkgpwfjaon', '', 'Norambuena/Mariela Farias Leyton - cd8b11f1-7dde-11f0-8b2e-005056c00001', NULL, NULL),
(14, 'c241915d-7de3-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'hola', '', 'Norambuena/Mariela Farias Leyton - c241915d-7de3-11f0-8b2e-005056c00001', NULL, NULL),
(15, '52436039-7de6-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'sfdsdsd', '', 'Norambuena/Mariela Farias Leyton - 52436039-7de6-11f0-8b2e-005056c00001', NULL, NULL),
(16, '55a95121-7deb-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'sfdsdsd', '', 'Norambuena/Mariela Farias Leyton - 55a95121-7deb-11f0-8b2e-005056c00001', NULL, NULL),
(17, '640e3c12-7deb-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola2', '', 'Norambuena/Mariela Farias Leyton - 640e3c12-7deb-11f0-8b2e-005056c00001', NULL, NULL),
(18, 'd407d813-7df9-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola', '', 'Norambuena/Mariela Farias Leyton - d407d813-7df9-11f0-8b2e-005056c00001', NULL, NULL),
(19, '2072f2b1-7e2f-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola3', '', 'Norambuena/Mariela Farias Leyton - 2072f2b1-7e2f-11f0-8b2e-005056c00001', NULL, NULL),
(20, '9f7dd78c-7e30-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'asdadas', '', 'Norambuena/Mariela Farias Leyton - 9f7dd78c-7e30-11f0-8b2e-005056c00001', NULL, NULL),
(21, '4bfcbf26-7e31-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', '<saas', '', 'Norambuena/Mariela Farias Leyton - 4bfcbf26-7e31-11f0-8b2e-005056c00001', NULL, NULL),
(22, '89473a58-7e33-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'ssss', '', 'Norambuena/Mariela Farias Leyton - 89473a58-7e33-11f0-8b2e-005056c00001', NULL, NULL),
(23, 'c3929022-7e33-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'hola', '', 'Norambuena/Mariela Farias Leyton - c3929022-7e33-11f0-8b2e-005056c00001', NULL, NULL),
(24, '3edf36ff-7e8a-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'holahola', '', 'Norambuena/Mariela Farias Leyton - 3edf36ff-7e8a-11f0-8b2e-005056c00001', NULL, NULL),
(25, 'a4d14ca6-7e91-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola', '', 'Norambuena/Mariela Farias Leyton - a4d14ca6-7e91-11f0-8b2e-005056c00001', NULL, NULL),
(26, 'c3d6299c-7e99-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hlola', '', 'Norambuena/Mariela Farias Leyton - c3d6299c-7e99-11f0-8b2e-005056c00001', NULL, NULL),
(27, '3fe8b9bd-7ea4-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'AFDSLKDFSLDKJSDLKFJLSDJ', '', 'Norambuena/Mariela Farias Leyton - 3fe8b9bd-7ea4-11f0-8b2e-005056c00001', NULL, NULL),
(28, '96434602-7ea6-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola pruefa final', '', 'Norambuena/Mariela Farias Leyton - 96434602-7ea6-11f0-8b2e-005056c00001', NULL, NULL),
(29, '19b71363-7eaa-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'prueba hotfix', '', 'Norambuena/Mariela Farias Leyton - 19b71363-7eaa-11f0-8b2e-005056c00001', NULL, NULL),
(30, 'fef5b821-7eaa-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba final 2', '', 'Norambuena/Mariela Farias Leyton - fef5b821-7eaa-11f0-8b2e-005056c00001', NULL, NULL),
(31, 'a38a6fce-7eab-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba 3', '', 'Norambuena/Mariela Farias Leyton - a38a6fce-7eab-11f0-8b2e-005056c00001', NULL, NULL),
(32, '876730b1-7ed5-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hola prueba de caso preliminar', '', 'Norambuena/Mariela Farias Leyton - 876730b1-7ed5-11f0-8b2e-005056c00001', NULL, NULL),
(33, 'cf65f57c-7ed5-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba de scripts', '', 'Norambuena/Mariela Farias Leyton - cf65f57c-7ed5-11f0-8b2e-005056c00001', NULL, NULL),
(34, 'eda02086-7ed5-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Historia de prueba para habilitar el caso preliminar.', '', 'Norambuena/Mariela Farias Leyton - eda02086-7ed5-11f0-8b2e-005056c00001', NULL, NULL),
(35, '5c2a44c2-7ed8-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Hostoria', '', 'Norambuena/Mariela Farias Leyton - 5c2a44c2-7ed8-11f0-8b2e-005056c00001', NULL, NULL),
(36, '79b2c267-7edc-11f0-8b2e-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba end to end', '', 'Norambuena/Mariela Farias Leyton - 79b2c267-7edc-11f0-8b2e-005056c00001', NULL, NULL),
(37, 'd42594fa-7efc-11f0-8e17-005056c00001', 3, 1, NULL, 'Recolección documental', 'end to end', '', 'Norambuena/Mariela Farias Leyton - d42594fa-7efc-11f0-8e17-005056c00001', NULL, NULL),
(38, 'c94c765b-7efe-11f0-8e17-005056c00001', 3, 1, NULL, 'Recolección documental', 'end  to end 22:21', '', 'Norambuena/Mariela Farias Leyton - c94c765b-7efe-11f0-8e17-005056c00001', NULL, NULL),
(39, 'cb2e62da-7f08-11f0-8e17-005056c00001', 3, 1, NULL, 'Recolección documental', 'PRUEBA E2E 23:33', '', 'Norambuena/Mariela Farias Leyton - cb2e62da-7f08-11f0-8e17-005056c00001', NULL, NULL),
(40, '19129fc7-7f12-11f0-8e17-005056c00001', 3, 1, NULL, 'Recolección documental', 'Prueba E2E 00:40sdfdfsdfsd', '', 'Norambuena/Mariela Farias Leyton - 19129fc7-7f12-11f0-8e17-005056c00001', NULL, NULL),
(41, 'b8e3cd51-7f5d-11f0-b641-005056c00001', 4, 2, NULL, 'Recolección documental', 'Prueba E2E para revision total y general del template \"casos\" xxxxxx', '', 'Norambuena/Mariela Farias Leyton - b8e3cd51-7f5d-11f0-b641-005056c00001', NULL, NULL),
(42, '3b8d4c69-7f91-11f0-869b-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e final 15:50', '', 'Norambuena/Mariela Farias Leyton - 3b8d4c69-7f91-11f0-869b-005056c00001', NULL, NULL),
(43, '3af35078-7fb5-11f0-869b-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e 20:07', '', 'Norambuena/Mariela Farias Leyton - 3af35078-7fb5-11f0-869b-005056c00001', NULL, NULL),
(44, 'aa5bce50-7fb7-11f0-869b-005056c00001', 3, 1, NULL, 'Recolección documental', 'hola e2e 2025', '', 'Norambuena/Mariela Farias Leyton - aa5bce50-7fb7-11f0-869b-005056c00001', NULL, NULL),
(45, '91531047-8024-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e prueba 23 de agosto 9:24', '', 'Norambuena/Mariela Farias Leyton - 91531047-8024-11f0-8046-005056c00001', NULL, NULL),
(46, '86b23660-8028-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'e2e prueba 9:53', '', 'Norambuena/Mariela Farias Leyton - 86b23660-8028-11f0-8046-005056c00001', NULL, NULL),
(47, 'be86fe2b-802d-11f0-8046-005056c00001', 3, 1, NULL, 'Recolección documental', 'E2E prueba 10:30', '', 'Norambuena/Mariela Farias Leyton - be86fe2b-802d-11f0-8046-005056c00001', NULL, NULL);

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `documento_fuente`
--

INSERT INTO `documento_fuente` (`id`, `trabajador_id`, `empleador_id`, `contrato_id`, `caso_id`, `tipo_documento`, `emisor`, `periodo_inicio`, `periodo_fin`, `nombre_archivo`, `ruta_storage`, `hash_archivo`, `estado_carga`, `fecha_carga`) VALUES
(1, 3, 1, NULL, 2, 'autodespido_comunicacion', 'Trabajador', NULL, NULL, 'COMUNICA AUTODESPIDO.docx', 'app/uploads/autodespidos/COMUNICA AUTODESPIDO.docx', NULL, 'cargado', '2025-08-13 14:01:43'),
(2, 3, 1, NULL, 2, 'autodespido_protocolo', 'Trabajador', NULL, NULL, 'PROTOCOLO AUTODESPIDO - CARTA.docx', 'app/uploads/autodespidos/PROTOCOLO AUTODESPIDO - CARTA.docx', NULL, 'cargado', '2025-08-13 14:01:43'),
(3, 3, 1, NULL, 2, 'proyecto_finiquito_borrador', 'Estudio Jurídico', NULL, NULL, 'PROYECTO DE FINIQUITO.docx', 'app/uploads/autodespidos/PROYECTO DE FINIQUITO.docx', NULL, 'cargado', '2025-08-13 14:01:43'),
(4, 3, 1, NULL, 2, 'cartola_historica', 'Entidad Financiera/AFP', NULL, NULL, 'CARTOLA HISTORICA.pdf', 'app/uploads/autodespidos/CARTOLA HISTORICA.pdf', NULL, 'cargado', '2025-08-13 14:01:43'),
(5, 3, 1, NULL, 2, 'resumen_semana_corrida', 'Empleador/Área RRHH', '2023-06-01', '2025-04-30', 'JUAN LUIS VALENZUELA ORELLANA - SEMANA CORRIDA.docx', 'app/uploads/autodespidos/JUAN LUIS VALENZUELA ORELLANA - SEMANA CORRIDA.docx', NULL, 'cargado', '2025-08-13 14:01:43');

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
