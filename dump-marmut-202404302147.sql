-- MySQL dump 10.13  Distrib 8.1.0, for Win64 (x86_64)
--
-- Host: localhost    Database: marmut
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `akun`
--

DROP TABLE IF EXISTS `akun`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `akun` (
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `gender` int NOT NULL,
  `tempat_lahir` varchar(50) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `kota_asal` varchar(50) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `akun`
--

LOCK TABLES `akun` WRITE;
/*!40000 ALTER TABLE `akun` DISABLE KEYS */;
INSERT INTO `akun` VALUES ('coba@coba.com','1234','coba',1,'coba','2024-04-03',1,'cobacoba'),('email@example.com','password','John Doe',1,'Jakarta','1990-01-01',1,'Jakarta');
/*!40000 ALTER TABLE `akun` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `akun_play_song`
--

DROP TABLE IF EXISTS `akun_play_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `akun_play_song` (
  `email_pemain` varchar(50) DEFAULT NULL,
  `id_song` varchar(36) DEFAULT NULL,
  `waktu` timestamp NULL DEFAULT NULL,
  KEY `email_pemain` (`email_pemain`),
  KEY `id_song` (`id_song`),
  CONSTRAINT `akun_play_song_ibfk_1` FOREIGN KEY (`email_pemain`) REFERENCES `akun` (`email`),
  CONSTRAINT `akun_play_song_ibfk_2` FOREIGN KEY (`id_song`) REFERENCES `song` (`id_konten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `akun_play_song`
--

LOCK TABLES `akun_play_song` WRITE;
/*!40000 ALTER TABLE `akun_play_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `akun_play_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `akun_play_user_playlist`
--

DROP TABLE IF EXISTS `akun_play_user_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `akun_play_user_playlist` (
  `email_pemain` varchar(50) NOT NULL,
  `id_user_playlist` varchar(36) NOT NULL,
  `waktu` timestamp NOT NULL,
  PRIMARY KEY (`email_pemain`,`id_user_playlist`,`waktu`),
  KEY `id_user_playlist` (`id_user_playlist`),
  CONSTRAINT `akun_play_user_playlist_ibfk_1` FOREIGN KEY (`email_pemain`) REFERENCES `akun` (`email`),
  CONSTRAINT `akun_play_user_playlist_ibfk_2` FOREIGN KEY (`id_user_playlist`) REFERENCES `user_playlist` (`id_user_playlist`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `akun_play_user_playlist`
--

LOCK TABLES `akun_play_user_playlist` WRITE;
/*!40000 ALTER TABLE `akun_play_user_playlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `akun_play_user_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `album`
--

DROP TABLE IF EXISTS `album`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `album` (
  `id` varchar(36) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `jumlah_lagu` int NOT NULL DEFAULT '0',
  `id_label` varchar(36) DEFAULT NULL,
  `total_durasi` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id_label` (`id_label`),
  CONSTRAINT `album_ibfk_1` FOREIGN KEY (`id_label`) REFERENCES `label` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `album`
--

LOCK TABLES `album` WRITE;
/*!40000 ALTER TABLE `album` DISABLE KEYS */;
INSERT INTO `album` VALUES ('550e8400-e29b-41d4-a716-446655440010','Album 1',6,'550e8400-e29b-41d4-a716-446655440040',0),('550e8400-e29b-41d4-a716-446655440011','Album 2',6,'550e8400-e29b-41d4-a716-446655440040',0);
/*!40000 ALTER TABLE `album` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `id` varchar(36) NOT NULL,
  `email_akun` varchar(50) DEFAULT NULL,
  `id_pemilik_hak_cipta` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_akun` (`email_akun`),
  KEY `id_pemilik_hak_cipta` (`id_pemilik_hak_cipta`),
  CONSTRAINT `artist_ibfk_1` FOREIGN KEY (`email_akun`) REFERENCES `akun` (`email`),
  CONSTRAINT `artist_ibfk_2` FOREIGN KEY (`id_pemilik_hak_cipta`) REFERENCES `pemilik_hak_cipta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` VALUES ('550e8400-e29b-41d4-a716-446655440020','email@example.com','550e8400-e29b-41d4-a716-446655440050'),('ad422aeb-00e9-4fe2-9e4f-0375295d3d21','coba@coba.com','c35d8c90434b4b3c9e40df37276f0461');
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add pemilik hak cipta',7,'add_pemilikhakcipta'),(26,'Can change pemilik hak cipta',7,'change_pemilikhakcipta'),(27,'Can delete pemilik hak cipta',7,'delete_pemilikhakcipta'),(28,'Can view pemilik hak cipta',7,'view_pemilikhakcipta'),(29,'Can add user',8,'add_user'),(30,'Can change user',8,'change_user'),(31,'Can delete user',8,'delete_user'),(32,'Can view user',8,'view_user'),(33,'Can add songwriter',9,'add_songwriter'),(34,'Can change songwriter',9,'change_songwriter'),(35,'Can delete songwriter',9,'delete_songwriter'),(36,'Can view songwriter',9,'view_songwriter'),(37,'Can add podcaster',10,'add_podcaster'),(38,'Can change podcaster',10,'change_podcaster'),(39,'Can delete podcaster',10,'delete_podcaster'),(40,'Can view podcaster',10,'view_podcaster'),(41,'Can add artist',11,'add_artist'),(42,'Can change artist',11,'change_artist'),(43,'Can delete artist',11,'delete_artist'),(44,'Can view artist',11,'view_artist'),(45,'Can add label',12,'add_label'),(46,'Can change label',12,'change_label'),(47,'Can delete label',12,'delete_label'),(48,'Can view label',12,'view_label'),(49,'Can add playlist',13,'add_playlist'),(50,'Can change playlist',13,'change_playlist'),(51,'Can delete playlist',13,'delete_playlist'),(52,'Can view playlist',13,'view_playlist'),(53,'Can add user playlist',14,'add_userplaylist'),(54,'Can change user playlist',14,'change_userplaylist'),(55,'Can delete user playlist',14,'delete_userplaylist'),(56,'Can view user playlist',14,'view_userplaylist'),(57,'Can add album',15,'add_album'),(58,'Can change album',15,'change_album'),(59,'Can delete album',15,'delete_album'),(60,'Can view album',15,'view_album'),(61,'Can add konten',16,'add_konten'),(62,'Can change konten',16,'change_konten'),(63,'Can delete konten',16,'delete_konten'),(64,'Can view konten',16,'view_konten'),(65,'Can add song',17,'add_song'),(66,'Can change song',17,'change_song'),(67,'Can delete song',17,'delete_song'),(68,'Can view song',17,'view_song'),(69,'Can add playlist song',18,'add_playlistsong'),(70,'Can change playlist song',18,'change_playlistsong'),(71,'Can delete playlist song',18,'delete_playlistsong'),(72,'Can view playlist song',18,'view_playlistsong');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chart`
--

DROP TABLE IF EXISTS `chart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chart` (
  `tipe` varchar(50) NOT NULL,
  `id_playlist` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`tipe`),
  KEY `id_playlist` (`id_playlist`),
  CONSTRAINT `chart_ibfk_1` FOREIGN KEY (`id_playlist`) REFERENCES `playlist` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chart`
--

LOCK TABLES `chart` WRITE;
/*!40000 ALTER TABLE `chart` DISABLE KEYS */;
/*!40000 ALTER TABLE `chart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(15,'registration','album'),(11,'registration','artist'),(16,'registration','konten'),(12,'registration','label'),(7,'registration','pemilikhakcipta'),(13,'registration','playlist'),(18,'registration','playlistsong'),(10,'registration','podcaster'),(17,'registration','song'),(9,'registration','songwriter'),(8,'registration','user'),(14,'registration','userplaylist'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-04-28 17:46:47.192594'),(2,'auth','0001_initial','2024-04-28 17:46:47.563717'),(3,'admin','0001_initial','2024-04-28 17:46:47.656721'),(4,'admin','0002_logentry_remove_auto_add','2024-04-28 17:46:47.663078'),(5,'admin','0003_logentry_add_action_flag_choices','2024-04-28 17:46:47.669681'),(6,'contenttypes','0002_remove_content_type_name','2024-04-28 17:46:47.752452'),(7,'auth','0002_alter_permission_name_max_length','2024-04-28 17:46:47.807864'),(8,'auth','0003_alter_user_email_max_length','2024-04-28 17:46:47.830596'),(9,'auth','0004_alter_user_username_opts','2024-04-28 17:46:47.837595'),(10,'auth','0005_alter_user_last_login_null','2024-04-28 17:46:47.875714'),(11,'auth','0006_require_contenttypes_0002','2024-04-28 17:46:47.877715'),(12,'auth','0007_alter_validators_add_error_messages','2024-04-28 17:46:47.882718'),(13,'auth','0008_alter_user_username_max_length','2024-04-28 17:46:47.928723'),(14,'auth','0009_alter_user_last_name_max_length','2024-04-28 17:46:47.984357'),(15,'auth','0010_alter_group_name_max_length','2024-04-28 17:46:48.000350'),(16,'auth','0011_update_proxy_permissions','2024-04-28 17:46:48.007347'),(17,'auth','0012_alter_user_first_name_max_length','2024-04-28 17:46:48.051908'),(18,'django_registration','0001_initial','2024-04-28 17:46:48.058901'),(21,'sessions','0001_initial','2024-04-28 17:50:18.397307'),(22,'registration','0001_initial','2024-04-28 18:23:35.268862'),(23,'registration','0002_alter_podcaster_email','2024-04-28 19:26:34.001147');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `downloaded_song`
--

DROP TABLE IF EXISTS `downloaded_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `downloaded_song` (
  `id_song` varchar(36) NOT NULL,
  `email_downloader` varchar(50) NOT NULL,
  PRIMARY KEY (`id_song`,`email_downloader`),
  KEY `email_downloader` (`email_downloader`),
  CONSTRAINT `downloaded_song_ibfk_1` FOREIGN KEY (`id_song`) REFERENCES `song` (`id_konten`),
  CONSTRAINT `downloaded_song_ibfk_2` FOREIGN KEY (`email_downloader`) REFERENCES `premium` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `downloaded_song`
--

LOCK TABLES `downloaded_song` WRITE;
/*!40000 ALTER TABLE `downloaded_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `downloaded_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `episode`
--

DROP TABLE IF EXISTS `episode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `episode` (
  `id_episode` varchar(36) NOT NULL,
  `id_konten_podcast` varchar(36) DEFAULT NULL,
  `judul` varchar(100) NOT NULL,
  `deskripsi` varchar(500) NOT NULL,
  `durasi` int NOT NULL,
  `tanggal_rilis` date NOT NULL,
  PRIMARY KEY (`id_episode`),
  KEY `id_konten_podcast` (`id_konten_podcast`),
  CONSTRAINT `episode_ibfk_1` FOREIGN KEY (`id_konten_podcast`) REFERENCES `podcast` (`id_konten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `episode`
--

LOCK TABLES `episode` WRITE;
/*!40000 ALTER TABLE `episode` DISABLE KEYS */;
/*!40000 ALTER TABLE `episode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genre` (
  `id_konten` varchar(36) NOT NULL,
  `genre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_konten`,`genre`),
  CONSTRAINT `genre_ibfk_1` FOREIGN KEY (`id_konten`) REFERENCES `konten` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `konten`
--

DROP TABLE IF EXISTS `konten`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `konten` (
  `id` varchar(36) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `tanggal_rilis` date NOT NULL,
  `tahun` int NOT NULL,
  `durasi` int NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `CHK_durasi` CHECK ((`durasi` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `konten`
--

LOCK TABLES `konten` WRITE;
/*!40000 ALTER TABLE `konten` DISABLE KEYS */;
INSERT INTO `konten` VALUES ('550e8400-e29b-41d4-a716-446655440000','Song 1','2024-04-30',2024,180),('550e8400-e29b-41d4-a716-446655440001','Song 2','2024-04-30',2024,200),('550e8400-e29b-41d4-a716-446655440002','Song 3','2024-04-30',2024,220),('550e8400-e29b-41d4-a716-446655440003','Song 4','2024-04-30',2024,240),('550e8400-e29b-41d4-a716-446655440004','Song 5','2024-04-30',2024,260),('550e8400-e29b-41d4-a716-446655440005','Song 6','2024-04-30',2024,280);
/*!40000 ALTER TABLE `konten` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `label`
--

DROP TABLE IF EXISTS `label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `label` (
  `id` varchar(36) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(50) NOT NULL,
  `kontak` varchar(50) NOT NULL,
  `id_pemilik_hak_cipta` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `id_pemilik_hak_cipta` (`id_pemilik_hak_cipta`),
  CONSTRAINT `label_ibfk_2` FOREIGN KEY (`id_pemilik_hak_cipta`) REFERENCES `pemilik_hak_cipta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `label`
--

LOCK TABLES `label` WRITE;
/*!40000 ALTER TABLE `label` DISABLE KEYS */;
INSERT INTO `label` VALUES ('550e8400-e29b-41d4-a716-446655440040','MyLabel','label@example.com','labelpassword123','1234567890','550e8400-e29b-41d4-a716-446655440050');
/*!40000 ALTER TABLE `label` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nonpremium`
--

DROP TABLE IF EXISTS `nonpremium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nonpremium` (
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `nonpremium_ibfk_1` FOREIGN KEY (`email`) REFERENCES `akun` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nonpremium`
--

LOCK TABLES `nonpremium` WRITE;
/*!40000 ALTER TABLE `nonpremium` DISABLE KEYS */;
/*!40000 ALTER TABLE `nonpremium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paket`
--

DROP TABLE IF EXISTS `paket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paket` (
  `jenis` varchar(50) NOT NULL,
  `harga` int NOT NULL,
  PRIMARY KEY (`jenis`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paket`
--

LOCK TABLES `paket` WRITE;
/*!40000 ALTER TABLE `paket` DISABLE KEYS */;
/*!40000 ALTER TABLE `paket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pemilik_hak_cipta`
--

DROP TABLE IF EXISTS `pemilik_hak_cipta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pemilik_hak_cipta` (
  `id` varchar(36) NOT NULL,
  `rate_royalti` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pemilik_hak_cipta`
--

LOCK TABLES `pemilik_hak_cipta` WRITE;
/*!40000 ALTER TABLE `pemilik_hak_cipta` DISABLE KEYS */;
INSERT INTO `pemilik_hak_cipta` VALUES ('550e8400-e29b-41d4-a716-446655440050',10),('c35d8c90434b4b3c9e40df37276f0461',0),('f71965bb519f4dd89ce1dd2476088555',0);
/*!40000 ALTER TABLE `pemilik_hak_cipta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist`
--

DROP TABLE IF EXISTS `playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist` (
  `id` varchar(36) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist`
--

LOCK TABLES `playlist` WRITE;
/*!40000 ALTER TABLE `playlist` DISABLE KEYS */;
INSERT INTO `playlist` VALUES ('01061ba50b7a487e8639948e71cfd19a'),('9852ba5a4646460f96ab602e57cf91d3'),('a494bed1476c4cdbba238321aa4a693c'),('a6a7b53ef66a434ca3b140f9825b740d');
/*!40000 ALTER TABLE `playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_song`
--

DROP TABLE IF EXISTS `playlist_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_song` (
  `id_playlist` varchar(36) DEFAULT NULL,
  `id_song` varchar(36) DEFAULT NULL,
  KEY `id_playlist` (`id_playlist`),
  KEY `id_song` (`id_song`),
  CONSTRAINT `playlist_song_ibfk_1` FOREIGN KEY (`id_playlist`) REFERENCES `playlist` (`id`),
  CONSTRAINT `playlist_song_ibfk_2` FOREIGN KEY (`id_song`) REFERENCES `song` (`id_konten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_song`
--

LOCK TABLES `playlist_song` WRITE;
/*!40000 ALTER TABLE `playlist_song` DISABLE KEYS */;
INSERT INTO `playlist_song` VALUES ('01061ba50b7a487e8639948e71cfd19a','550e8400-e29b-41d4-a716-446655440001'),('01061ba50b7a487e8639948e71cfd19a','550e8400-e29b-41d4-a716-446655440004'),('01061ba50b7a487e8639948e71cfd19a','550e8400-e29b-41d4-a716-446655440002'),('01061ba50b7a487e8639948e71cfd19a','550e8400-e29b-41d4-a716-446655440001'),('a494bed1476c4cdbba238321aa4a693c','550e8400-e29b-41d4-a716-446655440003');
/*!40000 ALTER TABLE `playlist_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `podcast`
--

DROP TABLE IF EXISTS `podcast`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `podcast` (
  `id_konten` varchar(36) NOT NULL,
  `email_podcaster` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_konten`),
  KEY `email_podcaster` (`email_podcaster`),
  CONSTRAINT `podcast_ibfk_1` FOREIGN KEY (`id_konten`) REFERENCES `konten` (`id`),
  CONSTRAINT `podcast_ibfk_2` FOREIGN KEY (`email_podcaster`) REFERENCES `podcaster` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `podcast`
--

LOCK TABLES `podcast` WRITE;
/*!40000 ALTER TABLE `podcast` DISABLE KEYS */;
/*!40000 ALTER TABLE `podcast` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `podcaster`
--

DROP TABLE IF EXISTS `podcaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `podcaster` (
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `podcaster_ibfk_1` FOREIGN KEY (`email`) REFERENCES `akun` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `podcaster`
--

LOCK TABLES `podcaster` WRITE;
/*!40000 ALTER TABLE `podcaster` DISABLE KEYS */;
INSERT INTO `podcaster` VALUES ('coba@coba.com');
/*!40000 ALTER TABLE `podcaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `premium`
--

DROP TABLE IF EXISTS `premium`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `premium` (
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`email`),
  CONSTRAINT `premium_ibfk_1` FOREIGN KEY (`email`) REFERENCES `akun` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `premium`
--

LOCK TABLES `premium` WRITE;
/*!40000 ALTER TABLE `premium` DISABLE KEYS */;
/*!40000 ALTER TABLE `premium` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_artist`
--

DROP TABLE IF EXISTS `registration_artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_artist` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pemilik_hak_cipta` char(32) NOT NULL,
  `email_akun_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `registration_artist_email_akun_id_44bbc685_fk_registrat` (`email_akun_id`),
  CONSTRAINT `registration_artist_email_akun_id_44bbc685_fk_registrat` FOREIGN KEY (`email_akun_id`) REFERENCES `registration_user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_artist`
--

LOCK TABLES `registration_artist` WRITE;
/*!40000 ALTER TABLE `registration_artist` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_pemilikhakcipta`
--

DROP TABLE IF EXISTS `registration_pemilikhakcipta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_pemilikhakcipta` (
  `id` char(32) NOT NULL,
  `rate_royalti` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_pemilikhakcipta`
--

LOCK TABLES `registration_pemilikhakcipta` WRITE;
/*!40000 ALTER TABLE `registration_pemilikhakcipta` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_pemilikhakcipta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_podcaster`
--

DROP TABLE IF EXISTS `registration_podcaster`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_podcaster` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `registration_podcast_email_id_43b15dfc_fk_registrat` (`email_id`),
  CONSTRAINT `registration_podcast_email_id_43b15dfc_fk_registrat` FOREIGN KEY (`email_id`) REFERENCES `registration_user` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_podcaster`
--

LOCK TABLES `registration_podcaster` WRITE;
/*!40000 ALTER TABLE `registration_podcaster` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_podcaster` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_songwriter`
--

DROP TABLE IF EXISTS `registration_songwriter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_songwriter` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `id_pemilik_hak_cipta` char(32) NOT NULL,
  `email_akun_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `registration_songwri_email_akun_id_f309d8af_fk_registrat` (`email_akun_id`),
  CONSTRAINT `registration_songwri_email_akun_id_f309d8af_fk_registrat` FOREIGN KEY (`email_akun_id`) REFERENCES `registration_user` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_songwriter`
--

LOCK TABLES `registration_songwriter` WRITE;
/*!40000 ALTER TABLE `registration_songwriter` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_songwriter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_user`
--

DROP TABLE IF EXISTS `registration_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_user` (
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `gender` int NOT NULL,
  `tempat_lahir` varchar(50) NOT NULL,
  `tanggal_lahir` date NOT NULL,
  `is_verified` tinyint(1) NOT NULL,
  `kota_asal` varchar(50) NOT NULL,
  `role` varchar(100) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_user`
--

LOCK TABLES `registration_user` WRITE;
/*!40000 ALTER TABLE `registration_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `registration_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `royalti`
--

DROP TABLE IF EXISTS `royalti`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `royalti` (
  `id_pemilik_hak_cipta` varchar(36) NOT NULL,
  `id_song` varchar(36) NOT NULL,
  `jumlah` int NOT NULL,
  PRIMARY KEY (`id_pemilik_hak_cipta`,`id_song`),
  KEY `id_song` (`id_song`),
  CONSTRAINT `royalti_ibfk_1` FOREIGN KEY (`id_pemilik_hak_cipta`) REFERENCES `pemilik_hak_cipta` (`id`),
  CONSTRAINT `royalti_ibfk_2` FOREIGN KEY (`id_song`) REFERENCES `song` (`id_konten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `royalti`
--

LOCK TABLES `royalti` WRITE;
/*!40000 ALTER TABLE `royalti` DISABLE KEYS */;
/*!40000 ALTER TABLE `royalti` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `song`
--

DROP TABLE IF EXISTS `song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `song` (
  `id_konten` varchar(36) NOT NULL,
  `id_artist` varchar(36) DEFAULT NULL,
  `id_album` varchar(36) DEFAULT NULL,
  `total_play` int NOT NULL DEFAULT '0',
  `total_download` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_konten`),
  KEY `id_artist` (`id_artist`),
  KEY `id_album` (`id_album`),
  CONSTRAINT `song_ibfk_1` FOREIGN KEY (`id_konten`) REFERENCES `konten` (`id`),
  CONSTRAINT `song_ibfk_2` FOREIGN KEY (`id_artist`) REFERENCES `artist` (`id`),
  CONSTRAINT `song_ibfk_3` FOREIGN KEY (`id_album`) REFERENCES `album` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `song`
--

LOCK TABLES `song` WRITE;
/*!40000 ALTER TABLE `song` DISABLE KEYS */;
INSERT INTO `song` VALUES ('550e8400-e29b-41d4-a716-446655440000','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',0,0),('550e8400-e29b-41d4-a716-446655440001','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',29,2),('550e8400-e29b-41d4-a716-446655440002','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',0,0),('550e8400-e29b-41d4-a716-446655440003','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',0,0),('550e8400-e29b-41d4-a716-446655440004','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',0,0),('550e8400-e29b-41d4-a716-446655440005','550e8400-e29b-41d4-a716-446655440020','550e8400-e29b-41d4-a716-446655440010',0,0);
/*!40000 ALTER TABLE `song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songwriter`
--

DROP TABLE IF EXISTS `songwriter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songwriter` (
  `id` varchar(36) NOT NULL,
  `email_akun` varchar(50) DEFAULT NULL,
  `id_pemilik_hak_cipta` varchar(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `email_akun` (`email_akun`),
  KEY `id_pemilik_hak_cipta` (`id_pemilik_hak_cipta`),
  CONSTRAINT `songwriter_ibfk_1` FOREIGN KEY (`email_akun`) REFERENCES `akun` (`email`),
  CONSTRAINT `songwriter_ibfk_2` FOREIGN KEY (`id_pemilik_hak_cipta`) REFERENCES `pemilik_hak_cipta` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songwriter`
--

LOCK TABLES `songwriter` WRITE;
/*!40000 ALTER TABLE `songwriter` DISABLE KEYS */;
INSERT INTO `songwriter` VALUES ('08d88d716b9c4e88b0fdacf446302693','coba@coba.com','c35d8c90434b4b3c9e40df37276f0461'),('9d48f6c5024e4beda889b52c096339d6','awal14h@gmail.com','f71965bb519f4dd89ce1dd2476088555');
/*!40000 ALTER TABLE `songwriter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songwriter_write_song`
--

DROP TABLE IF EXISTS `songwriter_write_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songwriter_write_song` (
  `id_songwriter` varchar(36) NOT NULL,
  `id_song` varchar(36) NOT NULL,
  PRIMARY KEY (`id_songwriter`,`id_song`),
  KEY `id_song` (`id_song`),
  CONSTRAINT `songwriter_write_song_ibfk_1` FOREIGN KEY (`id_songwriter`) REFERENCES `songwriter` (`id`),
  CONSTRAINT `songwriter_write_song_ibfk_2` FOREIGN KEY (`id_song`) REFERENCES `song` (`id_konten`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songwriter_write_song`
--

LOCK TABLES `songwriter_write_song` WRITE;
/*!40000 ALTER TABLE `songwriter_write_song` DISABLE KEYS */;
/*!40000 ALTER TABLE `songwriter_write_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `id` varchar(36) NOT NULL,
  `jenis_paket` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `timestamp_dimulai` timestamp NOT NULL,
  `timestamp_berakhir` timestamp NOT NULL,
  `metode_bayar` varchar(50) NOT NULL,
  `nominal` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jenis_paket` (`jenis_paket`),
  KEY `email` (`email`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`jenis_paket`) REFERENCES `paket` (`jenis`),
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`email`) REFERENCES `akun` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_playlist`
--

DROP TABLE IF EXISTS `user_playlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_playlist` (
  `email_pembuat` varchar(50) NOT NULL,
  `id_user_playlist` varchar(36) NOT NULL,
  `judul` varchar(100) NOT NULL,
  `deskripsi` varchar(500) NOT NULL,
  `jumlah_lagu` int NOT NULL,
  `tanggal_dibuat` date NOT NULL,
  `id_playlist` varchar(36) DEFAULT NULL,
  `total_durasi` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`email_pembuat`,`id_user_playlist`),
  KEY `id_playlist` (`id_playlist`),
  KEY `idx_user_playlist_id` (`id_user_playlist`),
  CONSTRAINT `user_playlist_ibfk_1` FOREIGN KEY (`email_pembuat`) REFERENCES `akun` (`email`),
  CONSTRAINT `user_playlist_ibfk_2` FOREIGN KEY (`id_playlist`) REFERENCES `playlist` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_playlist`
--

LOCK TABLES `user_playlist` WRITE;
/*!40000 ALTER TABLE `user_playlist` DISABLE KEYS */;
INSERT INTO `user_playlist` VALUES ('coba@coba.com','84eac9d210d140a097b8dbd029d136e6','playlist1ku','coba',1,'2024-04-30','a494bed1476c4cdbba238321aa4a693c',0);
/*!40000 ALTER TABLE `user_playlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'marmut'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-04-30 21:47:42
