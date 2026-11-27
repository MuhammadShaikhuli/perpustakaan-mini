package com.perpustakaanmini;

import java.awt.BorderLayout;
import java.awt.Font;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.SwingConstants;
import javax.swing.SwingUtilities;

public class Main {

    public static void main(String[] args) {

        SwingUtilities.invokeLater(() -> {

            JFrame frame = new JFrame(
                "Aplikasi Perpustakaan Mini"
            );

            JLabel label = new JLabel(
                "Starter Project Berhasil Dijalankan!",
                SwingConstants.CENTER
            );

            label.setFont(
                new Font("Arial", Font.BOLD, 20)
            );

            frame.setLayout(new BorderLayout());
            frame.add(label, BorderLayout.CENTER);

            frame.setSize(800, 500);
            frame.setLocationRelativeTo(null);

            frame.setDefaultCloseOperation(
                JFrame.EXIT_ON_CLOSE
            );

            frame.setVisible(true);
        });
    }
}
