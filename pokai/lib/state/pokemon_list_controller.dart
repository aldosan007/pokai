import 'dart:async'; // Necesario para el Timer del debounce
import 'package:flutter/material.dart';
import 'package:pokai/data/models/pokemon_list_item.dart';
import 'package:pokai/data/repositories/pokemon_repository.dart';

class PokemonListController with ChangeNotifier {
  final PokemonRepository _repository;

  // Constructor: ¡El cerebro necesita al gerente!
  PokemonListController(this._repository);

  // --- Estados de la UI ---

  // Lista principal (o filtrada si hay búsqueda)
  List<PokemonListItem> _pokemonList = [];
  // Copia de la lista original completa para poder filtrar
  List<PokemonListItem> _originalPokemonList = [];
  // Getter que decide qué lista devolver (original o filtrada)
  List<PokemonListItem> get pokemonList {
    return _query.isEmpty ? _pokemonList : _filteredPokemonList;
  }

  // Candado para evitar cargas duplicadas
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  // Para saber si ya cargamos todo
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  // Número de página actual
  int _currentPage = 1;

  // --- Estados de Búsqueda ---
  String _query = '';
  String get query => _query;
  // Lista que contendrá los resultados filtrados
  List<PokemonListItem> _filteredPokemonList = [];
  // Temporizador para el debounce
  Timer? _debounce;
  // Estado para saber si estamos en modo búsqueda
  bool _isSearching = false;
  bool get isSearching => _isSearching;


  // --- Acciones (Métodos) ---

  // Carga la primera página de Pokémon (o resetea)
  Future<void> loadInitial() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = true;
    _isSearching = false; // Desactivar búsqueda al inicio
    _query = '';        // Limpiar texto de búsqueda
    notifyListeners(); // Avisar UI (mostrar spinner inicial)

    try {
      final newList = await _repository.getPokemonPage(_currentPage);
      _pokemonList = newList;
      _originalPokemonList = List.from(newList); // Guardar copia original
      _isLoadingMore = false;
    } catch (e) {
      _isLoadingMore = false;
      print('Error en loadInitial: $e');
      // Podrías añadir un estado de error aquí si quisieras
    }
    notifyListeners(); // Avisar UI (mostrar lista)
  }

  // Carga la siguiente página (para scroll infinito)
  Future<void> loadMore() async {
    // No cargar más si: ya estamos cargando, no hay más, O ESTAMOS BUSCANDO
    if (_isLoadingMore || !_hasMore || _isSearching) return;

    _isLoadingMore = true;
    notifyListeners(); // Avisar UI (mostrar spinner al final)
    _currentPage++;

    try {
      final newList = await _repository.getPokemonPage(_currentPage);
      if (newList.isEmpty) {
        _hasMore = false; // Ya no hay más páginas
      } else {
        _pokemonList.addAll(newList); // Añadir a la lista principal
        _originalPokemonList.addAll(newList); // Añadir también a la copia original
      }
      _isLoadingMore = false;
    } catch (e) {
      _isLoadingMore = false;
      print('Error en loadMore: $e');
      // Podrías intentar recargar o mostrar un error en el footer
    }
    notifyListeners(); // Avisar UI (actualizar lista y footer)
  }

  // --- Función de Búsqueda (con Debounce) ---
  void setQuery(String newQuery) {
    // Cancelar el temporizador anterior si el usuario sigue escribiendo
    _debounce?.cancel();

    _query = newQuery.toLowerCase().trim(); // Guardar query normalizada

    if (_query.isEmpty) {
      // Si la query se borra, desactivar modo búsqueda y mostrar todo
      _isSearching = false;
      _filteredPokemonList = []; // Limpiar resultados filtrados
      _debounce?.cancel(); // Cancelar cualquier timer pendiente
      notifyListeners(); // Mostrar lista original completa
      return;
    }

    // Iniciar un nuevo temporizador (500ms debounce)
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // --- Esto se ejecuta 500ms DESPUÉS de que el usuario dejó de escribir ---
      _isSearching = true; // Activar modo búsqueda

      // Filtrar la lista ORIGINAL completa que hemos ido acumulando
      _filteredPokemonList = _originalPokemonList.where((pokemon) {
        // Comprobar si el nombre del pokémon CONTIENE la query
        return pokemon.name.toLowerCase().contains(_query);
      }).toList();

      // Avisar a la UI que los resultados del filtro están listos
      notifyListeners();
    });
  }

  // Es buena práctica cancelar el timer si el controlador se destruye
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}