/*
 Navicat Premium Data Transfer

 Source Server         : mysql
 Source Server Type    : MySQL
 Source Server Version : 80044 (8.0.44)
 Source Host           : localhost:3306
 Source Schema         : book_manager

 Target Server Type    : MySQL
 Target Server Version : 80044 (8.0.44)
 File Encoding         : 65001

 Date: 06/03/2026 02:00:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for book_info
-- ----------------------------
DROP TABLE IF EXISTS `book_info`;
CREATE TABLE `book_info`  (
  `bookId` int NOT NULL AUTO_INCREMENT,
  `bookName` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bookAuthor` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bookPrice` decimal(10, 2) NOT NULL,
  `bookTypeId` int NOT NULL,
  `bookDesc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Book Description',
  `isBorrowed` tinyint NOT NULL COMMENT '1 borrowed, 0 returned',
  `bookImg` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT 'Book cover image',
  PRIMARY KEY (`bookId`) USING BTREE,
  INDEX `fk_book_info_book_type_1`(`bookTypeId` ASC) USING BTREE,
  CONSTRAINT `book_info_ibfk_1` FOREIGN KEY (`bookTypeId`) REFERENCES `book_type` (`bookTypeId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_info
-- ----------------------------
INSERT INTO `book_info` VALUES (1, 'Python Crash Course', 'Eric Matthes', 10.00, 1, 'A hands-on Python beginner\'s guide to master programming skills quickly', 0, '/pic/202111112241065.jpg');
INSERT INTO `book_info` VALUES (2, 'One Hundred Years of Solitude	', 'Gabriel García Márquez', 14.80, 3, 'A magical realism classic about the Buendía family\'s century-long rise and fall', 0, '/pic/202111112140064.jpg');
INSERT INTO `book_info` VALUES (4, 'Dune Messiah', 'Frank Herbert', 12.00, 4, 'The sequel to Dune, an epic of power and religious rivalry in the empire', 1, '/pic/202111112242308.jpg');
INSERT INTO `book_info` VALUES (5, 'Effective Java', 'Joshua Bloch', 15.00, 1, 'An advanced Java guide, the industry-recognized bible of programming practices', 0, '/pic/1637334053325javascript.jpg');
INSERT INTO `book_info` VALUES (12, 'The Lord of the Rings', 'J.R.R. Tolkien', 18.00, 6, 'A Middle-earth epic: the Fellowship\'s dark journey and redemption', 0, '/pic/202111112143793.jpg');
INSERT INTO `book_info` VALUES (13, 'English Grammar in Use', 'Raymond Murphy', 15.00, 7, 'A practical English grammar guide for self-study and exam improvement', 0, '/pic/202111112143943.jpg');
INSERT INTO `book_info` VALUES (14, 'Foundation and Empire', 'Isaac Asimov', 12.50, 4, 'The sequel to Foundation, on the Galactic Empire\'s decline and civilization\'s rebirth', 0, '/pic/202111112143125.jpg');
INSERT INTO `book_info` VALUES (27, 'Charlotte\'s Web', 'E.B. White', 14.00, 6, 'Heartwarming children’s story of friendship between a spider and a pig', 0, '/pic/2026-03-05 223619.jpg');
INSERT INTO `book_info` VALUES (28, '1984', 'George Orwell', 11.20, 2, 'A dystopian classic about thought control and resistance in a totalitarian society', 0, '/pic/2026-03-06 013056.jpg');
INSERT INTO `book_info` VALUES (30, 'Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', 20.00, 6, 'Debut of Harry Potter: magical adventure in Hogwarts School', 0, '/pic/1637224588022C.jpg');
INSERT INTO `book_info` VALUES (31, 'Clean Code', 'Robert C. Martin', 16.00, 1, 'A classic guide to writing readable, maintainable code—ideal for developers improving code quality', 0, '/pic/2026-03-06 013238.jpg');
INSERT INTO `book_info` VALUES (32, 'Pride and Prejudice', 'Jane Austen', 12.50, 3, 'Jane Austen’s timeless romance novel, exploring class, prejudice and love', 0, '/pic/2026-03-06 013532.jpg');
INSERT INTO `book_info` VALUES (33, 'The Martian', 'Andy Weir', 10.00, 4, 'A hard sci-fi story about an astronaut’s solo survival mission on Mars', 0, '/pic/2026-03-06 013717.jpg');
INSERT INTO `book_info` VALUES (34, 'Meditations', 'Marcus Aurelius', 11.50, 2, 'The Roman emperor’s philosophical essays on self-reflection and Stoicism', 0, '/pic/2026-03-06 013822.jpg');
INSERT INTO `book_info` VALUES (36, 'Head First Java', 'Kathy Sierra', 22.00, 1, 'A fun, visual Java beginner’s book that explains core concepts in an approachable way', 0, '/pic/2026-03-06 013933.jpg');
INSERT INTO `book_info` VALUES (37, 'The Hobbit', 'J.R.R. Tolkien	', 18.00, 6, 'Prequel to The Lord of the Rings, following Bilbo Baggins’ Middle-earth adventure', 0, '/pic/2026-03-06 014021.jpg');
INSERT INTO `book_info` VALUES (38, '	Fluent English', 'Susan Stempleski	', 20.00, 7, 'A practical guide to boosting English fluency, with oral practice tips', 0, '/pic/2026-03-06 014126.jpg');
INSERT INTO `book_info` VALUES (39, 'To Kill a Mockingbird', 'Harper Lee', 16.00, 3, 'An American literary classic about racial justice and moral growth', 0, '/pic/2026-03-06 014231.jpg');
INSERT INTO `book_info` VALUES (40, 'A People\'s History of the United States', 'Howard Zinn', 22.50, 2, 'An alternative U.S. history focusing on marginalized groups\' struggles', 0, '/pic/2026-03-06 014324.jpg');
INSERT INTO `book_info` VALUES (41, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', 20.00, 4, 'A popular science book tracing human evolution from hominids to modernity', 0, '/pic/2026-03-06 014448.jpg');
INSERT INTO `book_info` VALUES (43, 'New Revelations of the Americas Before Columbus', 'Charles C. Mann', 14.00, 2, 'Reveals advanced pre-Columbian American civilizations', 0, '/pic/2026-03-06 014632.jpg');
INSERT INTO `book_info` VALUES (44, 'The Selfish Gene', 'Richard Dawkins', 13.50, 4, 'Frames genes as evolution’s core driving force (foundational science)', 0, '/pic/2026-03-06 014728.jpg');
INSERT INTO `book_info` VALUES (45, 'Steve Jobs', 'Walter Isaacson', 12.00, 2, 'Official biography of Apple’s co-founder & his innovation journey', 0, '/pic/2026-03-06 014905.jpg');

-- ----------------------------
-- Table structure for book_type
-- ----------------------------
DROP TABLE IF EXISTS `book_type`;
CREATE TABLE `book_type`  (
  `bookTypeId` int NOT NULL AUTO_INCREMENT,
  `bookTypeName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bookTypeDesc` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT 'Book Type Description',
  PRIMARY KEY (`bookTypeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of book_type
-- ----------------------------
INSERT INTO `book_type` VALUES (1, 'Computer Science', 'Computer-related');
INSERT INTO `book_type` VALUES (2, 'History', 'History-related');
INSERT INTO `book_type` VALUES (3, 'Literature', 'Literature-related');
INSERT INTO `book_type` VALUES (4, 'Science fiction', 'Science fiction-related');
INSERT INTO `book_type` VALUES (6, 'Novel', 'Novel-related');
INSERT INTO `book_type` VALUES (7, 'Foreign language', 'Foreign language-related');

-- ----------------------------
-- Table structure for borrow
-- ----------------------------
DROP TABLE IF EXISTS `borrow`;
CREATE TABLE `borrow`  (
  `borrowId` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL,
  `bookId` int NOT NULL,
  `borrowTime` datetime NOT NULL,
  `returnTime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`borrowId`) USING BTREE,
  INDEX `fk_borrow_user_1`(`userId` ASC) USING BTREE,
  INDEX `fk_borrow_book_info_1`(`bookId` ASC) USING BTREE,
  CONSTRAINT `borrow_ibfk_1` FOREIGN KEY (`bookId`) REFERENCES `book_info` (`bookId`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `borrow_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user` (`userId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of borrow
-- ----------------------------
INSERT INTO `borrow` VALUES (26, 11, 2, '2025-12-18 14:24:06', '2026-01-01 16:07:03');
INSERT INTO `borrow` VALUES (41, 2, 1, '2025-11-18 17:49:10', '2025-11-28 02:40:37');
INSERT INTO `borrow` VALUES (42, 1, 4, '2025-11-28 00:55:56', '2026-01-01 00:39:24');
INSERT INTO `borrow` VALUES (43, 11, 2, '2025-11-28 02:39:02', '2025-11-28 02:39:09');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `userId` int NOT NULL AUTO_INCREMENT,
  `userName` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `userPassword` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `isAdmin` tinyint NOT NULL COMMENT '1 administrator, 0 non-administrator.',
  PRIMARY KEY (`userId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin', 1);
INSERT INTO `user` VALUES (2, 'Li ming', '123456', 0);
INSERT INTO `user` VALUES (11, 'zhang', '123', 0);
INSERT INTO `user` VALUES (13, 'zhao', 'abc', 1);
INSERT INTO `user` VALUES (14, 'user', '123456', 0);

SET FOREIGN_KEY_CHECKS = 1;
