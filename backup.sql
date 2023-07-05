-- MySQL dump 10.13  Distrib 5.7.31, for Win64 (x86_64)
--
-- Host: localhost    Database: sicandb
-- ------------------------------------------------------
-- Server version	5.7.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ceritaprev`
--

DROP TABLE IF EXISTS `ceritaprev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ceritaprev` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jumlah_cerita` int(11) DEFAULT NULL,
  `jumlah_blacklist` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ceritaprev`
--

LOCK TABLES `ceritaprev` WRITE;
/*!40000 ALTER TABLE `ceritaprev` DISABLE KEYS */;
/*!40000 ALTER TABLE `ceritaprev` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tbl_cerita`
--

DROP TABLE IF EXISTS `tbl_cerita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_cerita` (
  `id_cerita` varchar(250) NOT NULL,
  `judul` varchar(250) DEFAULT NULL,
  `videourl` text,
  `gambar` varchar(250) DEFAULT NULL,
  `deskripsi` text,
  `status` varchar(250) DEFAULT NULL,
  `fkg_penulis` varchar(250) DEFAULT NULL,
  `likes` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id_cerita`),
  KEY `fkg_penulis` (`fkg_penulis`),
  CONSTRAINT `tbl_cerita_ibfk_1` FOREIGN KEY (`fkg_penulis`) REFERENCES `users` (`uuid_users`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_cerita`
--

LOCK TABLES `tbl_cerita` WRITE;
/*!40000 ALTER TABLE `tbl_cerita` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_cerita` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_jumlah_cerita` AFTER INSERT ON `tbl_cerita` FOR EACH ROW BEGIN
    UPDATE ceritaprev SET jumlah_cerita = jumlah_cerita + 1 WHERE id = (SELECT id FROM users WHERE uuid_users = NEW.fkg_penulis);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_api_logsins
AFTER INSERT ON tbl_cerita
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (action, table_name, record_id, user_id, data)
    VALUES ('insert', 'tbl_cerita', NEW.id_cerita, NEW.fkg_penulis, JSON_OBJECT('judul', NEW.judul, 'videourl', NEW.videourl, 'gambar', NEW.gambar, 'deskripsi', NEW.deskripsi, 'status', NEW.status, 'fkg_penulis', NEW.fkg_penulis, 'likes', NEW.likes));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tambah_jumlah_blacklist` AFTER UPDATE ON `tbl_cerita` FOR EACH ROW BEGIN
    IF NEW.status = '0' THEN
        UPDATE ceritaprev SET jumlah_blacklist = jumlah_blacklist + 1 WHERE id = (SELECT id FROM users WHERE uuid_users = NEW.fkg_penulis);
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_api_logsup
AFTER UPDATE ON tbl_cerita
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (action, table_name, record_id, user_id, data)
    VALUES ('update', 'tbl_cerita', NEW.id_cerita, NEW.fkg_penulis, JSON_OBJECT('judul', NEW.judul, 'videourl', NEW.videourl, 'gambar', NEW.gambar, 'deskripsi', NEW.deskripsi, 'status', NEW.status, 'fkg_penulis', NEW.fkg_penulis, 'likes', NEW.likes));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_delete_cerita
AFTER DELETE ON tbl_cerita
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (timestamp, action, table_name, record_id, user_id)
    VALUES (CURRENT_TIMESTAMP, 'Delete', 'tbl_cerita', OLD.id_cerita, OLD.fkg_penulis);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_logs`
--

DROP TABLE IF EXISTS `tbl_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `action` varchar(250) NOT NULL,
  `table_name` varchar(250) NOT NULL,
  `record_id` varchar(250) DEFAULT NULL,
  `user_id` varchar(250) DEFAULT NULL,
  `data` json DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_logs`
--

LOCK TABLES `tbl_logs` WRITE;
/*!40000 ALTER TABLE `tbl_logs` DISABLE KEYS */;
INSERT INTO `tbl_logs` VALUES (4,'2023-06-04 05:53:47','insert','tbl_cerita','230604125347-715713','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125347-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604125347-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(5,'2023-06-04 05:55:11','update','tbl_cerita','230604125347-715713','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125419-P-230604114202.png\", \"status\": \"1\", \"videourl\": \"20230604125419-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(6,'2023-06-04 05:59:40','insert','tbl_cerita','230604125940-467588','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604125940-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604125940-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(7,'2023-06-04 06:00:31','insert','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604130031-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130031-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(8,'2023-06-04 06:00:42','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130042-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130042-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(9,'2023-06-04 06:00:57','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(10,'2023-06-04 06:01:04','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"sicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(11,'2023-06-04 06:01:11','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(12,'2023-06-04 06:02:27','update','tbl_cerita','230604130031-152750','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130057-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130057-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(13,'2023-06-04 06:07:07','insert','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604130707-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130707-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(14,'2023-06-04 06:07:35','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130735-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130735-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(15,'2023-06-04 06:07:43','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130743-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130743-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(16,'2023-06-04 06:07:46','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(17,'2023-06-04 06:11:32','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"0\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(18,'2023-06-04 06:11:57','update','tbl_cerita','230604130707-223649','P-230604114202','{\"judul\": \"asassicandb\", \"likes\": \"0\", \"gambar\": \"20230604130746-P-230604114202.jpg\", \"status\": \"2\", \"videourl\": \"20230604130746-P-230604114202.png\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(19,'2023-06-04 06:18:20','insert','tbl_cerita','230604131820-61133','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604131820-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604131820-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(20,'2023-06-04 07:07:22','insert','tbl_cerita','230604140722-286726','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230604140722-P-230604114202.jpg\", \"status\": \"1\", \"videourl\": \"20230604140722-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(21,'2023-06-06 13:12:10','insert','tbl_cerita','230606201210-628671','P-230606201011','{\"judul\": \"cerita anak anak 2\", \"likes\": \"0\", \"gambar\": \"20230606201210-P-230606201011.jpg\", \"status\": \"1\", \"videourl\": \"20230606201210-P-230606201011.mp4\", \"deskripsi\": \"cerita anak anak v2\", \"fkg_penulis\": \"P-230606201011\"}'),(22,'2023-06-06 13:14:23','update','tbl_cerita','230606201210-628671','P-230606201011','{\"judul\": \"cerita anak 22\", \"likes\": \"0\", \"gambar\": \"20230606201210-P-230606201011.jpg\", \"status\": \"1\", \"videourl\": \"20230606201210-P-230606201011.mp4\", \"deskripsi\": \"cerita anak anak v22\", \"fkg_penulis\": \"P-230606201011\"}'),(23,'2023-06-14 14:18:51','insert','tbl_cerita','230614211851-913839','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230614211851-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614211851-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(24,'2023-06-14 14:23:48','insert','tbl_cerita','230614212348-790581','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230614212348-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614212348-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(25,'2023-06-14 14:32:46','insert','tbl_cerita','230614213246-156803','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230614213246-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213246-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(26,'2023-06-14 14:32:48','insert','tbl_cerita','230614213248-550743','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230614213247-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213248-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(27,'2023-06-14 14:32:49','insert','tbl_cerita','230614213249-333683','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"0\", \"gambar\": \"20230614213249-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213249-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(28,'2023-06-14 14:33:10','update','tbl_cerita','230614213248-550743','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"3\", \"gambar\": \"20230614213247-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213248-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(29,'2023-06-14 14:33:10','update','tbl_cerita','230614213249-333683','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"1\", \"gambar\": \"20230614213249-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213249-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(30,'2023-06-14 14:33:10','update','tbl_cerita','230614213246-156803','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"6\", \"gambar\": \"20230614213246-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213246-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(31,'2023-06-14 14:44:45','update','tbl_cerita','230614213246-156803','P-230604114202','{\"judul\": \"cerita anak anak\", \"likes\": \"7\", \"gambar\": \"20230614213246-P-230604114202.mp4\", \"status\": \"1\", \"videourl\": \"20230614213246-P-230604114202.mp4\", \"deskripsi\": \"cerita anak anak v1\", \"fkg_penulis\": \"P-230604114202\"}'),(32,'2023-06-14 15:35:48','Delete','tbl_cerita','230614213248-550743','P-230604114202',NULL),(33,'2023-06-14 15:42:21','Delete','tbl_cerita','230614213249-333683','P-230604114202',NULL);
/*!40000 ALTER TABLE `tbl_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER trigger_api_logsdelete
AFTER DELETE ON tbl_logs
FOR EACH ROW
BEGIN
    INSERT INTO tbl_logs (action, table_name, record_id, user_id, data)
    VALUES ('delete', 'tbl_logs', OLD.id, OLD.user_id, OLD.data);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `tbl_usersmobile`
--

DROP TABLE IF EXISTS `tbl_usersmobile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tbl_usersmobile` (
  `uuid` varchar(250) DEFAULT NULL,
  `nama` varchar(250) DEFAULT NULL,
  `umur` varchar(250) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tbl_usersmobile`
--

LOCK TABLES `tbl_usersmobile` WRITE;
/*!40000 ALTER TABLE `tbl_usersmobile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tbl_usersmobile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `uuid_users` varchar(250) NOT NULL,
  `nama` varchar(250) DEFAULT NULL,
  `password` text,
  `role` varchar(1) DEFAULT NULL,
  `alamat` text,
  PRIMARY KEY (`uuid_users`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES ('12321','bagusandrez','bagusandre','1','jalan jalan'),('P-230604114052','bagusandre','polibek22x','1','tenjolayabogor'),('P-230604114202','bagus asd','polibek22x','1','tenjolayabogor'),('P-230604140643','penulis','penulis','1','jalan jalan'),('P-230606201011','penulis1','penulis12','1','jalan yang lurus'),('P-230614220338','polibek11','bagusandre','1','jalan jalan');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'sicandb'
--
/*!50003 DROP PROCEDURE IF EXISTS `ambil_data_tbl_cerita_active` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ambil_data_tbl_cerita_active`()
BEGIN
    SELECT id_cerita, judul, videourl, gambar, deskripsi, fkg_penulis, likes FROM tbl_cerita where status = '1';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ambil_data_tbl_cerita_inactive` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ambil_data_tbl_cerita_inactive`()
BEGIN
    SELECT id_cerita, judul, videourl, gambar, deskripsi, fkg_penulis, likes FROM tbl_cerita where status = '0';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `check_duplicate_name` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_duplicate_name`(
    IN nama_param VARCHAR(250),
    IN uuid_param VARCHAR(250)
)
BEGIN
    DECLARE duplicate_count INT;

    SELECT COUNT(*) INTO duplicate_count
    FROM users
    WHERE nama = nama_param
    AND uuid_users != uuid_param;

    SELECT duplicate_count AS count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_cerita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_cerita`(IN cerita_id VARCHAR(255))
BEGIN
    DELETE FROM tbl_cerita WHERE id_cerita = cerita_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_data_tbl_cerita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_data_tbl_cerita`(
    IN p_id_cerita INT,
    IN p_judul VARCHAR(255),
    IN p_video VARCHAR(255),
    IN p_cerita TEXT,
    IN p_gambar VARCHAR(255)
)
BEGIN
    UPDATE tbl_cerita
    SET judul = p_judul,
        videourl = p_video,
        deskripsi = p_cerita,
        gambar = p_gambar
    WHERE id_cerita = p_id_cerita;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserByUsername` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserByUsername`(IN p_username VARCHAR(255))
BEGIN
    SELECT uuid_users, nama, password, role, alamat FROM users WHERE nama = p_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserData`(IN p_username VARCHAR(255))
BEGIN
    SELECT * FROM users WHERE nama = p_username;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `hitung_jumlah_cerita_likes_by_penulis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `hitung_jumlah_cerita_likes_by_penulis`(IN penulis_id VARCHAR(255))
BEGIN
    SELECT fkg_penulis, COUNT(*) AS jumlah_cerita, SUM(likes) AS jumlah_likes
    FROM tbl_cerita
    WHERE fkg_penulis = penulis_id
    GROUP BY fkg_penulis;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_all_cerita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_all_cerita`()
BEGIN
    SELECT * FROM tbl_cerita;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_all_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_all_users`()
BEGIN
    SELECT * FROM users;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_all_usersmobile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_all_usersmobile`()
BEGIN
    SELECT * FROM tbl_usersmobile;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `select_cerita_by_penulis` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `select_cerita_by_penulis`(IN penulis_id VARCHAR(255))
BEGIN
    SELECT * FROM tbl_cerita WHERE fkg_penulis = penulis_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tambah_data_tbl_cerita` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_data_tbl_cerita`(IN `p_judul` VARCHAR(250), IN `p_videourl` TEXT, IN `p_deskripsi` TEXT, IN `p_status` VARCHAR(250), IN `p_fkg_penulis` VARCHAR(250), IN `p_likes` VARCHAR(250), IN `p_gambar` VARCHAR(250))
BEGIN
-- Menghasilkan nilai acak untuk RANDOMMATH
DECLARE p_random_math INT;
declare p_id_cerita varchar(250);
DECLARE p_tanggal_waktu VARCHAR(14);
SET p_random_math = FLOOR(RAND() * 1000000);

SET p_tanggal_waktu = DATE_FORMAT(NOW(), '%y%m%d%H%i%s');

-- Menggabungkan ID cerita dengan nilai RANDOMMATH dan waktu
SET p_id_cerita = CONCAT(p_tanggal_waktu, '-', p_random_math);

INSERT INTO tbl_cerita (id_cerita, judul, videourl,gambar, deskripsi, status, fkg_penulis, likes)
VALUES (p_id_cerita, p_judul, p_videourl,p_gambar, p_deskripsi, p_status, p_fkg_penulis, p_likes);


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tambah_data_tbl_usersmobile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_data_tbl_usersmobile`(IN `p_uuid` VARCHAR(250), IN `p_nama` VARCHAR(250), IN `p_umur` VARCHAR(250))
BEGIN
    INSERT INTO tbl_usersmobile (uuid, nama, umur)
    VALUES (p_uuid, p_nama, p_umur);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tambah_data_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_data_users`(
    IN p_nama VARCHAR(250),
    IN p_password TEXT,
    IN p_role VARCHAR(1),
    IN p_alamat TEXT
)
BEGIN
    DECLARE p_tanggal_waktu VARCHAR(14);
    DECLARE p_hasil VARCHAR(250);
    SET p_tanggal_waktu = DATE_FORMAT(NOW(), '%y%m%d%H%i%s');
    SET p_hasil = CONCAT('P-', p_tanggal_waktu);
    INSERT INTO users (uuid_users, nama, password, role, alamat)
    VALUES (p_hasil, p_nama, p_password, p_role, p_alamat);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tambah_likes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_likes`(IN cerita_id VARCHAR(255))
BEGIN
    UPDATE tbl_cerita
    SET likes = likes + 1
    WHERE id_cerita = cerita_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_users` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_users`(
    IN uuid_param VARCHAR(250),
    IN nama_param VARCHAR(250),
    IN password_param TEXT,
    IN role_param VARCHAR(1),
    IN alamat_param TEXT
)
BEGIN
    DECLARE nama_count INT;

    -- Cek apakah ada nama yang duplikat, kecuali untuk ID pengguna yang sama
    SELECT COUNT(*) INTO nama_count
    FROM users
    WHERE nama = nama_param
    AND uuid_users != uuid_param;

    IF nama_count > 0 THEN
        SELECT 'Duplicate name' AS error_message;
    ELSE
        -- Lakukan update jika tidak ada nama yang duplikat
        UPDATE users
        SET
            nama = IFNULL(nama_param, nama),
            password = IFNULL(password_param, password),
            role = IFNULL(role_param, role),
            alamat = IFNULL(alamat_param, alamat)
        WHERE uuid_users = uuid_param;

        IF ROW_COUNT() > 0 THEN
            SELECT 'User updated successfully' AS success_message;
        ELSE
            SELECT 'No changes made' AS success_message;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-15 20:31:28
