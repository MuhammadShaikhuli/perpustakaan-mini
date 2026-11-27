# Aplikasi Perpustakaan Mini

Aplikasi desktop Perpustakaan Mini menggunakan Java Swing dan PostgreSQL melalui JDBC.

> Status saat ini: baseline/starter project. Modul Model, DAO, Service, dan View masih akan dikembangkan bertahap oleh tim.

## Teknologi

- Java (JDK; versi disepakati dan digunakan konsisten oleh seluruh anggota tim)
- Java Swing
- PostgreSQL (Neon)
- PostgreSQL JDBC Driver 42.7.14
- Visual Studio Code (opsional)

## Struktur project

```text
.
├── .github/
├── .vscode/
├── config/
│   └── db.properties.example
├── database/
│   └── 01_schema.sql
├── lib/
│   └── postgresql-42.7.14.jar
├── screenshots/
└── src/
    ├── main/java/com/perpustakaanmini/
    │   ├── config/
    │   ├── dao/
    │   ├── model/
    │   ├── service/
    │   ├── view/
    │   └── Main.java
    └── test/java/com/perpustakaanmini/
```

## Persiapan

1. Install JDK dan pastikan `java -version` serta `javac -version` berjalan.
2. Clone repository.
3. Salin `config/db.properties.example` menjadi `config/db.properties`.
4. Isi host, port, nama database, username, password, dan SSL mode milik Neon.
5. Jangan pernah commit atau membagikan `config/db.properties`.

Contoh PowerShell:

```powershell
Copy-Item config/db.properties.example config/db.properties
```

Format `config/db.properties`:

```properties
db.host=YOUR_NEON_HOST
db.port=5432
db.name=YOUR_DATABASE_NAME
db.username=YOUR_DATABASE_USERNAME
db.password=YOUR_DATABASE_PASSWORD
db.sslmode=require
```

Jangan menaruh credential asli di README, source code, screenshot, issue, atau chat publik.

## Database

Schema tersedia di `database/01_schema.sql`.

Database Neon tim sudah dibuat dan schema telah dijalankan. Jangan menjalankan ulang atau mengubah schema produksi tanpa koordinasi dengan Project Leader dan penanggung jawab database. Untuk database baru/lokal, jalankan SQL tersebut pada database PostgreSQL yang sesuai.

## Compile dan menjalankan aplikasi (Windows PowerShell)

Jalankan perintah dari root repository.

```powershell
$files = Get-ChildItem -Path src/main/java -Recurse -Filter *.java | ForEach-Object { $_.FullName }
New-Item -ItemType Directory -Force bin | Out-Null
javac -cp "lib/postgresql-42.7.14.jar" -d bin $files
java -cp "bin;lib/postgresql-42.7.14.jar" com.perpustakaanmini.Main
```

## Menguji koneksi database

Pastikan `config/db.properties` sudah dibuat dan diisi dengan credential yang benar.

```powershell
$files = Get-ChildItem -Path src/main/java,src/test/java -Recurse -Filter *.java | ForEach-Object { $_.FullName }
New-Item -ItemType Directory -Force bin | Out-Null
javac -cp "lib/postgresql-42.7.14.jar" -d bin $files
java -cp "bin;lib/postgresql-42.7.14.jar" com.perpustakaanmini.DatabaseConnectionTest
```

## Aturan Git tim

- `main`: baseline stabil/rilis.
- `develop`: integrasi pekerjaan tim.
- `feature/nama-task`: pekerjaan masing-masing anggota.
- Jangan push langsung ke `main` atau `develop`.
- Buat Pull Request ke `develop`, minta review, lalu merge setelah build/test lulus.
- Jangan commit `config/db.properties`, `bin/`, atau file `.class`.
- JDBC JAR di `lib/` sengaja disimpan di repository agar semua anggota memakai driver yang sama.

## Dokumen acuan

Gunakan Project Blueprint dan Panduan Pembagian Tugas & Git sebagai acuan kebutuhan, aturan bisnis, pembagian kepemilikan file, kontrak integrasi, serta acceptance test.

## Status implementasi

Starter saat ini menyediakan entry point Swing, konfigurasi koneksi JDBC, contoh konfigurasi, schema SQL, dan test koneksi. Fitur aplikasi akan diimplementasikan secara bertahap sesuai pembagian tugas tim.
