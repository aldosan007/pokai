import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController with ChangeNotifier {
  // Clave única para guardar la lista en el teléfono
  static const _favoritesKey = 'favoritePokemonIds';

  List<int> _favoriteIds = []; // Lista privada de IDs favoritos
  late SharedPreferences _prefs; // Variable para el almacenamiento

  // Getter público para que la UI pueda leer la lista
  List<int> get favoriteIds => _favoriteIds;

  // Constructor
  FavoritesController() {
    _loadFavorites(); // Cargar favoritos en cuanto se crea el controlador
  }

  // Carga la lista de IDs desde SharedPreferences
  Future<void> _loadFavorites() async {
    _prefs = await SharedPreferences.getInstance();
    // SharedPreferences guarda List<String>, no List<int>.
    // 1. Obtenemos la lista de Strings guardada (o una lista vacía si no hay nada).
    final List<String> favoriteIdStrings = _prefs.getStringList(_favoritesKey) ?? [];
    // 2. Convertimos esa List<String> de nuevo a List<int>.
    _favoriteIds = favoriteIdStrings.map((id) => int.parse(id)).toList();
    // Notificamos a la UI (por si acaso, aunque al inicio no hay oyentes)
    notifyListeners();
  }

  // Verifica si un Pokémon específico es favorito
  bool isFavorite(int pokemonId) {
    return _favoriteIds.contains(pokemonId);
  }

  // Método principal para añadir o quitar un favorito
  Future<void> toggleFavorite(int pokemonId) async {
    if (isFavorite(pokemonId)) {
      // Si ya es favorito, lo quitamos
      _favoriteIds.remove(pokemonId);
    } else {
      // Si no es favorito, lo añadimos
      _favoriteIds.add(pokemonId);
    }
    // Guardamos la lista actualizada
    await _saveFavorites();
    // Notificamos a la UI que la lista cambió (¡esto es clave!)
    notifyListeners();
  }

  // Función privada para guardar la lista en SharedPreferences
  Future<void> _saveFavorites() async {
    // 1. Convertimos nuestra List<int> a List<String>
    final List<String> favoriteIdStrings = _favoriteIds.map((id) => id.toString()).toList();
    // 2. Guardamos la List<String>
    await _prefs.setStringList(_favoritesKey, favoriteIdStrings);
  }
}