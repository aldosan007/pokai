// lib/data/services/poke_api_service.dart

import 'dart:convert'; // Necesario para decodificar el JSON
import 'package:http/http.dart' as http; // Nuestro paquete para peticiones web

class PokeApiService {
  // La URL base (el "dominio") de la PokeAPI
  final String _baseUrl = 'https://pokeapi.co/api/v2';

  // ---
  // Método 1: Traer la lista paginada
  // ---
  Future<Map<String, dynamic>> fetchPokemonPage({
    int limit = 30, // Cuántos traer por página
    int offset = 0, // Desde dónde empezamos a contar
  }) async {
    // Construimos la URL final: ej: .../pokemon?limit=30&offset=0
    final uri = Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Si la API nos responde "OK" (código 200),
        // decodificamos el texto (JSON) a un Mapa de Dart.
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // Si la API nos da un error (ej: 404 No Encontrado)
        throw Exception('Error al cargar la lista de Pokémon');
      }
    } catch (e) {
      // Si hay un error de conexión (ej: no hay internet)
      throw Exception('Error de conexión: $e');
    }
  }

  // ---
  // Método 2: Traer los detalles de UN Pokémon
  // ---
  Future<Map<String, dynamic>> fetchPokemonDetail(int id) async {
    // Construimos la URL final: ej: .../pokemon/25
    final uri = Uri.parse('$_baseUrl/pokemon/$id');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Si es OK, decodificamos el JSON del detalle
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        // Si el Pokémon no existe (ej: 404)
        throw Exception('Error al cargar detalles del Pokémon');
      }
    } catch (e) {
      // Error de conexión
      throw Exception('Error de conexión: $e');
    }
  }
}