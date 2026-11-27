package com.perpustakaanmini.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final String CONFIG_PATH
            = "config/db.properties";

    private DatabaseConnection() {
        // Mencegah objek kelas ini dibuat.
    }

    public static Connection getConnection()
            throws IOException, SQLException {

        Properties properties = new Properties();

        Path configFile = Path.of(CONFIG_PATH);

        // Membaca konfigurasi database
        try (InputStream input
                = Files.newInputStream(configFile)) {

            properties.load(input);
        }

        // Mengambil konfigurasi
        String host = properties.getProperty("db.host");
        String port = properties.getProperty("db.port");
        String database = properties.getProperty("db.name");

        String username
                = properties.getProperty("db.username");

        String password
                = properties.getProperty("db.password");

        String sslmode
                = properties.getProperty("db.sslmode");

        // Memastikan konfigurasi wajib tersedia
        if (host == null || port == null
                || database == null || username == null
                || password == null || sslmode == null) {

            throw new IllegalStateException(
                    "Konfigurasi database belum lengkap."
            );
        }

        // Membentuk URL JDBC
        String url = "jdbc:postgresql://"
                + host + ":" + port + "/" + database
                + "?sslmode=" + sslmode;

        // Membuka koneksi database
        return DriverManager.getConnection(
                url,
                username,
                password
        );
    }
}
