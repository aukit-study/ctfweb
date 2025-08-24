-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2025 at 06:08 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ctf_web`
--

-- --------------------------------------------------------

--
-- Table structure for table `challenges`
--

CREATE TABLE `challenges` (
  `id` int(11) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `challenge_name` varchar(255) NOT NULL,
  `solve` text NOT NULL,
  `flag` varchar(255) NOT NULL,
  `points` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `challenges`
--

INSERT INTO `challenges` (`id`, `group_name`, `challenge_name`, `solve`, `flag`, `points`) VALUES
(1, 'Cryptography', 'CyberChef', 'Decrypt text (To Hex  Delimiter:Space): 33 34 20 33 39 20 32 30 20 33 34 20 33 33 20 32 30 20 33 35 20 33 34 20 32 30 20 33 35 20 33 38 20 32 30 20 33 35 20 33 35 20 32 30 20 33 35 20 33 32 20 32 30 20 33 35 20 33 35 20 32 30 20 33 37 20 36 32 20 32 30 20 33 34 20 33 34 20 32 30 20 33 34 20 33 35 20 32 30 20 33 34 20 33 33 20 32 30 20 33 34 20 36 36 20 32 30 20 33 34 20 33 34 20 32 30 20 33 34 20 33 35 20 32 30 20 33 34 20 33 34 20 32 30 20 33 33 20 33 31 20 32 30 20 33 37 20 36 34', 'ICTXURU{DECODED1}', 10),
(2, 'Cryptography', 'CyberChef 2', 'Base64 : SUNUWFVSVXtERUNPREVEMn0=', 'ICTXURU{DECODED2}', 10),
(3, 'Cryptography', 'Page source', '154.215.14.174:5000/404', '5555555 is basic', 10),
(4, 'Steganography', 'Photo 1', 'Find the hidden message in the image. (1photo.JPG)\n154.215.14.174/download', 'ICTXURU{PHOTO_FLAG1@}', 10),
(5, 'Steganography', 'steghide', 'Where location in image (KFC.jpeg)[english only]\n154.215.14.174/download', 'ICTXURU{steghide_@}', 10),
(6, 'Investigate', 'Metadata', 'what is the flag (steghide.jpg)\n154.215.14.174/download', 'Sripong Park', 10),
(7, 'special slove', 'From Aukit', 'key=cyberninjaishere; ipid=10.14.0.154_30315673; PSRU=bfde6c5aa2b6248f396b1f0230cd6d58', '', 30);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `score` int(11) DEFAULT 0,
  `solved_challenges` text DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `name`, `password`, `score`, `solved_challenges`) VALUES
(10, 'Aukit', 'อุกฤษฏ์ ตันติศุภรักษ์', 'Aukit', 30, ''),
(11, 'flo', 'flo', '1234', 10, ''),
(12, 'Test', 'Test', 'Test', 90, '');

-- --------------------------------------------------------

--
-- Table structure for table `user_solved`
--

CREATE TABLE `user_solved` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `challenge_id` int(11) NOT NULL,
  `solved_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_solved`
--

INSERT INTO `user_solved` (`id`, `user_id`, `challenge_id`, `solved_at`) VALUES
(4, 10, 1, '2025-02-01 13:27:51'),
(5, 10, 2, '2025-02-01 13:28:02'),
(6, 10, 3, '2025-02-01 13:28:17'),
(7, 11, 1, '2025-02-01 13:30:19'),
(8, 12, 7, '2025-02-01 13:33:39'),
(9, 12, 1, '2025-02-01 13:34:04'),
(10, 12, 2, '2025-02-01 13:34:09'),
(11, 12, 3, '2025-02-01 13:34:41'),
(12, 12, 6, '2025-02-01 14:30:30'),
(13, 12, 4, '2025-02-01 14:30:45'),
(14, 12, 5, '2025-02-01 14:30:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `challenges`
--
ALTER TABLE `challenges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_solved`
--
ALTER TABLE `user_solved`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`challenge_id`),
  ADD KEY `challenge_id` (`challenge_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `challenges`
--
ALTER TABLE `challenges`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_solved`
--
ALTER TABLE `user_solved`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `user_solved`
--
ALTER TABLE `user_solved`
  ADD CONSTRAINT `user_solved_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `user_solved_ibfk_2` FOREIGN KEY (`challenge_id`) REFERENCES `challenges` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
