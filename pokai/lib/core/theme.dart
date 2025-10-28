// lib/core/theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme() {
  // Usamos ThemeData.light() como base
  final baseTheme = ThemeData.light();

  return baseTheme.copyWith(
    // 1. Paleta de Colores Principal - CORREGIDO
    // Usamos colorScheme generado desde el primarySwatch
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red,
      accentColor: Colors.redAccent[400], // Color de acento
      brightness: Brightness.light,
    ).copyWith(
        // Puedes sobrescribir colores específicos aquí si quieres
        // primary: Colors.red[600], // Color primario principal
        ),

    // 2. Color de Fondo General
    scaffoldBackgroundColor: Colors.grey[100],

    // 3. Estilo del AppBar (Global)
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.red[600],
      foregroundColor: Colors.white,
      elevation: 2.0,
      titleTextStyle: GoogleFonts.pressStart2p(
        color: Colors.white,
        fontSize: 18,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),

    // 4. Estilo de las Tarjetas (Global) - CORREGIDO
    cardTheme: CardThemeData( // <-- Nombre correcto de la clase
      color: Colors.white,
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    ),

    // 5. Estilo de los TextFields (para la búsqueda)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      hintStyle: TextStyle(color: Colors.grey[600]),
      prefixIconColor: Colors.grey[600],
      suffixIconColor: Colors.grey[600],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    ),

    // 6. Estilo de los Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // 7. Estilo de los Chips
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[300],
      labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    
  );
}