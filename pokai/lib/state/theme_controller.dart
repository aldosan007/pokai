import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar para guardar

class ThemeController with ChangeNotifier {
  // Clave única para guardar la preferencia en el teléfono
  static const _themePrefKey = 'isDarkModeEnabled';

  bool _isDarkMode = false; // Estado actual del tema (false = claro)
  bool get isDarkMode => _isDarkMode; // Getter público para leer el estado

  late SharedPreferences _prefs; // Variable para interactuar con el almacenamiento

  // Constructor: Se ejecuta al crear el controlador
  ThemeController() {
    _loadPrefs(); // Llama a la función para cargar la preferencia guardada
  }

  // Carga la preferencia guardada (si existe)
  Future<void> _loadPrefs() async {
    // Obtiene la instancia de SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    // Lee el valor guardado; si no existe, usa 'false' (modo claro)
    _isDarkMode = _prefs.getBool(_themePrefKey) ?? false;
    // Notifica a los "oyentes" (la UI) que el estado inicial está listo
    notifyListeners();
  }

  // Cambia entre modo claro y oscuro
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode; // Invierte el valor actual
    // Guarda el nuevo valor en el almacenamiento del teléfono
    await _prefs.setBool(_themePrefKey, _isDarkMode);
    // Notifica a los "oyentes" que el tema ha cambiado
    notifyListeners();
  }
}