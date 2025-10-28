// lib/data/repositories/pokemon_repository.dart

import 'package:pokai/data/models/pokemon_detail.dart';
import 'package:pokai/data/models/pokemon_list_item.dart';
import 'package:pokai/data/services/poke_api_service.dart';

class PokemonRepository {
  // 1. Dependencia: El "gerente" necesita un "mensajero"
  final PokeApiService _apiService;

  // 2. Constructor: Recibimos el "mensajero" cuando crean al "gerente"
  PokemonRepository(this._apiService);

  // ---
  // Método 1: Obtener la página de Pokémon (¡devuelve Modelos!)
  // ---
  Future<List<PokemonListItem>> getPokemonPage(int page, {int limit = 30}) async {
    // Calculamos el offset (desplazamiento) basado en la página
    final offset = (page - 1) * limit;

    // 1. Le pedimos la "caja" (JSON) al "mensajero" (Servicio)
    final jsonResponse = await _apiService.fetchPokemonPage(
      limit: limit,
      offset: offset,
    );

    // 2. Abrimos la caja y sacamos la lista de "results"
    // El JSON nos da {'count': 1500, 'next': ..., 'results': [...]}
    final List<dynamic> resultsList = jsonResponse['results'];

    // 3. Usamos los "planos" (.fromApi) para convertir cada item
    final List<PokemonListItem> pokemonList = resultsList.map((itemJson) {
      return PokemonListItem.fromApi(itemJson as Map<String, dynamic>);
    }).toList();

    return pokemonList;
  }

  // ---
  // Método 2: Obtener el detalle (¡devuelve un Modelo!)
  // ---
  Future<PokemonDetail> getPokemonDetail(int id) async {
    // 1. Le pedimos la "caja" (JSON) al "mensajero"
    final jsonResponse = await _apiService.fetchPokemonDetail(id);

    // 2. Usamos el "plano" (.fromApi) para convertir el JSON
    final pokemonDetail = PokemonDetail.fromApi(jsonResponse);

    return pokemonDetail;
  }
}