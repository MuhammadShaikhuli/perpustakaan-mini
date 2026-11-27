package com.perpustakaanmini;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import com.perpustakaanmini.config.DatabaseConnection;

public class DatabaseConnectionTest {

    public static void main(String[] args) {

        System.out.println(
                "Menguji koneksi PostgreSQL Neon..."
        );

        try (Connection connection
                = DatabaseConnection.getConnection()) {

            if (connection != null
                    && !connection.isClosed()) {

                System.out.println(
                        "KONEKSI DATABASE BERHASIL!"
                );

                System.out.println(
                        "Database: "
                        + connection.getCatalog()
                );

                System.out.println(
                        "Status: "
                        + connection.isValid(5)
                );
            }

        } catch (IOException | SQLException
                | IllegalStateException e) {

            System.out.println(
                    "KONEKSI DATABASE GAGAL!"
            );

            System.out.println(
                    "Penyebab: " + e.getMessage()
            );

            System.err.println(
                    "Detail error: " + e.getMessage()
            );
        }
    }
}
