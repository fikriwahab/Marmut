-- Query Pembuatan Skema
CREATE SCHEMA MARMUT;
SET SEARCH_PATH TO MARMUT;

-- Query Pembuatan Tabel

-- Tabel Akun
CREATE TABLE AKUN(
	email VARCHAR(50) PK,
	password VARCHAR(50) NOT NULL,
	nama VARCHAR(100) NOT NULL,
	gender INTEGER NOT NULL,
	tempat_lahir VARCHAR(50) NOT NULL,
	tanggal_lahir DATE NOT NULL,
	is_verified BOOLEAN NOT NULL,
	kota_asal VARCHAR(50) NOT NULL
);

-- Tabel Paket
CREATE TABLE PAKET(
jenis VARCHAR(50) PK,
	harga INTEGER NOT NULL,
);

-- Tabel Transaksi
CREATE TABLE TRANSACTION(
	id UUID,
	jenis_paket VARCHAR(50),
	email VARCHAR(50),
	timestamp_dimulai timestamp NOT NULL,
	timestamp_berakhir timestamp NOT NULL,
	metode_bayar VARCHAR(50) NOT NULL,
	nominal INTEGER NOT NULL,
	PRIMARY KEY (id, jenis_paket, email),
	FOREIGN KEY (jenis_paket) REFERENCES PAKET (jenis) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (email) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Premium
CREATE TABLE PREMIUM(
	email VARCHAR(50) PK,
	FOREIGN KEY (email) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Nonpremium
CREATE TABLE NONPREMIUM(
	email VARCHAR(50) PK,
	FOREIGN KEY (email) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Konten
CREATE TABLE KONTEN(
	id UUID PK,
	judul VARCHAR(100) NOT NULL,
	tanggal_rilis DATE NOT NULL,
	tahun INTEGER NOT NULL,
	durasi INTEGER NOT NULL,
);

-- Tabel Genre
CREATE TABLE GENRE(
	id_konten UUID,
	genre VARCHAR(50),
	PRIMARY KEY (id_konten, genre),
	FOREIGN KEY (id_konten) REFERENCES KONTEN (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Podcaster
CREATE TABLE PODCASTER(
	email VARCHAR(50) PK,
	FOREIGN KEY (email) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Podcast
CREATE TABLE PODCAST(
	id_konten UUID PK,
	email_podcaster VARCHAR(50) NOT NULL,
	FOREIGN KEY (id_konten) REFERENCES KONTEN (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (email_podcaster) REFERENCES PODCASTER (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Episode
CREATE TABLE EPISODE(
	id_episode UUID PK,
	id_konten_podcast UUID NOT NULL,
	judul VARCHAR(100) NOT NULL,
	deskripsi VARCHAR(500) NOT NULL,
	durasi INTEGER NOT NULL,
	tanggal_rilis DATE NOT NULL,
	FOREIGN KEY (id_konten_podcast) REFERENCES PODCAST (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Artist
CREATE TABLE ARTIST(
	id UUID PK,
	email_akun VARCHAR(50) NOT NULL,
	id_pemilik_hak_cipta UUID NOT NULL,
	FOREIGN KEY (email_akun) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_pemilik_hak_cipta) REFERENCES PEMILIK_HAK_CIPTA (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Songwriter
CREATE TABLE SONGWRITER(
	id UUID PK,
	email_akun VARCHAR(50) NOT NULL,
	id_pemilik_hak_cipta UUID NOT NULL,
	FOREIGN KEY (email_akun) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_pemilik_hak_cipta) REFERENCES PEMILIK_HAK_CIPTA (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Song
CREATE TABLE SONG(
	id_konten UUID PK,
	id_artist UUID NOT NULL,
	id_album UUID NOT NULL,
	total_play INTEGER DEFAULT 0 NOT NULL,
	total_download INTEGER DEFAULT 0 NOT NULL,
	FOREIGN KEY (id_konten) REFERENCES KONTEN (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_artist) REFERENCES ARTIST (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_album) REFERENCES ALBUM (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Songwriter Write Song
CREATE TABLE SONGWRITER_WRITE_SONG(
	id_songwriter UUID,
	id_song UUID,
	PRIMARY KEY (id_songwriter, id_song),
	FOREIGN KEY (id_songwriter) REFERENCES SONGWRITER (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_song) REFERENCES SONG (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Downloaded Song
CREATE TABLE DOWNLOADED_SONG(
	id_song UUID,
  email_downloader VARCHAR(50),
	PRIMARY KEY (id_song, email_downloader),
	FOREIGN KEY (id_song) REFERENCES SONG (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (email_downloader) REFERENCES PREMIUM (email) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Album
CREATE TABLE ALBUM(
	id UUID PK,
  judul VARCHAR(100) NOT NULL,
  jumlah_lagu INTEGER DEFAULT 0 NOT NULL,
  id_label UUID NOT NULL,
  total_durasi INTEGER DEFAULT 0 NOT NULL,
	FOREIGN KEY (id_label) REFERENCES LABEL (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Label
CREATE TABLE LABEL(
	id UUID PK,
  nama VARCHAR(100) NOT NULL,
  email VARCHAR(50) NOT NULL,
  password VARCHAR(50) NOT NULL,
  kontak VARCHAR(50) NOT NULL,
  id_pemilik_hak_cipta UUID NOT NULL,
	FOREIGN KEY (id_pemilik_hak_cipta) REFERENCES PEMILIH_HAK_CIPTA (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Playlist
CREATE TABLE PLAYLIST(
	id UUID PK,
);

-- Tabel Chart
CREATE TABLE CHART(
	tipe varchar(50) PK,
	id_playlist UUID NOT NULL,
	FOREIGN KEY (id_playlist) REFERENCES PLAYLIST (id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel User Playlist
CREATE TABLE USER_PLAYLIST(
	email_pembuat VARCHAR(50),
  id_user_playlist UUID,
  judul VARCHAR(100) NOT NULL,
  deskripsi VARCHAR(500) NOT NULL,
  jumlah_lagu INTEGER NOT NULL,
  tanggal_dibuat DATE NOT NULL,
  id_playlist UUID NOT NULL,
  total_durasi INTEGER DEFAULT 0 NOT NULL,
  PRIMARY KEY (email_pembuat, id_user_playlist),
	FOREIGN KEY (email_pembuat) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_playlist) REFERENCES PLAYLIST(id) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Pemilik Hak Cipta
CREATE TABLE PEMILIK_HAK_CIPTA(
	id UUID PK,
	rate_royalti INTEGER NOT NULL
);

-- Tabel Royalti
CREATE TABLE ROYALTI(
	id_pemilik_hak_cipta UUID,
  id_song UUID,
  jumlah INTEGER NOT NULL,
  PRIMARY KEY (id_pemilik_hak_cipta, id_song),
	FOREIGN KEY (id_pemilik_hak_cipta) REFERENCES PEMILIK_HAK_CIPTA (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_song) REFERENCES SONG (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Tabel Akun Play User Playlist
CREATE TABLE AKUN_PLAY_USER_PLAYLIST(
	email_pemain VARCHAR(50),
  id_user_playlist UUID,
  email_pembuat VARCHAR(50),
  waktu timestamp,
  PRIMARY KEY (email_pemain, id_user_playlist, email_pembuat, waktu),
	FOREIGN KEY (email_pemain) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_user_playlist, email_pembuat) REFERENCES USER_PLAYLIST(id_user_playlist, email_pembuat) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Akun Play Song
CREATE TABLE AKUN_PLAY_SONG(
	email_pemain VARCHAR(50),
  id_song UUID,
  waktu timestamp,
  PRIMARY KEY (email_pemain, id_song, waktu),
	FOREIGN KEY (email_pemain) REFERENCES AKUN (email) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_song) REFERENCES SONG (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Playlist Song
CREATE TABLE PLAYLIST_SONG(
	id_playlist UUID,
	id_song UUID,
	PRIMARY KEY (id_playlist, id_song),
	FOREIGN KEY (id_playlist) REFERENCES PLAYLIST (id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (id_song) REFERENCES SONG (id_konten) ON UPDATE CASCADE ON DELETE CASCADE,
);

-- Data dummy 

-- Data Akun
INSERT INTO Akun (email, password, nama, gender, tempat_lahir, tanggal_lahir, is_verified, kota_asal)
VALUES
('a@gmail.com', 'pass123', 'User1', 0, 'Jakarta', '1990-01-01', true, 'Jakarta'),
('b@gmail.com', 'pass123', 'User2', 1, 'Bandung', '1995-05-15', true, 'Bandung'),
('c@example.com', 'pass123', 'User3', 0, 'Surabaya', '1987-09-20', true, 'Surabaya'),
('d@example.com', 'pass123', 'User4', 1, 'Medan', '1983-03-10', true, 'Medan'),
('e@gmail.com', 'pass123', 'User5', 0, 'Jakarta', '1990-04-01', false, 'Jakarta'),
('f@gmail.com', 'pass123', 'User6', 0, 'Semarang', '1990-09-21', true, 'Semarang'),
('g@gmail.com', 'pass123', 'User7', 0, 'Jakarta', '1990-07-11', true, 'Jakarta'),
('h@gmail.com', 'pass123', 'User8', 0, 'Kalimantan', '1993-01-04', false, 'Kalimantan'),
('i@gmail.com', 'pass123', 'User9', 1, 'Jakarta', '1994-03-01', true, 'Jakarta'),
('j@gmail.com', 'pass123', 'User10', 0, 'Jakarta', '1992-05-06', true, 'Jakarta'),
('k@gmail.com', 'pass123', 'User11', 0, 'Kalimantan', '1996-04-02', true, 'Kalimantan'),
('l@gmail.com', 'pass123', 'User12', 1, 'Jakarta', '1995-07-21', false, 'Jakarta'),
('m@gmail.com', 'pass123', 'User13', 0, 'Jakarta', '1993-10-30', true, 'Jakarta'),
('n@gmail.com', 'pass123', 'User14', 1, 'Medan', '1990-02-27', true, 'Medan'),
('o@gmail.com', 'pass123', 'User15', 0, 'Palembang', '1998-12-26', true, 'Palembang'),
('p@gmail.com', 'pass123', 'User16', 1, 'Bali', '1991-05-09', true, 'Bali'),
('q@gmail.com', 'pass123', 'User17', 0, 'Garut', '1992-10-01', true, 'Garut'),
('r@gmail.com', 'pass123', 'User18', 0, 'Bogor', '1996-04-23', false, 'Bogor'),
('s@gmail.com', 'pass123', 'User19', 1, 'Depok', '1994-09-14', true, 'Depok'),
('t@gmail.com', 'pass123', 'User20', 0, 'Makassar', '1992-10-24', true, 'Makassar'),
('u@gmail.com', 'pass123', 'User1', 0, 'Banyuwangi', '1995-06-24', true, 'Banyuwangi'),
('v@gmail.com', 'pass123', 'User22', 1, 'NTT', '1992-11-01', true, 'NTT'),
('w@gmail.com', 'pass123', 'User23', 0, 'Duri', '1998-05-03', false, 'Duri'),
('x@gmail.com', 'pass123', 'User24', 1, 'Semarang', '1993-02-23', true, 'Semarang'),
('y@gmail.com', 'pass123', 'User25', 0, 'Bali', '1993-09-12', true, 'Bali'),
('z@gmail.com', 'pass123', 'User26', 0, 'Kalimantan', '1990-09-15', true, 'Kalimantan'),
('aa@gmail.com', 'pass123', 'User27', 0, 'Duri', '1994-07-12', true, 'Duri'),
('bb@gmail.com', 'pass123', 'User28', 1, 'Bandung', '1995-05-15', true, 'Bandung'),
('cc@example.com', 'pass123', 'User29', 0, 'Surabaya', '1987-09-20', true, 'Surabaya'),
('dd@example.com', 'pass123', 'User30', 1, 'Medan', '1983-03-10', true, 'Medan'),
('ee@gmail.com', 'pass123', 'User31', 0, 'Jakarta', '2000-02-01', true, 'Jakarta'),
('ff@gmail.com', 'pass123', 'User32', 0, 'Bandung', '1997-02-18', true, 'Bandung'),
('gg@gmail.com', 'pass123', 'User33', 0, 'Bogor', '1989-04-01', true, 'Bogor'),
('hh@gmail.com', 'pass123', 'User34', 1, 'Karawang', '1986-01-01', true, 'Karawang'),
('ii@gmail.com', 'pass123', 'User35', 0, 'Bekasi', '1988-04-13', true, 'Bekasi'),
('jj@gmail.com', 'pass123', 'User36', 0, 'Palembang', '1999-04-18', false, 'Palembang'),
('kk@gmail.com', 'pass123', 'User37', 1, 'Pekalongan', '1997-12-01', true, 'Pekalongan'),
('ll@gmail.com', 'pass123', 'User38', 0, 'Surabaya', '2001-07-11', true, 'Surabaya'),
('mm@gmail.com', 'pass123', 'User39', 0, 'Garut', '1993-12-12', false, 'Garut'),
('nn@gmail.com', 'pass123', 'User40', 0, 'Bali', '1984-12-12', true, 'Bali'),
('oo@gmail.com', 'pass123', 'User41', 0, 'NTT', '1995-12-23', true, 'NTT'),
('pp@gmail.com', 'pass123', 'User42', 1, 'Jakarta', '1993-05-11', true, 'Jakarta'),
('qq@gmail.com', 'pass123', 'User43', 0, 'Medan', '2000-12-14', true, 'Medan'),
('rr@gmail.com', 'pass123', 'User44', 0, 'Bekasi', '1999-12-15', true, 'Bekasi'),
('ss@gmail.com', 'pass123', 'User45', 1, 'Yogyakarta', '1994-12-17', false, 'Yogyakarta'),
('tt@gmail.com', 'pass123', 'User46', 0, 'Bali', '1992-06-03', true, 'Bali'),
('uu@gmail.com', 'pass123', 'User47', 1, 'Jakarta', '1999-10-04', true, 'Jakarta'),
('vv@gmail.com', 'pass123', 'User48', 0, 'Yogyakarta', '2000-05-18', false, 'Yogyakarta'),
('ww@gmail.com', 'pass123', 'User49', 1, 'Bandung', '1988-04-12', true, 'Bandung'),
('xx@gmail.com', 'pass123', 'User50', 0, 'Jakarta', '1989-04-18', false, 'Jakarta'),
('yy@gmail.com', 'pass123', 'User51', 0, 'Bogor', '1993-12-09', true, 'Bogor'),
('zz@example.com', 'pass123', 'User52', 1, 'Yogyakarta', '1998-11-28', true, 'Yogyakarta');

-- Data Paket
INSERT INTO Paket (jenis, harga)
VALUES
('1 Bulan', 55000),
('3 Bulan', 120000),
('6 Bulan', 230000),
('1 Tahun', 400000);

-- Data Transaction
INSERT INTO Transaction (id, jenis_paket, email, timestamp_dimulai, timestamp_berakhir, metode_bayar, nominal)
VALUES
('b5d39133-c9d0-40bc-a010-040f352a0975', '1 Bulan', 'a@gmail.com', '2024-04-01 08:00:00', '2024-05-01 08:00:00', 'Credit Card', 50000),
('d957180b-0990-4c3d-9087-fb909e807977', '3 Bulan', 'f@gmail.com', '2024-02-01 10:00:00', '2024-07-01 10:00:00', 'Bank Transfer', 120000),
('7cf2b618-b4e3-408f-8578-fae50a394f46', '3 Bulan', 'aa@gmail.comm', '2024-01-01 10:00:00', '2024-07-01 10:00:00', 'Bank Transfer', 120000),
('e6148b24-0949-4698-8778-12c7277b449e', '6 Bulan', 'i@gmail.com', '2024-03-01 10:00:00', '2024-07-01 10:00:00', 'Bank Transfer', 120000),
('1128e7f6-fb2c-4c4f-8306-eea13d1e44a7', '1 Tahun', 'z@gmail.com', '2024-04-01 12:00:00', '2025-04-01 12:00:00', 'Credit Card', 400000);

-- Data Premium
INSERT INTO Premium (email)
VALUES
('f@gmail.com'),
('aa@gmail.com'),
('a@gmail.com'),
('i@gmail.com'),
('z@gmail.com');

-- Data Non Premium
INSERT INTO Non_Premium (email)
VALUES
('g@gmail.com'),
('h@gmail.com'),
('m@gmail.com'),
('n@gmail.com'),
('c@gmail.com'),
('bb@gmail.com'),
('hh@gmail.com'),
('oo@gmail.com'),
('pp@gmail.com'),
('z@gmail.com'),
('y@gmail.com'),
('ww@gmail.com'),
('s@gmail.com'),
('u@gmail.com'),
('t@gmail.com'),
('d@gmail.com'),
('dd@gmail.com'),
('ff@gmail.com'),
('zz@gmail.com'),
('ii@gmail.com'),
('cc@gmail.com'),
('gg@gmail.com'),
('ee@gmail.com'),
('h@gmail.com'),
('kk@example.com');

-- Data Konten
INSERT INTO Konten (id, judul, tanggal_rilis, tahun, durasi)
VALUES
('4feed5f5-2b01-4405-921b-ad8478af14a8', 'Konten 1', '2024-01-01', 2024, 120),
('dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'Konten 2', '2024-02-01', 2024, 90),
('50e507d7-7e0c-4bf4-934e-a77678cc021e', 'Konten 3', '2020-02-01', 2020, 70),
('6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', 'Konten 4', '2022-09-04', 2022, 50),
('d67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', 'Konten 5', '2021-11-09', 2021, 60),
('b16ec9ba-91fb-42a6-986d-40b29a075f0a', 'Konten 6', '2020-12-21', 2020, 55),
('ba2f920a-8dfe-4a0e-855f-6ab01f19284a', 'Konten 7', '2023-06-06', 2023, 40),
('f5192c7f-0c71-4c35-b718-4655fc30cb20', 'Konten 8', '2022-10-07', 2022, 90),
('71851177-0a9f-4ff9-b38e-ca2f4645d843', 'Konten 9', '2020-05-12', 2020, 80),
('f2d71d50-de74-4220-97d4-ae0edcf772f8', 'Konten 10', '2022-12-10', 2022, 50),
('01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 'Konten 11', '2023-09-09', 2023, 120),
('2ccdad85-97e6-4bc7-ad8c-397730fefa81', 'Konten 12', '2022-02-14', 2022, 90),
('f8b2b39b-0591-44b5-95fc-9bd28a79c801', 'Konten 13', '2022-10-19', 2022, 50),
('f9c9f179-a2a5-4717-8c8c-c30a91b2c295', 'Konten 14', '2020-10-04', 2020, 70),
('6a677056-ed08-4e4d-a2d8-9007bbd764c7', 'Konten 15', '2021-09-11', 2021, 50),
('84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f', 'Konten 16', '2022-05-09', 2021, 60),
('fb598125-1ad2-47ed-9944-744ce13fdd2b', 'Konten 17', '2021-10-21', 2021, 58),
('ec5c1cdf-5459-4a0c-9a78-af1af94feb77', 'Konten 18', '2021-09-06', 2021, 40),
('cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4', 'Konten 19', '2024-02-09', 2024, 90),
('629eb624-c643-48f9-a134-d85ec7417a9d', 'Konten 20', '2023-06-11', 2023, 80),
('7c4f6689-7841-4c71-9174-b33b2f1d51b8', 'Konten 21', '2022-04-14', 2022, 60),
('2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef', 'Konten 22', '2022-05-09', 2022, 120),
('5aa86533-e644-40bc-9fd3-87d94bc9f121', 'Konten 23', '2023-01-10', 2023, 40),
('118db2b2-2572-4516-a8b7-6f20063b3902', 'Konten 24', '2023-05-20', 2023, 90),
('070efc40-1315-4d38-a699-a76c6338164f', 'Konten 25', '2022-09-23', 2022, 70),
('c23b2947-d314-4ca9-9585-9039f56563e3', 'Konten 26', '2022-10-10', 2022, 50),
('9964a419-9834-4f25-b205-82a9407c53c1', 'Konten 27', '2023-05-05', 2023, 60),
('febd27d3-5e70-4cad-ae78-476ef92a0e36', 'Konten 28', '2021-10-21', 2021, 55),
('9569949d-13d4-43cc-83fe-c78626523211', 'Konten 29', '2020-07-09', 2020, 40),
('57b7161c-b3a3-4cc8-9989-58bde273fbcc', 'Konten 30', '2020-09-15', 2020, 90),
('3c2f041d-0a45-4c77-a15d-dc460473d6be', 'Konten 31', '2022-07-13', 2022, 80),
('ba36d60d-aeb5-4151-9817-35dc06191a12', 'Konten 32', '2024-01-11', 2024, 50),
('df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5', 'Konten 33', '2023-05-29', 2023, 120),
('6e05346d-dbd4-46d1-a041-7d1a5911dc3b', 'Konten 34', '2022-12-14', 2022, 90),
('221fbe05-434d-4f03-b57c-68011d183705', 'Konten 35', '2021-10-20', 2021, 50),
('686eec1c-42a0-4b65-986f-02cac58d6dc4', 'Konten 36', '2023-05-30', 2023, 70),
('79faef91-6658-4cbd-a19e-8432327061fd', 'Konten 37', '2022-03-11', 2022, 50),
('14d3475f-e863-4056-81e3-c74ea539ab64', 'Konten 38', '2023-06-10', 2023, 60),
('810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad', 'Konten 39', '2024-01-21', 2024, 58),
('eb6f4097-0653-42b8-8fba-196d132c5758', 'Konten 40', '2023-04-21', 2023, 40),
('7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4', 'Konten 41', '2022-04-30', 2022, 90),
('222cb372-5e73-4720-9383-70d5d4edb773', 'Konten 42', '2022-02-28', 2022, 80),
('117c0fda-4559-4296-8354-175f12d96d1c', 'Konten 43', '2022-02-28', 2022, 80),
('0708ddf9-015a-45e0-997c-78febfcb418a', 'Konten 44', '2022-02-28', 2022, 80),
('b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5', 'Konten 45', '2023-10-24', 2023, 60),
('86639ab6-8e03-4f8e-8b7f-72e028c169c2', 'Konten 46', '2021-08-14', 2021, 120),
('38537266-4e6c-4821-a3d5-2358e08db81b', 'Konten 47', '2024-03-21', 2024, 40),
('1ea5590b-710d-4d7b-aaee-2781790e6335', 'Konten 48', '2022-08-30', 2022, 90),
('c5b798e7-fbe6-48ae-8732-f281d1de2573', 'Konten 49', '2023-12-18', 2023, 80),
('be5339e7-1415-4177-abb3-440d0f894418', 'Konten 50', '2022-11-24', 2022, 60),
('71a4d0a6-2cf4-44ac-a15d-63d63f36b667', 'Konten 51', '2024-01-23', 2024, 120),
('259648d8-9e65-4143-b0b0-29e8e7c4a971', 'Konten 52', '2021-09-30', 2021, 90),
('78e75546-4e0f-4ec6-b813-1eefe326b9d7', 'Konten 53', '2021-11-21', 2021, 80),
('abd6d893-3c70-4fcb-84a1-e5c64a95d4ee', 'Konten 54', '2022-08-29', 2022, 60),
('92b56316-ee42-42f4-ae73-8b248343d949', 'Konten 55', '2023-10-26', 2023, 60),
('c3037434-2f87-4adf-945a-edc616274262', 'Konten 56', '2022-06-06', 2022, 120),
('921e47e9-75f7-44e9-b58c-d88099c0fb57', 'Konten 57', '2021-04-20', 2021, 90),
('40990098-2af7-4978-9f00-88471e49249b', 'Konten 53', '2021-07-07', 2021, 80),
('f8b81e8c-8ef5-48f5-b090-fae792715b40', 'Konten 59', '2022-04-29', 2022, 60),
('6d2c9470-6a85-416a-b808-03e3dbcd9487', 'Konten 60', '2024-03-27', 2024, 150);

-- Data Genre
INSERT INTO Genre (id_konten, genre)
VALUES
('4feed5f5-2b01-4405-921b-ad8478af14a8', 'Pop'),
('dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'Rock'),
('50e507d7-7e0c-4bf4-934e-a77678cc021e', 'Hip Hop'),
('6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', 'R&B'),
('d67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', 'Electronic'),
('b16ec9ba-91fb-42a6-986d-40b29a075f0a', 'House'),
('ba2f920a-8dfe-4a0e-855f-6ab01f19284a', 'Indie'),
('f5192c7f-0c71-4c35-b718-4655fc30cb20', 'Alternative'),
('71851177-0a9f-4ff9-b38e-ca2f4645d843', 'Jazz'),
('f2d71d50-de74-4220-97d4-ae0edcf772f8', 'Blues'),
('01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 'Classical'),
('2ccdad85-97e6-4bc7-ad8c-397730fefa81', 'Orchestral'),
('f8b2b39b-0591-44b5-95fc-9bd28a79c801', 'Folk'),
('f9c9f179-a2a5-4717-8c8c-c30a91b2c295', 'Country'),
('6a677056-ed08-4e4d-a2d8-9007bbd764c7', 'Reggae'),
('84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f', 'Ska'),
('fb598125-1ad2-47ed-9944-744ce13fdd2b', 'Metal'),
('ec5c1cdf-5459-4a0c-9a78-af1af94feb77', 'Heavy Metal'),
('cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4', 'Punk'),
('629eb624-c643-48f9-a134-d85ec7417a9d', 'Grunge'),
('7c4f6689-7841-4c71-9174-b33b2f1d51b8', 'Funk'),
('2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef', 'Soul'),
('5aa86533-e644-40bc-9fd3-87d94bc9f121', 'Disco'),
('118db2b2-2572-4516-a8b7-6f20063b3902', 'Dance'),
('070efc40-1315-4d38-a699-a76c6338164f', 'Techno'),
('c23b2947-d314-4ca9-9585-9039f56563e3', 'Trance'),
('9964a419-9834-4f25-b205-82a9407c53c1', 'Ambient'),
('febd27d3-5e70-4cad-ae78-476ef92a0e36', 'Chill'),
('9569949d-13d4-43cc-83fe-c78626523211', 'Pop Rock'),
('57b7161c-b3a3-4cc8-9989-58bde273fbcc', 'Soft Rock'),
('3c2f041d-0a45-4c77-a15d-dc460473d6be', 'Rap'),
('ba36d60d-aeb5-4151-9817-35dc06191a12', 'Trap'),
('df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5', 'Dubstep'),
('6e05346d-dbd4-46d1-a041-7d1a5911dc3b', 'Future Bass'),
('221fbe05-434d-4f03-b57c-68011d183705', 'Fusion'),
('686eec1c-42a0-4b65-986f-02cac58d6dc4', 'World'),
('79faef91-6658-4cbd-a19e-8432327061fd', 'Experimental'),
('14d3475f-e863-4056-81e3-c74ea539ab64', 'Avant-garde'),
('810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad', 'Singer-Songwriter'),
('eb6f4097-0653-42b8-8fba-196d132c5758', 'Acoustic'),
('7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4', 'Electropop'),
('222cb372-5e73-4720-9383-70d5d4edb773', 'Synthpop'),
('117c0fda-4559-4296-8354-175f12d96d1c', 'Psychedelic'),
('0708ddf9-015a-45e0-997c-78febfcb418a', 'Progressive'),
('b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5', 'Latin'),
('86639ab6-8e03-4f8e-8b7f-72e028c169c2', 'Tropical'),
('38537266-4e6c-4821-a3d5-2358e08db81b', 'K-pop'),
('1ea5590b-710d-4d7b-aaee-2781790e6335', 'J-pop'),
('c5b798e7-fbe6-48ae-8732-f281d1de2573', 'Reggaeton'),
('be5339e7-1415-4177-abb3-440d0f894418', 'Dembow'),
('71a4d0a6-2cf4-44ac-a15d-63d63f36b667', 'Rockabilly'),
('259648d8-9e65-4143-b0b0-29e8e7c4a971', 'Psychobilly'),
('78e75546-4e0f-4ec6-b813-1eefe326b9d7', 'Opera'),
('abd6d893-3c70-4fcb-84a1-e5c64a95d4ee', 'Operetta'),
('92b56316-ee42-42f4-ae73-8b248343d949', 'Gospel'),
('c3037434-2f87-4adf-945a-edc616274262', 'Christian'),
('921e47e9-75f7-44e9-b58c-d88099c0fb57', 'Funk Rock'),
('40990098-2af7-4978-9f00-88471e49249b', 'Hard Rock'),
('f8b81e8c-8ef5-48f5-b090-fae792715b40', 'Pop Punk'),
('6d2c9470-6a85-416a-b808-03e3dbcd9487', 'Emo');

-- Data Podcaster
INSERT INTO Podcaster (email)
VALUES
('g@gmail.com'),
('u@gmail.com'),
('p@gmail.com'),
('x@gmail.com'),
('z@gmail.com'),
('cc@gmail.com'),
('dd@gmail.com'),
('zz@gmail.com'),
('kk@gmail.com'),
('ll@gmail.com');

-- Data Podcast
INSERT INTO Podcast (id_konten, email_podcaster)
VALUES
('57b7161c-b3a3-4cc8-9989-58bde273fbcc', 'g@gmail.com'),
('dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'cc@gmail.com'),
('2ccdad85-97e6-4bc7-ad8c-397730fefa81', 'z@gmail.com'),
('6e05346d-dbd4-46d1-a041-7d1a5911dc3b', 'p@gmail.com'),
('629eb624-c643-48f9-a134-d85ec7417a9d', 'dd@gmail.com'),
('b16ec9ba-91fb-42a6-986d-40b29a075f0a', 'kk@gmail.com'),
('01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 'x@gmail.com');

-- Data Episode
INSERT INTO Episode (id_episode, id_konten_podcast, judul, deskripsi, durasi, tanggal_rilis)
VALUES
('952ec3d5-5faa-47fb-b387-42d16ce350b5', '57b7161c-b3a3-4cc8-9989-58bde273fbcc', 'Episode 2 k30', 'Deskripsi ep2', 60, '2020-10-15'),
('e58caf46-8804-4896-9ae4-f08e9bd25a0d', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'Episode 2 k2', 'Deskripsi ep2', 45, '2024-01-07'),
('213e8ebc-2af9-449c-b788-682e91997333', '57b7161c-b3a3-4cc8-9989-58bde273fbcc', 'Episode 3 k30', 'Deskripsi ep3', 60, '2020-10-20'),
('0f3bf986-1b3e-4c47-bebe-d2c474705302', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'Episode 3 k2', 'Deskripsi ep3', 30, '2024-01-15'),
('99aed185-70ad-4283-893f-cd9b5f05baae', '2ccdad85-97e6-4bc7-ad8c-397730fefa81', 'Episode 2', 'Deskripsi ep2', 30, '2022-02-30'),
('16942232-ac12-4e9a-93c3-abda6e455028', '6e05346d-dbd4-46d1-a041-7d1a5911dc3b', 'Episode 2 k34', 'Deskripsi ep2', 50, '2022-12-25'),
('0bac4312-3c09-4309-847c-aac7aa0201f7', '629eb624-c643-48f9-a134-d85ec7417a9d', 'Episode 2 k20', 'Deskripsi ep2', 30, '2023-06-18'),
('48a29a4e-8a50-4b08-aa7a-9e0e491968d5', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', 'Episode 2 k6', 'Deskripsi ep2', 40, '2020-12-28'),
('01ec873f-2995-4f23-b05c-5c8809e0eb7a', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 'Episode 2 k11', 'Deskripsi ep2', 30, '2023-09-18'),
('4b541243-8bb0-4ea1-a946-e667a1843624', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 'Episode 3 k11', 'Deskripsi ep2', 40, '2023-10-01');

-- Data Artist
INSERT INTO Artist (id, email_akun, id_pemilik_hak_cipta)
VALUES
('87596c2b-f07a-4ea8-aeca-7a8f94db3971', 't@gmail.com', 'a5182836-c9bf-465b-b5db-aab5e52cc44a'),
('afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'a@gmail.com', '045c2278-cb30-4969-ab2d-66d2367a1983'),
('228d0abc-49b0-464f-ac10-4f11c8260aec', 'g@gmail.com', 'a725cbaf-2859-4210-8759-a16fb4f751a2'),
('5d5bfe04-4525-4c4f-a8a8-100b345f3cec', 'u@gmail.com', 'a6a1a2a7-980f-4659-bf89-4165d5b1f0f0'),
('2ca29024-56e6-4c44-922d-dd8cb03c3151', 'k@gmail.com', '3cd78687-183f-4a01-b1fe-837ccdfa1127'),
('1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', 'm@gmail.com', '4f28689b-a88e-46f5-ac59-a5c68b79f1e1'),
('9758426f-b59b-4649-8934-f5f44d248a3f', 'x@gmail.com', '551d8620-1f5a-49b4-8cfd-2e2869ac5b17'),
('f6d33873-c313-4160-b7d3-c92fccfda245', 'o@gmail.com', '7de94104-654e-4b1a-8519-438ee7d62956'),
('45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', 'aa@gmail.com', '2f050efc-dd83-4e92-b7ed-24d6570c08c0'),
('5e485718-77c9-47b5-b72f-7c645fec7941', 'nn@gmail.com', '7b743c2a-5181-40c6-b4d9-7a582a74aad3');

-- Data Songwriter
INSERT INTO SONGWRITER (id, email_akun, id_pemilik_hak_cipta)
VALUES
('1d11b55e-be54-44ae-b140-e61be23eab83', 't@gmail.com', 'a5182836-c9bf-465b-b5db-aab5e52cc44a'),
('ad69372c-6916-45f3-8395-069de8ca11be', 'nn@gmail.com', '045c2278-cb30-4969-ab2d-66d2367a1983'),
('16e872fa-0309-4fd6-beb7-626c436d52af', 'gg@gmail.com', 'a725cbaf-2859-4210-8759-a16fb4f751a2'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', 'm@gmail.com', 'a6a1a2a7-980f-4659-bf89-4165d5b1f0f0'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', 'h@gmail.com', '3cd78687-183f-4a01-b1fe-837ccdfa1127'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', 's@gmail.com', '4f28689b-a88e-46f5-ac59-a5c68b79f1e1'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', 'w@gmail.com', '551d8620-1f5a-49b4-8cfd-2e2869ac5b17'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', 'qq@gmail.com', '7de94104-654e-4b1a-8519-438ee7d62956'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', 'ww@gmail.com', '2f050efc-dd83-4e92-b7ed-24d6570c08c0'),
('20692012-2ada-466e-b805-dca7c75ea810', 'rr@gmail.com', '7b743c2a-5181-40c6-b4d9-7a582a74aad3');

-- Data Song
INSERT INTO SONG (id_konten, id_artist, id_album, total_play, total_download)
VALUES
('4feed5f5-2b01-4405-921b-ad8478af14a8', '87596c2b-f07a-4ea8-aeca-7a8f94db3971', '9824b435-46bd-4a71-be03-d03a5035dda0', 1000, 500),
('dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'bb3b6289-a922-4ee0-a1e8-073a45b67455', 2000, 1000),
('50e507d7-7e0c-4bf4-934e-a77678cc021e', '228d0abc-49b0-464f-ac10-4f11c8260aec', '8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 1500, 800),
('6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', '5d5bfe04-4525-4c4f-a8a8-100b345f3cec', '0b01765e-7c60-466f-971a-397dcb2d0980', 1200, 700),
('d67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2ca29024-56e6-4c44-922d-dd8cb03c3151', '51535557-4833-416e-b459-05c530f6eee8', 1800, 900),
('b16ec9ba-91fb-42a6-986d-40b29a075f0a', '1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', '0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 2200, 1100),
('ba2f920a-8dfe-4a0e-855f-6ab01f19284a', '9758426f-b59b-4649-8934-f5f44d248a3f', 'feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 1300, 600),
('f5192c7f-0c71-4c35-b718-4655fc30cb20', 'f6d33873-c313-4160-b7d3-c92fccfda245', '5609ff0d-8813-4519-9f71-784669cfc733', 1600, 850),
('71851177-0a9f-4ff9-b38e-ca2f4645d843', '45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', '8cd79624-5f27-4781-99b1-b22c888cae66', 1400, 750),
('f2d71d50-de74-4220-97d4-ae0edcf772f8', '5e485718-77c9-47b5-b72f-7c645fec7941', '63fd60e6-b572-4de0-94f8-da372c7d5d04', 2500, 1200),
('01ffbd48-ac6f-4f64-8e2b-173df275b3f1', '87596c2b-f07a-4ea8-aeca-7a8f94db3971', '9824b435-46bd-4a71-be03-d03a5035dda0', 3000, 1500),
('2ccdad85-97e6-4bc7-ad8c-397730fefa81', 'afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'bb3b6289-a922-4ee0-a1e8-073a45b67455', 2700, 1300),
('f8b2b39b-0591-44b5-95fc-9bd28a79c801', '228d0abc-49b0-464f-ac10-4f11c8260aec', '8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 1900, 1000),
('f9c9f179-a2a5-4717-8c8c-c30a91b2c295', '5d5bfe04-4525-4c4f-a8a8-100b345f3cec', '0b01765e-7c60-466f-971a-397dcb2d0980', 2800, 1400),
('6a677056-ed08-4e4d-a2d8-9007bbd764c7', '2ca29024-56e6-4c44-922d-dd8cb03c3151', '51535557-4833-416e-b459-05c530f6eee8', 2100, 1100),
('84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f', '1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', '0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 3200, 1600),
('fb598125-1ad2-47ed-9944-744ce13fdd2b', '9758426f-b59b-4649-8934-f5f44d248a3f', 'feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 2300, 1200),
('ec5c1cdf-5459-4a0c-9a78-af1af94feb77', 'f6d33873-c313-4160-b7d3-c92fccfda245', '5609ff0d-8813-4519-9f71-784669cfc733', 1700, 900),
('cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4', '45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', '8cd79624-5f27-4781-99b1-b22c888cae66', 2900, 1450),
('629eb624-c643-48f9-a134-d85ec7417a9d', '5e485718-77c9-47b5-b72f-7c645fec7941', '63fd60e6-b572-4de0-94f8-da372c7d5d04', 2600, 1250),
('7c4f6689-7841-4c71-9174-b33b2f1d51b8', '87596c2b-f07a-4ea8-aeca-7a8f94db3971', '9824b435-46bd-4a71-be03-d03a5035dda0', 3500, 1750),
('2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef', 'afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'bb3b6289-a922-4ee0-a1e8-073a45b67455', 2400, 1250),
('5aa86533-e644-40bc-9fd3-87d94bc9f121', '228d0abc-49b0-464f-ac10-4f11c8260aec', '8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 3300, 1650),
('118db2b2-2572-4516-a8b7-6f20063b3902', '5d5bfe04-4525-4c4f-a8a8-100b345f3cec', '0b01765e-7c60-466f-971a-397dcb2d0980', 4000, 2000),
('070efc40-1315-4d38-a699-a76c6338164f', '2ca29024-56e6-4c44-922d-dd8cb03c3151', '51535557-4833-416e-b459-05c530f6eee8', 3100, 1550),
('c23b2947-d314-4ca9-9585-9039f56563e3', '1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', '0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 3600, 1800),
('9964a419-9834-4f25-b205-82a9407c53c1', '9758426f-b59b-4649-8934-f5f44d248a3f', 'feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 2700, 1350),
('febd27d3-5e70-4cad-ae78-476ef92a0e36', 'f6d33873-c313-4160-b7d3-c92fccfda245', '5609ff0d-8813-4519-9f71-784669cfc733', 3700, 1850),
('9569949d-13d4-43cc-83fe-c78626523211', '45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', '8cd79624-5f27-4781-99b1-b22c888cae66', 2800, 1400),
('57b7161c-b3a3-4cc8-9989-58bde273fbcc', '5e485718-77c9-47b5-b72f-7c645fec7941', '63fd60e6-b572-4de0-94f8-da372c7d5d04', 4200, 2100),
('3c2f041d-0a45-4c77-a15d-dc460473d6be', '87596c2b-f07a-4ea8-aeca-7a8f94db3971', '9824b435-46bd-4a71-be03-d03a5035dda0', 3200, 1600),
('ba36d60d-aeb5-4151-9817-35dc06191a12', 'afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'bb3b6289-a922-4ee0-a1e8-073a45b67455', 3800, 1900),
('df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5', '228d0abc-49b0-464f-ac10-4f11c8260aec', '8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 2900, 1450),
('6e05346d-dbd4-46d1-a041-7d1a5911dc3b', '5d5bfe04-4525-4c4f-a8a8-100b345f3cec', '0b01765e-7c60-466f-971a-397dcb2d0980', 4400, 2200),
('221fbe05-434d-4f03-b57c-68011d183705', '2ca29024-56e6-4c44-922d-dd8cb03c3151', '51535557-4833-416e-b459-05c530f6eee8', 3300, 1650),
('686eec1c-42a0-4b65-986f-02cac58d6dc4', '1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', '0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 4900, 2450),
('79faef91-6658-4cbd-a19e-8432327061fd', '9758426f-b59b-4649-8934-f5f44d248a3f', 'feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 3500, 1750),
('14d3475f-e863-4056-81e3-c74ea539ab64', 'f6d33873-c313-4160-b7d3-c92fccfda245', '5609ff0d-8813-4519-9f71-784669cfc733', 4600, 2300),
('810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad', '45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', '8cd79624-5f27-4781-99b1-b22c888cae66', 3700, 1850),
('eb6f4097-0653-42b8-8fba-196d132c5758', '5e485718-77c9-47b5-b72f-7c645fec7941', '63fd60e6-b572-4de0-94f8-da372c7d5d04', 5000, 2500),
('7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4', '87596c2b-f07a-4ea8-aeca-7a8f94db3971', '9824b435-46bd-4a71-be03-d03a5035dda0', 3900, 1950),
('222cb372-5e73-4720-9383-70d5d4edb773', 'afe39fcf-e2a0-430b-8f04-912cc9d23e9a', 'bb3b6289-a922-4ee0-a1e8-073a45b67455', 5200, 2600),
('117c0fda-4559-4296-8354-175f12d96d1c', '228d0abc-49b0-464f-ac10-4f11c8260aec', '8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 4100, 2050),
('0708ddf9-015a-45e0-997c-78febfcb418a', '5d5bfe04-4525-4c4f-a8a8-100b345f3cec', '0b01765e-7c60-466f-971a-397dcb2d0980', 5400, 2700),
('b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5', '2ca29024-56e6-4c44-922d-dd8cb03c3151', '51535557-4833-416e-b459-05c530f6eee8', 4200, 2100),
('86639ab6-8e03-4f8e-8b7f-72e028c169c2', '1e9ac7d7-e03d-419f-82b0-ddd37fcef8bc', '0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 5600, 2800),
('38537266-4e6c-4821-a3d5-2358e08db81b', '9758426f-b59b-4649-8934-f5f44d248a3f', 'feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 4300, 2150),
('1ea5590b-710d-4d7b-aaee-2781790e6335', 'f6d33873-c313-4160-b7d3-c92fccfda245', '5609ff0d-8813-4519-9f71-784669cfc733', 5800, 2900),
('c5b798e7-fbe6-48ae-8732-f281d1de2573', '45ac41ac-cfc3-46f5-92b8-9fe60a949cb6', '8cd79624-5f27-4781-99b1-b22c888cae66', 4500, 2250),
('be5339e7-1415-4177-abb3-440d0f894418', '5e485718-77c9-47b5-b72f-7c645fec7941', '63fd60e6-b572-4de0-94f8-da372c7d5d04', 6000, 3000);

-- Data Songwriter Write Song
INSERT INTO SONGWRITER_WRITE_SONG (id_songwriter, id_song)
VALUES
('1d11b55e-be54-44ae-b140-e61be23eab83', '4feed5f5-2b01-4405-921b-ad8478af14a8'),
('ad69372c-6916-45f3-8395-069de8ca11be', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '50e507d7-7e0c-4bf4-934e-a77678cc021e'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', '6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', 'ba2f920a-8dfe-4a0e-855f-6ab01f19284a'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', 'f5192c7f-0c71-4c35-b718-4655fc30cb20'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', '71851177-0a9f-4ff9-b38e-ca2f4645d843'),
('20692012-2ada-466e-b805-dca7c75ea810', 'f2d71d50-de74-4220-97d4-ae0edcf772f8'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1'),
('ad69372c-6916-45f3-8395-069de8ca11be', '2ccdad85-97e6-4bc7-ad8c-397730fefa81'),
('16e872fa-0309-4fd6-beb7-626c436d52af', 'f8b2b39b-0591-44b5-95fc-9bd28a79c801'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', 'f9c9f179-a2a5-4717-8c8c-c30a91b2c295'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '6a677056-ed08-4e4d-a2d8-9007bbd764c7'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', '84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', 'fb598125-1ad2-47ed-9944-744ce13fdd2b'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', 'ec5c1cdf-5459-4a0c-9a78-af1af94feb77'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', 'cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4'),
('20692012-2ada-466e-b805-dca7c75ea810', '629eb624-c643-48f9-a134-d85ec7417a9d'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '7c4f6689-7841-4c71-9174-b33b2f1d51b8'),
('ad69372c-6916-45f3-8395-069de8ca11be', '2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '5aa86533-e644-40bc-9fd3-87d94bc9f121'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', '118db2b2-2572-4516-a8b7-6f20063b3902'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '070efc40-1315-4d38-a699-a76c6338164f'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', 'c23b2947-d314-4ca9-9585-9039f56563e3'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', '9964a419-9834-4f25-b205-82a9407c53c1'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', 'febd27d3-5e70-4cad-ae78-476ef92a0e36'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', '9569949d-13d4-43cc-83fe-c78626523211'),
('20692012-2ada-466e-b805-dca7c75ea810', '57b7161c-b3a3-4cc8-9989-58bde273fbcc'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '3c2f041d-0a45-4c77-a15d-dc460473d6be'),
('1d11b55e-be54-44ae-b140-e61be23eab83', 'ba36d60d-aeb5-4151-9817-35dc06191a12'),
('ad69372c-6916-45f3-8395-069de8ca11be', 'df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '6e05346d-dbd4-46d1-a041-7d1a5911dc3b'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '221fbe05-434d-4f03-b57c-68011d183705'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '686eec1c-42a0-4b65-986f-02cac58d6dc4'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '79faef91-6658-4cbd-a19e-8432327061fd'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '14d3475f-e863-4056-81e3-c74ea539ab64'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad'),
('20692012-2ada-466e-b805-dca7c75ea810', 'eb6f4097-0653-42b8-8fba-196d132c5758'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4'),
('ad69372c-6916-45f3-8395-069de8ca11be', '222cb372-5e73-4720-9383-70d5d4edb773'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '117c0fda-4559-4296-8354-175f12d96d1c'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', '0708ddf9-015a-45e0-997c-78febfcb418a'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', 'b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', '86639ab6-8e03-4f8e-8b7f-72e028c169c2'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', '38537266-4e6c-4821-a3d5-2358e08db81b'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', '1ea5590b-710d-4d7b-aaee-2781790e6335'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', 'c5b798e7-fbe6-48ae-8732-f281d1de2573'),
('20692012-2ada-466e-b805-dca7c75ea810', 'be5339e7-1415-4177-abb3-440d0f894418'),
('1d11b55e-be54-44ae-b140-e61be23eab83', '71a4d0a6-2cf4-44ac-a15d-63d63f36b667'),
('ad69372c-6916-45f3-8395-069de8ca11be', '259648d8-9e65-4143-b0b0-29e8e7c4a971'),
('16e872fa-0309-4fd6-beb7-626c436d52af', '78e75546-4e0f-4ec6-b813-1eefe326b9d7'),
('3bdaf777-4cae-4b29-bbaa-2fd9257967f8', 'abd6d893-3c70-4fcb-84a1-e5c64a95d4ee'),
('e5269a5b-05b2-4d65-82d2-00c4317317a2', '92b56316-ee42-42f4-ae73-8b248343d949'),
('8bee396b-5605-43c9-bf9c-d0d255c58dd2', 'c3037434-2f87-4adf-945a-edc616274262'),
('ad0272b3-0066-4bae-adc1-1ef3290fa965', '921e47e9-75f7-44e9-b58c-d88099c0fb57'),
('f6a54163-6625-4ea6-8d86-1f5936c7c3a6', '40990098-2af7-4978-9f00-88471e49249b'),
('c46b71c0-fd92-42dc-b722-34c8ff548c2c', 'f8b81e8c-8ef5-48f5-b090-fae792715b40'),
('20692012-2ada-466e-b805-dca7c75ea810', '6d2c9470-6a85-416a-b808-03e3dbcd9487');

-- Data Album
INSERT INTO ALBUM (id, judul, jumlah_lagu, id_label, total_durasi)
VALUES
('9824b435-46bd-4a71-be03-d03a5035dda0', 'Album 1', 8, '176cedc5-5089-42b4-a965-f5a0204c6e49', 2700),
('bb3b6289-a922-4ee0-a1e8-073a45b67455', 'Album 2', 10, '55c3b4c5-ca38-4de0-84ae-0ff411eb622f', 3200),
('8bfa33e2-a9a4-491e-8949-3da7d3eb4310', 'Album 3', 12, '176cedc5-5089-42b4-a965-f5a0204c6e49', 3800),
('0b01765e-7c60-466f-971a-397dcb2d0980', 'Album 4', 9, '077b6617-1916-49cf-ba61-940f760bb369', 2900),
('51535557-4833-416e-b459-05c530f6eee8', 'Album 5', 11, 'd7a7c7b0-92cb-40dd-bd34-e2a2537c15ee', 3400),
('0313a4ba-eff2-4101-9dc6-ecaecc084fcd', 'Album 6', 7, '55c3b4c5-ca38-4de0-84ae-0ff411eb622f', 2500),
('feb9bdaa-76e9-4ebf-b4ae-f0b5a7a12f13', 'Album 7', 9, '2193fd0e-64be-4edb-8a76-56bb06307b71', 3000),
('5609ff0d-8813-4519-9f71-784669cfc733', 'Album 8', 13, 'd7a7c7b0-92cb-40dd-bd34-e2a2537c15ee', 4200),
('8cd79624-5f27-4781-99b1-b22c888cae66', 'Album 9', 10, '077b6617-1916-49cf-ba61-940f760bb369', 3200),
('63fd60e6-b572-4de0-94f8-da372c7d5d04', 'Album 10', 15, '2193fd0e-64be-4edb-8a76-56bb06307b71', 4700);

-- Data Label
INSERT INTO LABEL (id, nama, email, password, kontak, id_pemilik_hak_cipta)
VALUES
('d7a7c7b0-92cb-40dd-bd34-e2a2537c15ee', 'Label 1', 'label1@gmail.com', 'password1', '+123456789', 'a5182836-c9bf-465b-b5db-aab5e52cc44a'),
('2193fd0e-64be-4edb-8a76-56bb06307b71', 'Label 2', 'label2@gmail.com', 'password2', '+987654321', '045c2278-cb30-4969-ab2d-66d2367a1983'),
('176cedc5-5089-42b4-a965-f5a0204c6e49', 'Label 3', 'label3@gmail.com', 'password3', '+111222333', 'a725cbaf-2859-4210-8759-a16fb4f751a2'),
('55c3b4c5-ca38-4de0-84ae-0ff411eb622f', 'Label 4', 'label4@gmail.com', 'password4', '+444555666', 'a6a1a2a7-980f-4659-bf89-4165d5b1f0f0'),
('077b6617-1916-49cf-ba61-940f760bb369', 'Label 5', 'label5@gmail.com', 'password5', '+777888999', '3cd78687-183f-4a01-b1fe-837ccdfa1127');

-- Data Downloaded Song
INSERT INTO Downloaded_Song (id_song, email_downloader)
VALUES
('4feed5f5-2b01-4405-921b-ad8478af14a8', 'f@gmail.com'),
('dd61bc11-92fa-472e-9b97-9fe1debad6c9', 'aa@gmail.comm'),
('50e507d7-7e0c-4bf4-934e-a77678cc021e', 'a@gmail.com'),
('6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', 'i@gmail.com'),
('d67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', 'z@gmail.com'),
('b16ec9ba-91fb-42a6-986d-40b29a075f0a', 'f@gmail.com'),
('ba2f920a-8dfe-4a0e-855f-6ab01f19284a', 'aa@gmail.com'),
('f5192c7f-0c71-4c35-b718-4655fc30cb20', 'a@gmail.com'),
('71851177-0a9f-4ff9-b38e-ca2f4645d843', 'i@gmail.com'),
('f2d71d50-de74-4220-97d4-ae0edcf772f8', 'z@gmail.com');

-- Data Playlist
INSERT INTO Playlist (id)
VALUES
('95f7a150-d70e-4d8c-b980-e9b8692dbe38'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab'),
('a546996c-d440-4353-977c-777967d28dab'),
('8308a884-1077-4dfc-9906-5099b87fe9bd'),
('b9e78971-7641-4bad-988c-64b93f2762c8'),
('9f380b58-59f1-48a7-9039-138c717bb7e5'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608');

-- Data Chart
INSERT INTO Chart (tipe, id_playlist)
VALUES
('Daily Top 20', '95f7a150-d70e-4d8c-b980-e9b8692dbe38'),
('Weekly Top 20', '8308a884-1077-4dfc-9906-5099b87fe9bd'),
('Monthly Top 20', 'b9e78971-7641-4bad-988c-64b93f2762c8'),
('Yearly Top 20', '4b4f75f9-4bb9-46d1-a3f5-61da2e38b785');

-- Data User Playlist
INSERT INTO User_Playlist (email_pembuat, id_user_playlist, judul, deskripsi, jumlah_lagu, tanggal_dibuat, id_playlist, total_durasi)
VALUES
('b@gmail.com', '56cfe622-7622-4368-b15c-928a928f8123', 'My Favorites', 'A collection of my favorite songs', 15, '2024-04-01', 'e906f0ca-888b-4520-a4c1-4b39d0bb3bab', 4200),
('c@gmail.com', 'c6a98196-2d88-44c5-bd49-32949c15e72b', 'Workout Mix', 'Playlist for gym sessions', 10, '2024-03-05', 'a546996c-d440-4353-977c-777967d28dab', 3000),
('n@gmail.com', 'cce6e761-2039-4bf7-8b08-ac8e7c5f6288', 'Chill Vibes', 'Relaxing tunes for a chill evening', 12, '2024-02-10', '95f7a150-d70e-4d8c-b980-e9b8692dbe38', 3600),
('t@gmail.com', 'e345e477-f48a-4444-88dd-c25070773022', 'Road Trip Playlist', 'Songs for long drives', 20, '2024-04-15', '88c5cd93-d016-4d47-bd5e-f13dfabf4601', 5400),
('tt@gmail.com', 'ddbd3b09-4b4b-495d-b6cd-9979a7d2f1ee', 'Study Focus', 'Instrumental music for studying', 18, '2024-04-20', 'abf4f862-f34e-4736-ad73-1f06cc0a8608', 4800);

-- Data User Pemilik Hak Cipta
INSERT INTO Pemilik_Hak_Cipta (id, rate_royalti)
VALUES
('a5182836-c9bf-465b-b5db-aab5e52cc44a', 10),
('045c2278-cb30-4969-ab2d-66d2367a1983', 15),
('a725cbaf-2859-4210-8759-a16fb4f751a2', 20),
('a6a1a2a7-980f-4659-bf89-4165d5b1f0f0', 12),
('3cd78687-183f-4a01-b1fe-837ccdfa1127', 18),
('4f28689b-a88e-46f5-ac59-a5c68b79f1e1', 25),
('551d8620-1f5a-49b4-8cfd-2e2869ac5b17', 14),
('7de94104-654e-4b1a-8519-438ee7d62956', 17),
('2f050efc-dd83-4e92-b7ed-24d6570c08c0', 22),
('7b743c2a-5181-40c6-b4d9-7a582a74aad3', 16),
('bff2610c-94e6-4888-9d1b-ae00fa86da5e', 19),
('83f5c527-4ee0-474e-9930-99f1ffa68361', 23),
('dd66ccb0-2b79-4393-999a-59c154970b26', 13),
('3594339e-bacb-481b-94b7-b412d05d7435', 21),
('d380f516-871f-420b-8341-972edca8afe8', 24),
('b7078ad3-c128-4201-ad6d-0b5ac63837bc', 11),
('87375edb-c69f-45c7-a6f4-8aae8cc5954a', 26),
('f1605707-cbb0-4c0d-b72c-226427a4106a', 27),
('7753bf4d-4dc3-49ef-a36e-dc294c895a3b', 28),
('300db712-e835-4e65-a369-d533493d1f2b', 29),
('909741e6-d272-4951-b29d-48a4314154ae', 30),
('d7b1fe05-f2ee-490d-b69b-f062553d0dd2', 31),
('2b6a6a39-1adf-4b10-afba-e35ceeab574e', 32),
('26e72a9c-362e-49f8-907a-4a2add9037a3', 33),
('d27a7959-0dc0-4521-991e-419ddc664ec9', 34);

-- Data Royalti
INSERT INTO Royalti (id_pemilik_hak_cipta, id_song, jumlah)
VALUES
('a5182836-c9bf-465b-b5db-aab5e52cc44a', '4feed5f5-2b01-4405-921b-ad8478af14a8', 100),
('045c2278-cb30-4969-ab2d-66d2367a1983', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', 150),
('a725cbaf-2859-4210-8759-a16fb4f751a2', '50e507d7-7e0c-4bf4-934e-a77678cc021e', 200),
('a6a1a2a7-980f-4659-bf89-4165d5b1f0f0', '6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', 120),
('3cd78687-183f-4a01-b1fe-837ccdfa1127', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', 180),
('4f28689b-a88e-46f5-ac59-a5c68b79f1e1', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', 250),
('551d8620-1f5a-49b4-8cfd-2e2869ac5b17', 'ba2f920a-8dfe-4a0e-855f-6ab01f19284a', 140),
('7de94104-654e-4b1a-8519-438ee7d62956', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', 170),
('2f050efc-dd83-4e92-b7ed-24d6570c08c0', '71851177-0a9f-4ff9-b38e-ca2f4645d843', 220),
('7b743c2a-5181-40c6-b4d9-7a582a74aad3', 'f2d71d50-de74-4220-97d4-ae0edcf772f8', 160),
('bff2610c-94e6-4888-9d1b-ae00fa86da5e', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1', 190),
('83f5c527-4ee0-474e-9930-99f1ffa68361', '2ccdad85-97e6-4bc7-ad8c-397730fefa81', 230),
('dd66ccb0-2b79-4393-999a-59c154970b26', 'f8b2b39b-0591-44b5-95fc-9bd28a79c801', 130),
('3594339e-bacb-481b-94b7-b412d05d7435', 'f9c9f179-a2a5-4717-8c8c-c30a91b2c295', 210),
('d380f516-871f-420b-8341-972edca8afe8', '6a677056-ed08-4e4d-a2d8-9007bbd764c7', 240),
('b7078ad3-c128-4201-ad6d-0b5ac63837bc', '84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f', 110),
('87375edb-c69f-45c7-a6f4-8aae8cc5954a', 'fb598125-1ad2-47ed-9944-744ce13fdd2b', 260),
('f1605707-cbb0-4c0d-b72c-226427a4106a', 'ec5c1cdf-5459-4a0c-9a78-af1af94feb77', 270),
('7753bf4d-4dc3-49ef-a36e-dc294c895a3b', 'cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4', 280),
('300db712-e835-4e65-a369-d533493d1f2b', '629eb624-c643-48f9-a134-d85ec7417a9d', 290),
('909741e6-d272-4951-b29d-48a4314154ae', '7c4f6689-7841-4c71-9174-b33b2f1d51b8', 300),
('d7b1fe05-f2ee-490d-b69b-f062553d0dd2', '2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef', 310),
('2b6a6a39-1adf-4b10-afba-e35ceeab574e', '5aa86533-e644-40bc-9fd3-87d94bc9f121', 320),
('26e72a9c-362e-49f8-907a-4a2add9037a3', '118db2b2-2572-4516-a8b7-6f20063b3902', 330),
('d27a7959-0dc0-4521-991e-419ddc664ec9', '070efc40-1315-4d38-a699-a76c6338164f', 340);

-- Data Akun Play User Playlist
INSERT INTO Akun_Play_User_Playlist (email_pemain, id_user_playlist, waktu)
VALUES
('v@gmail.com', '56cfe622-7622-4368-b15c-928a928f8123', '2024-04-01 08:00:00'),
('y@gmail.com', 'c6a98196-2d88-44c5-bd49-32949c15e72b', '2024-04-02 10:15:00'),
('f@gmail.com', 'cce6e761-2039-4bf7-8b08-ac8e7c5f6288', '2024-04-03 12:30:00'),
('r@gmail.com', 'e345e477-f48a-4444-88dd-c25070773022', '2024-04-04 14:45:00'),
('o@gmail.com', 'ddbd3b09-4b4b-495d-b6cd-9979a7d2f1ee', '2024-04-05 17:00:00'),
('jj@gmail.com', '56cfe622-7622-4368-b15c-928a928f8123', '2024-04-06 19:15:00'),
('zz@gmail.com', 'c6a98196-2d88-44c5-bd49-32949c15e72b', '2024-04-07 21:30:00'),
('rr@gmail.com', 'cce6e761-2039-4bf7-8b08-ac8e7c5f6288', '2024-04-08 23:45:00'),
('u@gmail.com', 'e345e477-f48a-4444-88dd-c25070773022', '2024-04-09 08:30:00'),
('i@gmail.com', 'ddbd3b09-4b4b-495d-b6cd-9979a7d2f1ee', '2024-04-10 10:45:00'),
('dd@gmail.com', '56cfe622-7622-4368-b15c-928a928f8123', '2024-04-11 13:00:00'),
('ee@gmail.com', 'c6a98196-2d88-44c5-bd49-32949c15e72b', '2024-04-12 15:15:00'),
('gg@gmail.com', 'cce6e761-2039-4bf7-8b08-ac8e7c5f6288', '2024-04-13 17:30:00'),
('ss@gmail.com', 'e345e477-f48a-4444-88dd-c25070773022', '2024-04-14 19:45:00'),
('cc@gmail.com', 'ddbd3b09-4b4b-495d-b6cd-9979a7d2f1ee', '2024-04-15 22:00:00');

-- Data Akun Play Song
INSERT INTO Akun_Play_Song (email_pemain, id_song, waktu)
VALUES
('a@gmail.com', '4feed5f5-2b01-4405-921b-ad8478af14a8', '2023-10-01 08:00:00'),
('b@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2023-10-02 10:15:00'),
('c@gmail.com', '50e507d7-7e0c-4bf4-934e-a77678cc021e', '2023-10-03 12:30:00'),
('d@gmail.com', '6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', '2023-10-04 14:45:00'),
('e@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2023-10-05 17:00:00'),
('f@gmail.com', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', '2023-10-06 19:15:00'),
('g@gmail.com', 'ba2f920a-8dfe-4a0e-855f-6ab01f19284a', '2023-10-07 21:30:00'),
('h@gmail.com', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', '2023-10-08 23:45:00'),
('i@gmail.com', '71851177-0a9f-4ff9-b38e-ca2f4645d843', '2023-10-09 08:30:00'),
('j@gmail.com', 'f2d71d50-de74-4220-97d4-ae0edcf772f8', '2023-10-10 10:45:00'),
('k@gmail.com', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1', '2023-10-11 13:00:00'),
('l@gmail.com', '2ccdad85-97e6-4bc7-ad8c-397730fefa81', '2023-10-12 15:15:00'),
('m@gmail.com', 'f8b2b39b-0591-44b5-95fc-9bd28a79c801', '2023-10-13 17:30:00'),
('n@gmail.com', 'f9c9f179-a2a5-4717-8c8c-c30a91b2c295', '2023-10-14 19:45:00'),
('o@gmail.com', '6a677056-ed08-4e4d-a2d8-9007bbd764c7', '2023-10-15 22:00:00'),
('p@gmail.com', '84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f', '2023-10-16 08:00:00'),
('q@gmail.com', 'fb598125-1ad2-47ed-9944-744ce13fdd2b', '2023-10-17 10:15:00'),
('r@gmail.com', 'ec5c1cdf-5459-4a0c-9a78-af1af94feb77', '2023-10-18 12:30:00'),
('s@gmail.com', 'cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4', '2023-10-19 14:45:00'),
('t@gmail.com', '629eb624-c643-48f9-a134-d85ec7417a9d', '2023-10-20 17:00:00'),
('u@gmail.com', '7c4f6689-7841-4c71-9174-b33b2f1d51b8', '2023-10-21 19:15:00'),
('v@gmail.com', '2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef', '2023-10-22 21:30:00'),
('w@gmail.com', '5aa86533-e644-40bc-9fd3-87d94bc9f121', '2023-10-23 23:45:00'),
('x@gmail.com', '118db2b2-2572-4516-a8b7-6f20063b3902', '2023-10-24 08:30:00'),
('y@gmail.com', '070efc40-1315-4d38-a699-a76c6338164f', '2023-10-25 10:45:00'),
('z@gmail.com', 'c23b2947-d314-4ca9-9585-9039f56563e3', '2023-10-26 13:00:00'),
('aa@gmail.com', '9964a419-9834-4f25-b205-82a9407c53c1', '2023-10-27 15:15:00'),
('bb@gmail.com', 'febd27d3-5e70-4cad-ae78-476ef92a0e36', '2023-10-28 17:30:00'),
('cc@gmail.com', '9569949d-13d4-43cc-83fe-c78626523211', '2023-10-29 19:45:00'),
('dd@gmail.com', '57b7161c-b3a3-4cc8-9989-58bde273fbcc', '2023-10-30 22:00:00'),
('ee@gmail.com', '3c2f041d-0a45-4c77-a15d-dc460473d6be', '2023-10-31 08:00:00'),
('ff@gmail.com', 'ba36d60d-aeb5-4151-9817-35dc06191a12', '2023-11-01 10:15:00'),
('gg@gmail.com', 'df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5', '2023-11-02 12:30:00'),
('hh@gmail.com', '6e05346d-dbd4-46d1-a041-7d1a5911dc3b', '2023-11-03 14:45:00'),
('ii@gmail.com', '221fbe05-434d-4f03-b57c-68011d183705', '2023-11-04 17:00:00'),
('jj@gmail.com', '686eec1c-42a0-4b65-986f-02cac58d6dc4', '2023-11-05 19:15:00'),
('kk@gmail.com', '79faef91-6658-4cbd-a19e-8432327061fd', '2023-11-06 21:30:00'),
('ll@gmail.com', '14d3475f-e863-4056-81e3-c74ea539ab64', '2023-11-07 23:45:00'),
('mm@gmail.com', '810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad', '2023-11-08 08:30:00'),
('nn@gmail.com', 'eb6f4097-0653-42b8-8fba-196d132c5758', '2023-11-09 10:45:00'),
('oo@gmail.com', '7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4', '2023-11-10 13:00:00'),
('pp@gmail.com', '222cb372-5e73-4720-9383-70d5d4edb773', '2023-11-11 15:15:00'),
('qq@gmail.com', '117c0fda-4559-4296-8354-175f12d96d1c', '2023-11-12 17:30:00'),
('rr@gmail.com', '0708ddf9-015a-45e0-997c-78febfcb418a', '2023-11-13 19:45:00'),
('ss@gmail.com', 'b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5', '2023-11-14 22:00:00'),
('tt@gmail.com', '86639ab6-8e03-4f8e-8b7f-72e028c169c2', '2023-11-15 08:00:00'),
('uu@gmail.com', '38537266-4e6c-4821-a3d5-2358e08db81b', '2023-11-16 10:15:00'),
('vv@gmail.com', '1ea5590b-710d-4d7b-aaee-2781790e6335', '2023-11-17 12:30:00'),
('ww@gmail.com', 'c5b798e7-fbe6-48ae-8732-f281d1de2573', '2023-11-18 14:45:00'),
('xx@gmail.com', 'be5339e7-1415-4177-abb3-440d0f894418', '2023-11-19 17:00:00'),
('yy@gmail.com', '71a4d0a6-2cf4-44ac-a15d-63d63f36b667', '2023-11-20 19:15:00'),
('zz@gmail.com', '259648d8-9e65-4143-b0b0-29e8e7c4a971', '2023-11-21 21:30:00'),
('a@gmail.com', '78e75546-4e0f-4ec6-b813-1eefe326b9d7', '2023-11-22 23:45:00'),
('b@gmail.com', 'abd6d893-3c70-4fcb-84a1-e5c64a95d4ee', '2023-11-23 08:30:00'),
('c@gmail.com', '92b56316-ee42-42f4-ae73-8b248343d949', '2023-11-24 10:45:00'),
('d@gmail.com', 'c3037434-2f87-4adf-945a-edc616274262', '2023-11-25 13:00:00'),
('e@gmail.com', '921e47e9-75f7-44e9-b58c-d88099c0fb57', '2023-11-26 15:15:00'),
('f@gmail.com', '40990098-2af7-4978-9f00-88471e49249b', '2023-11-27 17:30:00'),
('g@gmail.com', 'f8b81e8c-8ef5-48f5-b090-fae792715b40', '2023-11-28 19:45:00'),
('h@gmail.com', '6d2c9470-6a85-416a-b808-03e3dbcd9487', '2023-11-29 22:00:00'),
('i@gmail.com', '4feed5f5-2b01-4405-921b-ad8478af14a8', '2023-11-30 08:00:00'),
('j@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2023-12-01 10:15:00'),
('k@gmail.com', '50e507d7-7e0c-4bf4-934e-a77678cc021e', '2023-12-02 12:30:00'),
('l@gmail.com', '6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9', '2023-12-03 14:45:00'),
('m@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2023-12-04 17:00:00'),
('n@gmail.com', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', '2023-12-05 19:15:00'),
('o@gmail.com', '4feed5f5-2b01-4405-921b-ad8478af14a8', '2023-12-06 21:30:00'),
('p@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2023-12-07 23:45:00'),
('q@gmail.com', '50e507d7-7e0c-4bf4-934e-a77678cc021e', '2023-12-08 08:30:00'),
('r@gmail.com', '40990098-2af7-4978-9f00-88471e49249b', '2023-12-09 10:45:00'),
('s@gmail.com', '6d2c9470-6a85-416a-b808-03e3dbcd9487', '2023-12-10 13:00:00'),
('t@gmail.com', 'c3037434-2f87-4adf-945a-edc616274262', '2023-12-11 15:15:00'),
('u@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2023-12-12 17:30:00'),
('v@gmail.com', 'c23b2947-d314-4ca9-9585-9039f56563e3', '2023-12-13 19:45:00'),
('w@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2023-12-14 22:00:00'),
('x@gmail.com', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', '2023-12-15 08:00:00'),
('y@gmail.com', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', '2023-12-16 10:15:00'),
('z@gmail.com', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a', '2023-12-17 12:30:00'),
('aa@gmail.com', '4feed5f5-2b01-4405-921b-ad8478af14a8', '2023-12-18 14:45:00'),
('bb@gmail.com', 'c3037434-2f87-4adf-945a-edc616274262', '2023-12-19 17:00:00'),
('cc@gmail.com', 'c23b2947-d314-4ca9-9585-9039f56563e3', '2023-12-20 19:15:00'),
('dd@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2023-12-21 21:30:00'),
('ee@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2023-12-22 23:45:00'),
('ff@gmail.com', 'f2d71d50-de74-4220-97d4-ae0edcf772f8', '2023-12-23 08:30:00'),
('gg@gmail.com', '4feed5f5-2b01-4405-921b-ad8478af14a8', '2023-12-24 10:45:00'),
('hh@gmail.com', 'f2d71d50-de74-4220-97d4-ae0edcf772f8', '2023-12-25 13:00:00'),
('ii@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2023-12-26 15:15:00'),
('jj@gmail.com', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', '2023-12-27 17:30:00'),
('kk@gmail.com', 'c23b2947-d314-4ca9-9585-9039f56563e3', '2023-12-28 19:45:00'),
('ll@gmail.com', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', '2023-12-29 22:00:00'),
('mm@gmail.com', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', '2023-12-30 08:00:00'),
('nn@gmail.com', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9', '2024-01-01 10:15:00'),
('oo@gmail.com', 'abd6d893-3c70-4fcb-84a1-e5c64a95d4ee', '2024-01-02 12:30:00'),
('pp@gmail.com', 'f5192c7f-0c71-4c35-b718-4655fc30cb20', '2024-01-03 14:45:00'),
('qq@gmail.com', 'c3037434-2f87-4adf-945a-edc616274262', '2024-01-04 17:00:00'),
('rr@gmail.com', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf', '2024-01-05 19:15:00'),
('ss@gmail.com', 'c23b2947-d314-4ca9-9585-9039f56563e3', '2024-01-06 21:30:00'),
('tt@gmail.com', 'f2d71d50-de74-4220-97d4-ae0edcf772f8', '2024-01-07 23:45:00'),
('uu@gmail.com', 'abd6d893-3c70-4fcb-84a1-e5c64a95d4ee', '2024-01-08 08:30:00'),
('vv@gmail.com', 'c3037434-2f87-4adf-945a-edc616274262', '2024-01-09 10:45:00');

-- Data Playlist_Song
INSERT INTO Playlist_Song (id_playlist, id_song)
VALUES
('95f7a150-d70e-4d8c-b980-e9b8692dbe38', '4feed5f5-2b01-4405-921b-ad8478af14a8'),
('95f7a150-d70e-4d8c-b980-e9b8692dbe38', 'dd61bc11-92fa-472e-9b97-9fe1debad6c9'),
('95f7a150-d70e-4d8c-b980-e9b8692dbe38', '50e507d7-7e0c-4bf4-934e-a77678cc021e'),
('95f7a150-d70e-4d8c-b980-e9b8692dbe38', '6ab54bc4-94c1-4d27-b72f-9bd88b39a2c9'),
('95f7a150-d70e-4d8c-b980-e9b8692dbe38', 'd67e0b4b-05a5-4b0b-8f9f-16f51af2fbdf'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab', 'b16ec9ba-91fb-42a6-986d-40b29a075f0a'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab', 'ba2f920a-8dfe-4a0e-855f-6ab01f19284a'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab', 'f5192c7f-0c71-4c35-b718-4655fc30cb20'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab', '71851177-0a9f-4ff9-b38e-ca2f4645d843'),
('e906f0ca-888b-4520-a4c1-4b39d0bb3bab', 'f2d71d50-de74-4220-97d4-ae0edcf772f8'),
('a546996c-d440-4353-977c-777967d28dab', '01ffbd48-ac6f-4f64-8e2b-173df275b3f1'),
('a546996c-d440-4353-977c-777967d28dab', '2ccdad85-97e6-4bc7-ad8c-397730fefa81'),
('a546996c-d440-4353-977c-777967d28dab', 'f8b2b39b-0591-44b5-95fc-9bd28a79c801'),
('a546996c-d440-4353-977c-777967d28dab', 'f9c9f179-a2a5-4717-8c8c-c30a91b2c295'),
('a546996c-d440-4353-977c-777967d28dab', '6a677056-ed08-4e4d-a2d8-9007bbd764c7'),
('8308a884-1077-4dfc-9906-5099b87fe9bd', '84d2bd8b-2ef9-4b7a-bb72-c3246fca8a9f'),
('8308a884-1077-4dfc-9906-5099b87fe9bd', 'fb598125-1ad2-47ed-9944-744ce13fdd2b'),
('8308a884-1077-4dfc-9906-5099b87fe9bd', 'ec5c1cdf-5459-4a0c-9a78-af1af94feb77'),
('8308a884-1077-4dfc-9906-5099b87fe9bd', 'cbf5994f-2a3a-4e43-a1d9-3959d6bd86f4'),
('8308a884-1077-4dfc-9906-5099b87fe9bd', '629eb624-c643-48f9-a134-d85ec7417a9d'),
('b9e78971-7641-4bad-988c-64b93f2762c8', '7c4f6689-7841-4c71-9174-b33b2f1d51b8'),
('b9e78971-7641-4bad-988c-64b93f2762c8', '2e7a184a-f3a7-4a3b-a5e9-7cd5a364c4ef'),
('b9e78971-7641-4bad-988c-64b93f2762c8', '5aa86533-e644-40bc-9fd3-87d94bc9f121'),
('b9e78971-7641-4bad-988c-64b93f2762c8', '118db2b2-2572-4516-a8b7-6f20063b3902'),
('b9e78971-7641-4bad-988c-64b93f2762c8', '070efc40-1315-4d38-a699-a76c6338164f'),
('9f380b58-59f1-48a7-9039-138c717bb7e5', 'c23b2947-d314-4ca9-9585-9039f56563e3'),
('9f380b58-59f1-48a7-9039-138c717bb7e5', '9964a419-9834-4f25-b205-82a9407c53c1'),
('9f380b58-59f1-48a7-9039-138c717bb7e5', 'febd27d3-5e70-4cad-ae78-476ef92a0e36'),
('9f380b58-59f1-48a7-9039-138c717bb7e5', '9569949d-13d4-43cc-83fe-c78626523211'),
('9f380b58-59f1-48a7-9039-138c717bb7e5', '57b7161c-b3a3-4cc8-9989-58bde273fbcc'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785', '3c2f041d-0a45-4c77-a15d-dc460473d6be'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785', 'ba36d60d-aeb5-4151-9817-35dc06191a12'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785', 'df19e8c0-9eb4-48f5-9eb8-ba93f7c641c5'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785', '6e05346d-dbd4-46d1-a041-7d1a5911dc3b'),
('4b4f75f9-4bb9-46d1-a3f5-61da2e38b785', '221fbe05-434d-4f03-b57c-68011d183705'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a', '686eec1c-42a0-4b65-986f-02cac58d6dc4'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a', '79faef91-6658-4cbd-a19e-8432327061fd'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a', '14d3475f-e863-4056-81e3-c74ea539ab64'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a', '810f5fe0-712e-4a30-a4cc-6ab9b0ed0aad'),
('4bd6a33f-42d0-41bf-af95-56fffb0c6b3a', 'eb6f4097-0653-42b8-8fba-196d132c5758'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601', '7a368cc3-fa7c-4e90-bf81-a19d7f4bb2d4'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601', '222cb372-5e73-4720-9383-70d5d4edb773'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601', '117c0fda-4559-4296-8354-175f12d96d1c'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601', '0708ddf9-015a-45e0-997c-78febfcb418a'),
('88c5cd93-d016-4d47-bd5e-f13dfabf4601', 'b24effc8-5a8f-47f6-b8c1-fca5e7bf30b5'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608', '86639ab6-8e03-4f8e-8b7f-72e028c169c2'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608', '38537266-4e6c-4821-a3d5-2358e08db81b'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608', '1ea5590b-710d-4d7b-aaee-2781790e6335'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608', 'c5b798e7-fbe6-48ae-8732-f281d1de2573'),
('abf4f862-f34e-4736-ad73-1f06cc0a8608', 'be5339e7-1415-4177-abb3-440d0f894418');
