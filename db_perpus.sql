-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 25, 2025 at 03:57 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBuku` (IN `id` INT)   BEGIN
    DELETE FROM buku WHERE id_buku = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllBuku` ()   BEGIN
    SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBuku` (IN `judul` VARCHAR(255), IN `penulis` VARCHAR(100), IN `kategori` VARCHAR(50), IN `stok` INT)   BEGIN
    INSERT INTO buku (judul_buku, penulis, kategori, stok) VALUES (judul, penulis, kategori, stok);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `KembalikanBuku` (IN `pinjam_id` INT)   BEGIN
    UPDATE peminjaman SET status = 'Dikembalikan', tanggal_kembali = CURDATE() WHERE id_peminjaman = pinjam_id;
    UPDATE buku SET stok = stok + 1 WHERE id_buku = (SELECT id_buku FROM peminjaman WHERE id_peminjaman = pinjam_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `PinjamBuku` (IN `siswa_id` INT, IN `buku_id` INT, IN `tgl_pinjam` DATE, IN `tgl_kembali` DATE)   BEGIN
    INSERT INTO peminjaman (id_siswa, id_buku, tanggal_pinjam, tanggal_kembali, status) VALUES (siswa_id, buku_id, tgl_pinjam, tgl_kembali, 'Dipinjam');
    UPDATE buku SET stok = stok - 1 WHERE id_buku = buku_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SemuaBuku` ()   BEGIN
    SELECT b.id_buku, b.judul_buku, b.penulis, b.kategori, b.stok, IFNULL(p.id_peminjaman, 'Belum Pernah Dipinjam') AS status_peminjaman
    FROM buku b LEFT JOIN peminjaman p ON b.id_buku = p.id_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SemuaSiswa` ()   BEGIN
    SELECT s.id_siswa, s.nama, s.kelas, IFNULL(p.id_peminjaman, 'Belum Meminjam') AS status_peminjaman
    FROM siswa s LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SiswaPernahPinjam` ()   BEGIN
    SELECT DISTINCT s.id_siswa, s.nama, s.kelas FROM siswa s
    JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBuku` (IN `id` INT, IN `new_stok` INT)   BEGIN
    UPDATE buku SET stok = new_stok WHERE id_buku = id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(255) DEFAULT NULL,
  `penulis` varchar(100) DEFAULT NULL,
  `kategori` varchar(50) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `penulis`, `kategori`, `stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 7),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 4),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8);

-- --------------------------------------------------------

--
-- Table structure for table `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `kelas` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama`, `kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL');

-- --------------------------------------------------------

--
-- Table structure for table `tabel_buku`
--

CREATE TABLE `tabel_buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(50) NOT NULL,
  `penulis` varchar(50) NOT NULL,
  `kategori` varchar(50) NOT NULL,
  `stok` int(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tabel_peminjaman`
--

CREATE TABLE `tabel_peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_siswa` int(11) NOT NULL,
  `id_buku` int(11) NOT NULL,
  `tanggal_pinjam` date NOT NULL,
  `tanggal_kembali` date NOT NULL,
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tabel_peminjaman`
--

INSERT INTO `tabel_peminjaman` (`id_peminjaman`, `id_siswa`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 1, 1, '2025-02-01', '2025-02-08', 'Dipinjam'),
(2, 2, 2, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 3, '2025-02-02', '2025-02-09', 'Dipinjam'),
(4, 4, 4, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 5, '2025-01-25', '2025-02-01', 'Dikembalikan');

-- --------------------------------------------------------

--
-- Table structure for table `tabel_siswa`
--

CREATE TABLE `tabel_siswa` (
  `id_siswa` int(11) NOT NULL,
  `nama` varchar(50) NOT NULL,
  `kelas` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- Indexes for table `tabel_buku`
--
ALTER TABLE `tabel_buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indexes for table `tabel_peminjaman`
--
ALTER TABLE `tabel_peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`);

--
-- Indexes for table `tabel_siswa`
--
ALTER TABLE `tabel_siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tabel_buku`
--
ALTER TABLE `tabel_buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tabel_peminjaman`
--
ALTER TABLE `tabel_peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tabel_siswa`
--
ALTER TABLE `tabel_siswa`
  MODIFY `id_siswa` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
