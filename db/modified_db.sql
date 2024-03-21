-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: events
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `booking` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `customer_id` int DEFAULT NULL,
  `booking_date` date DEFAULT NULL,
  `booking_time` varchar(45) DEFAULT NULL,
  `booking_venue` varchar(45) DEFAULT NULL,
  `no_of_persons` varchar(45) DEFAULT NULL,
  `booking_status` varchar(45) DEFAULT NULL,
  `booking_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`booking_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (4,1,1,'2024-02-16','11:00 AM - 12:00 PM','Restaurant','2500','Paid','Online'),(5,1,1,'2024-02-28','04:00 PM - 05:00 PM','Sports Stadium','50000','Accepted','Online');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `complaint`
--

DROP TABLE IF EXISTS `complaint`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `complaint` (
  `complaint_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `complaint` varchar(45) DEFAULT NULL,
  `reply` varchar(45) DEFAULT NULL,
  `complaint_date` date DEFAULT NULL,
  PRIMARY KEY (`complaint_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `complaint`
--

LOCK TABLES `complaint` WRITE;
/*!40000 ALTER TABLE `complaint` DISABLE KEYS */;
INSERT INTO `complaint` VALUES (1,1,'what is this?','Nothing!!!','2023-12-05'),(2,1,'ggk gkgk vkgkhkhk vjgkgkgk vkvkvkbkhkhkhk ','khlhhckgkgkhlhlhlhlbbl jvkvkvkvlblblb','2024-02-16');
/*!40000 ALTER TABLE `complaint` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costume`
--

DROP TABLE IF EXISTS `costume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `costume` (
  `designer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`designer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costume`
--

LOCK TABLES `costume` WRITE;
/*!40000 ALTER TABLE `costume` DISABLE KEYS */;
INSERT INTO `costume` VALUES (2,'aparnaa','Thrissur ','appu@gmail.com','9852147523');
/*!40000 ALTER TABLE `costume` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_events`
--

DROP TABLE IF EXISTS `custom_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_events` (
  `custom_event_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `event_name` varchar(45) DEFAULT NULL,
  `budget` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `no_of_persons` varchar(45) DEFAULT NULL,
  `event_date` varchar(45) DEFAULT NULL,
  `event_status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`custom_event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_events`
--

LOCK TABLES `custom_events` WRITE;
/*!40000 ALTER TABLE `custom_events` DISABLE KEYS */;
INSERT INTO `custom_events` VALUES (32,6,'gugui','258.0','Community Center','500','2024-03-17 00:00:00.000','Accepted'),(33,1,'ibhi','500.0','Restaurant','580','2024-03-17 00:00:00.000','proposal send');
/*!40000 ALTER TABLE `custom_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer1`
--

DROP TABLE IF EXISTS `customer1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer1` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `login_id` int DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `gender` varchar(45) DEFAULT NULL,
  `house_name` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `pincode` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer1`
--

LOCK TABLES `customer1` WRITE;
/*!40000 ALTER TABLE `customer1` DISABLE KEYS */;
INSERT INTO `customer1` VALUES (1,1,'liya','antony','Female','ffffgg','thrissur','680563','liya@gmail.com','6789045367'),(6,13,'lijo','antony','Male','ncj','ncnv','258147','l@gmail.com','4852369075');
/*!40000 ALTER TABLE `customer1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customeventfoods`
--

DROP TABLE IF EXISTS `customeventfoods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customeventfoods` (
  `custom_food_id` int NOT NULL AUTO_INCREMENT,
  `custom_event_id` int DEFAULT NULL,
  `food_id` int DEFAULT NULL,
  PRIMARY KEY (`custom_food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customeventfoods`
--

LOCK TABLES `customeventfoods` WRITE;
/*!40000 ALTER TABLE `customeventfoods` DISABLE KEYS */;
INSERT INTO `customeventfoods` VALUES (3,32,1),(4,32,3),(5,32,4),(6,33,3),(7,33,4);
/*!40000 ALTER TABLE `customeventfoods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customeventpay`
--

DROP TABLE IF EXISTS `customeventpay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customeventpay` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `proposal_id` int DEFAULT NULL,
  `amount` varchar(45) DEFAULT NULL,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customeventpay`
--

LOCK TABLES `customeventpay` WRITE;
/*!40000 ALTER TABLE `customeventpay` DISABLE KEYS */;
INSERT INTO `customeventpay` VALUES (1,1,'500','2023-12-05');
/*!40000 ALTER TABLE `customeventpay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventcategories`
--

DROP TABLE IF EXISTS `eventcategories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventcategories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventcategories`
--

LOCK TABLES `eventcategories` WRITE;
/*!40000 ALTER TABLE `eventcategories` DISABLE KEYS */;
INSERT INTO `eventcategories` VALUES (1,'wedding ');
/*!40000 ALTER TABLE `eventcategories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eventpackages`
--

DROP TABLE IF EXISTS `eventpackages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `eventpackages` (
  `package_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `package_name` varchar(45) DEFAULT NULL,
  `package_description` varchar(45) DEFAULT NULL,
  `package_amount` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='eventpackages (package_id, category_id, package_name, package_description, package_amount)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eventpackages`
--

LOCK TABLES `eventpackages` WRITE;
/*!40000 ALTER TABLE `eventpackages` DISABLE KEYS */;
INSERT INTO `eventpackages` VALUES (3,2,'party','good','500'),(4,1,'haldi','good','500'),(5,1,'vjg','jf','600'),(6,1,'jgj','ncj','500'),(7,1,'igi','jcjg','2500');
/*!40000 ALTER TABLE `eventpackages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `feedback` varchar(500) DEFAULT NULL,
  `feedback_date` date DEFAULT NULL,
  PRIMARY KEY (`feedback_id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
INSERT INTO `feedback` VALUES (1,1,'fggdyn','2023-11-30'),(2,1,'','2023-12-05'),(3,1,'yyyyyyyyyyyyy','2024-02-16'),(34,1,'uvgu','2024-03-07'),(35,1,'','2024-03-07');
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `feedback1`
--

DROP TABLE IF EXISTS `feedback1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback1` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `feedback` varchar(45) DEFAULT NULL,
  `feedback_date` varchar(45) DEFAULT NULL,
  `type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`feedback_id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback1`
--

LOCK TABLES `feedback1` WRITE;
/*!40000 ALTER TABLE `feedback1` DISABLE KEYS */;
INSERT INTO `feedback1` VALUES (23,6,'nicee','2024-03-17','Costume Designers');
/*!40000 ALTER TABLE `feedback1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food` (
  `food_id` int NOT NULL AUTO_INCREMENT,
  `food_name` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `quantity` varchar(45) DEFAULT NULL,
  `serving_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food`
--

LOCK TABLES `food` WRITE;
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
INSERT INTO `food` VALUES (1,'biriyani ','nice','580','common'),(3,'noodles ','hfu','500','common '),(4,'chicken','cjg','500','jfjf');
/*!40000 ALTER TABLE `food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login` (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `login_type` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES (1,'liya@gmail.com','yyyyyyyy','customer'),(2,'admin','admin@12','admin'),(8,'k@gmail.com','uuuuuuuu','staff'),(13,'l@gmail.com','llllllll','customer');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `makeup`
--

DROP TABLE IF EXISTS `makeup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `makeup` (
  `artist_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`artist_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `makeup`
--

LOCK TABLES `makeup` WRITE;
/*!40000 ALTER TABLE `makeup` DISABLE KEYS */;
INSERT INTO `makeup` VALUES (1,'kavitha','Palakkad','kavya@gmail.com','5281472580');
/*!40000 ALTER TABLE `makeup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `packagefoods`
--

DROP TABLE IF EXISTS `packagefoods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `packagefoods` (
  `package_food_id` int NOT NULL AUTO_INCREMENT,
  `package_id` int DEFAULT NULL,
  `food_id` int DEFAULT NULL,
  PRIMARY KEY (`package_food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `packagefoods`
--

LOCK TABLES `packagefoods` WRITE;
/*!40000 ALTER TABLE `packagefoods` DISABLE KEYS */;
INSERT INTO `packagefoods` VALUES (5,7,1),(6,7,4);
/*!40000 ALTER TABLE `packagefoods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment1`
--

DROP TABLE IF EXISTS `payment1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment1` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `amount` varchar(45) DEFAULT NULL,
  `payment_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`payment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment1`
--

LOCK TABLES `payment1` WRITE;
/*!40000 ALTER TABLE `payment1` DISABLE KEYS */;
INSERT INTO `payment1` VALUES (1,4,'500','2024-02-16');
/*!40000 ALTER TABLE `payment1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `proposal`
--

DROP TABLE IF EXISTS `proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `proposal` (
  `proposal_id` int NOT NULL AUTO_INCREMENT,
  `custom_event_id` int DEFAULT NULL,
  `proposal_date` date DEFAULT NULL,
  `proposal_amount` varchar(45) DEFAULT NULL,
  `proposal_status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`proposal_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `proposal`
--

LOCK TABLES `proposal` WRITE;
/*!40000 ALTER TABLE `proposal` DISABLE KEYS */;
INSERT INTO `proposal` VALUES (10,32,'2024-03-17','542','Accepted'),(11,33,'2024-03-17','650','Pending');
/*!40000 ALTER TABLE `proposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `rating_no` int DEFAULT NULL,
  PRIMARY KEY (`rating_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES (1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,1),(7,1,2),(8,1,1),(9,1,1),(10,1,2),(11,1,3),(12,1,4),(13,1,5),(14,1,1),(15,1,5),(16,1,3),(17,1,4),(18,1,1),(19,1,1),(20,1,3),(21,1,4),(22,1,3),(23,1,5),(24,1,3),(25,1,4),(26,1,5),(27,1,2),(28,1,4),(29,1,5),(30,1,3),(31,1,4),(32,1,4),(33,1,5),(34,1,5),(35,1,2),(36,1,2),(37,1,4),(38,1,3),(39,1,4),(40,1,3),(41,1,5),(42,1,3),(43,1,4),(44,1,3),(45,1,2),(46,1,3),(47,1,1),(48,1,3),(49,1,4),(50,1,3),(51,1,3);
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rating1`
--

DROP TABLE IF EXISTS `rating1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rating1` (
  `rating_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `rating_no` int DEFAULT NULL,
  `typee` int DEFAULT NULL,
  PRIMARY KEY (`rating_id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating1`
--

LOCK TABLES `rating1` WRITE;
/*!40000 ALTER TABLE `rating1` DISABLE KEYS */;
INSERT INTO `rating1` VALUES (43,6,3,1),(44,6,4,2);
/*!40000 ALTER TABLE `rating1` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff` (
  `staff_id` int NOT NULL AUTO_INCREMENT,
  `login_id` int DEFAULT NULL,
  `first_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) DEFAULT NULL,
  `gender` varchar(45) DEFAULT NULL,
  `house_name` varchar(45) DEFAULT NULL,
  `place` varchar(45) DEFAULT NULL,
  `pincode` varchar(45) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `phone` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`staff_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,8,'jh','joy','Female','htv','vfv','258963','k@gmail.com','2589631');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-17  7:12:28
