-- ============================================================
-- APLIKASI PERPUSTAKAAN MINI
-- Skema awal PostgreSQL - Blueprint v1.0
-- Jalankan pada database yang sudah dibuat, misalnya:
-- CREATE DATABASE perpustakaan_mini;
-- ============================================================

BEGIN;

CREATE TABLE IF NOT EXISTS kategori_buku (
    id_kategori BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(80) NOT NULL UNIQUE,
    deskripsi TEXT,
    aktif BOOLEAN NOT NULL DEFAULT TRUE,
    dibuat_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS anggota (
    no_ktm VARCHAR(30) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    jenis VARCHAR(20) NOT NULL
        CHECK (jenis IN ('Mahasiswa', 'Dosen')),
    status VARCHAR(20) NOT NULL DEFAULT 'AKTIF'
        CHECK (status IN ('AKTIF', 'NONAKTIF')),
    dibuat_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diperbarui_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS buku (
    id_buku BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kode_buku VARCHAR(30) NOT NULL UNIQUE,
    isbn VARCHAR(20) UNIQUE,
    judul VARCHAR(200) NOT NULL,
    penulis VARCHAR(150) NOT NULL,
    penerbit VARCHAR(150),
    tahun_terbit SMALLINT CHECK (tahun_terbit IS NULL OR tahun_terbit BETWEEN 1000 AND 2200),
    id_kategori BIGINT REFERENCES kategori_buku(id_kategori) ON DELETE RESTRICT,
    stok_total INTEGER NOT NULL DEFAULT 0 CHECK (stok_total >= 0),
    stok_tersedia INTEGER NOT NULL DEFAULT 0 CHECK (stok_tersedia >= 0),
    aktif BOOLEAN NOT NULL DEFAULT TRUE,
    dibuat_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    diperbarui_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_buku_stok_tersedia
        CHECK (stok_tersedia <= stok_total)
);

CREATE TABLE IF NOT EXISTS peminjaman (
    id_peminjaman BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    no_ktm VARCHAR(30) NOT NULL
        REFERENCES anggota(no_ktm) ON DELETE RESTRICT,
    tanggal_pinjam DATE NOT NULL,
    batas_kembali DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AKTIF'
        CHECK (status IN ('AKTIF', 'SELESAI')),
    catatan TEXT,
    dibuat_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_tanggal_peminjaman
        CHECK (batas_kembali >= tanggal_pinjam)
);

CREATE TABLE IF NOT EXISTS detail_peminjaman (
    id_detail BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_peminjaman BIGINT NOT NULL
        REFERENCES peminjaman(id_peminjaman) ON DELETE RESTRICT,
    id_buku BIGINT NOT NULL
        REFERENCES buku(id_buku) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'DIPINJAM'
        CHECK (status IN ('DIPINJAM', 'DIKEMBALIKAN')),
    tanggal_kembali DATE,
    hari_terlambat INTEGER NOT NULL DEFAULT 0 CHECK (hari_terlambat >= 0),
    denda NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (denda >= 0),
    dibuat_pada TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_status_pengembalian
        CHECK (
            (status = 'DIPINJAM' AND tanggal_kembali IS NULL)
            OR
            (status = 'DIKEMBALIKAN' AND tanggal_kembali IS NOT NULL)
        )
);

-- Indeks untuk pencarian dan pemuatan tabel riwayat.
CREATE INDEX IF NOT EXISTS idx_anggota_nama
    ON anggota (LOWER(nama));
CREATE INDEX IF NOT EXISTS idx_buku_judul
    ON buku (LOWER(judul));
CREATE INDEX IF NOT EXISTS idx_buku_penulis
    ON buku (LOWER(penulis));
CREATE INDEX IF NOT EXISTS idx_peminjaman_anggota_tanggal
    ON peminjaman (no_ktm, tanggal_pinjam DESC);
CREATE INDEX IF NOT EXISTS idx_peminjaman_status
    ON peminjaman (status);
CREATE INDEX IF NOT EXISTS idx_peminjaman_status_jatuh_tempo
    ON peminjaman (status, batas_kembali);
CREATE INDEX IF NOT EXISTS idx_detail_peminjaman_aktif
    ON detail_peminjaman (id_peminjaman) WHERE status = 'DIPINJAM';
CREATE INDEX IF NOT EXISTS idx_detail_peminjaman_status
    ON detail_peminjaman (status, id_peminjaman);
CREATE INDEX IF NOT EXISTS idx_detail_peminjaman_buku
    ON detail_peminjaman (id_buku);

-- Kategori awal opsional. Hapus/ubah sesuai kebutuhan tim.
INSERT INTO kategori_buku (nama_kategori, deskripsi)
VALUES
    ('Umum', 'Kategori umum'),
    ('Teknologi', 'Komputer, pemrograman, dan teknologi'),
    ('Pendidikan', 'Buku pembelajaran dan referensi akademik'),
    ('Fiksi', 'Novel, cerita, dan karya fiksi'),
    ('Nonfiksi', 'Buku pengetahuan dan nonfiksi')
ON CONFLICT (nama_kategori) DO NOTHING;

COMMIT;

-- CATATAN IMPLEMENTASI:
-- 1. Satu baris detail_peminjaman mewakili satu eksemplar buku.
--    Jika anggota meminjam dua eksemplar judul yang sama, buat dua detail.
-- 2. stok_tersedia harus diperbarui dalam transaksi database yang sama
--    saat peminjaman/pengembalian; jangan mengubahnya langsung dari GUI.
-- 3. Status peminjaman menjadi SELESAI jika seluruh detail sudah DIKEMBALIKAN.
-- 4. Hari terlambat dihitung di Java dari batas_kembali dan tanggal_kembali.
-- 5. Denda dihitung melalui polymorphism pada Anggota, bukan CASE SQL.
