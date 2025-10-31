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

// --- TEMA OSCURO ---
ThemeData buildAppDarkTheme() {
  // Usamos ThemeData.dark() como base
  final baseTheme = ThemeData.dark();

  return baseTheme.copyWith(
    // 1. Paleta de Colores Principal (Ajustada para modo oscuro)
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.red, // Mantenemos rojo base
      accentColor: Colors.redAccent[400],
      brightness: Brightness.dark, // ¡Importante! Indicar que es oscuro
    ).copyWith(
      primary: Colors.red[700], // Un rojo más oscuro como primario
      surface: Colors.grey[850], // Color de fondo de superficies (ej: Cards)
    ),

    // 2. Color de Fondo General
    scaffoldBackgroundColor: Colors.grey[900], // Fondo casi negro

    // 3. Estilo del AppBar (Oscuro)
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900], // AppBar oscuro, casi negro
      foregroundColor: Colors.white, // Texto e íconos blancos
      elevation: 0, // Sin sombra para look plano
      titleTextStyle: GoogleFonts.pressStart2p( // Mantener fuente retro
        color: Colors.white,
        fontSize: 18,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),

    // 4. Estilo de las Tarjetas (Oscuro)
    cardTheme: CardThemeData(
      color: Colors.grey[850], // Color de fondo de tarjeta oscuro
      elevation: 4.0, // Aumentar un poco la sombra para contraste
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    ),

    // 5. Estilo de los TextFields (Oscuro)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800], // Fondo del TextField más oscuro
      hintStyle: TextStyle(color: Colors.grey[500]),
      prefixIconColor: Colors.grey[400],
      suffixIconColor: Colors.grey[400],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    ),

    // 6. Estilo de los Botones (Oscuro) - Mismo estilo puede funcionar
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[700], // Rojo oscuro para botones
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // 7. Estilo de los Chips (Oscuro)
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[700], // Fondo de chip más oscuro
      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Texto blanco
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
    
    // Indicador de progreso con color apropiado
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Colors.redAccent[400]
    ),

    // Asegúrate de que el texto sea legible
    textTheme: baseTheme.textTheme.apply(
      bodyColor: Colors.grey[300], // Color de texto principal
      displayColor: Colors.white, // Color de títulos grandes
    ),
    primaryTextTheme: baseTheme.primaryTextTheme.apply(
       bodyColor: Colors.white,
       displayColor: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.grey[300]), // Color de íconos generales
  );
}