import 'package:flutter/material.dart';
import 'package:novo_alerta_cidadao/views/home_page.dart';

void main() {
  runApp(const AlertaCidadaoApp());
}

class AlertaCidadaoApp extends StatelessWidget {
  const AlertaCidadaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alerta Cidadão',
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(),
      home: const HomePage(),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        accentColor: Colors.orange,
        backgroundColor: Colors.grey[50],
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 1,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}