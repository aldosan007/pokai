// lib/state/pokemon_list_controller.dart

import 'package:flutter/material.dart';
import 'package:pokai/data/models/pokemon_list_item.dart';
import 'package:pokai/data/repositories/pokemon_repository.dart';

class PokemonListController with ChangeNotifier {
  final PokemonRepository _repository;

  // Constructor: ¡El cerebro necesita al gerente!
  PokemonListController(this._repository);

  // --- Estados de la UI ---
  
  // 1. La lista principal de Pokémon
  List<PokemonListItem> _pokemonList = [];
  List<PokemonListItem> get pokemonList => _pokemonList;

  // 2. El candado para evitar cargas duplicadas
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // 3. Para saber si ya cargamos todo
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // 4. El número de página actual
  int _currentPage = 1;

  // --- (Estados de Búsqueda - Aún no los usamos) ---
  String _query = '';
  String get query => _query;
  // TODO: Añadir lista de búsqueda

  // --- Acciones (Métodos) ---

  // Carga la primera página de Pokémon
  Future<void> loadInitial() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = true;
    // Avisamos a la UI que estamos cargando (para mostrar un spinner inicial)
    notifyListeners(); 

    try {
      final newList = await _repository.getPokemonPage(_currentPage);
      _pokemonList = newList;
      _isLoadingMore = false;
    } catch (e) {
      // Manejo de error simple
      _isLoadingMore = false;
      print('Error en loadInitial: $e');
    }
    
    // Avisamos a la UI que ya terminamos de cargar
    notifyListeners();
  }

  // Carga la siguiente página (para scroll infinito)
  Future<void> loadMore() async {
    // Si ya estamos cargando, O si no hay más por cargar, no hacemos nada.
    if (_isLoadingMore || !_hasMore) return;

    // Ponemos el candado
    _isLoadingMore = true;
    // Avisamos a la UI (para mostrar el spinner al final de la lista)
    notifyListeners(); 

    _currentPage++; // Pasamos a la siguiente página

    try {
      final newList = await _repository.getPokemonPage(_currentPage);
      
      if (newList.isEmpty) {
        // Si la API nos da una lista vacía, significa que no hay más.
        _hasMore = false;
      } else {
        // Añadimos los nuevos Pokémon a la lista existente
        _pokemonList.addAll(newList);
      }
      
      _isLoadingMore = false;
    } catch (e) {
      _isLoadingMore = false;
      print('Error en loadMore: $e');
    }

    // Avisamos a la UI que la lista se actualizó
    notifyListeners();
  }
}