// lib/presentation/pages/detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Para acceder al Repository
import 'package:pokai/data/models/pokemon_detail.dart';
import 'package:pokai/data/repositories/pokemon_repository.dart';
// Importaremos CachedNetworkImage más adelante

class DetailPage extends StatefulWidget {
  final int pokemonId; // Recibimos el ID

  const DetailPage({super.key, required this.pokemonId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  PokemonDetail? _pokemonDetail; // Variable para guardar los detalles
  bool _isLoading = true; // Estado de carga
  String? _error; // Para guardar mensajes de error

  @override
  void initState() {
    super.initState();
    _loadDetails(); // Iniciamos la carga al crear la pantalla
  }

  // Función para cargar los detalles usando el Repository
  Future<void> _loadDetails() async {
    try {
      // Obtenemos el Repository usando Provider
      final repository = context.read<PokemonRepository>();
      // Pedimos los detalles usando el ID que recibimos (widget.pokemonId)
      final detail = await repository.getPokemonDetail(widget.pokemonId);

      // Si la pantalla sigue "montada" (visible), actualizamos el estado
      if (mounted) {
        setState(() {
          _pokemonDetail = detail;
          _isLoading = false;
          _error = null; // Limpiamos cualquier error previo
        });
      }
    } catch (e) {
      // Si ocurre un error durante la carga
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Error al cargar detalles: $e';
        });
      }
      print('Error en DetailPage._loadDetails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mostramos el nombre cuando esté cargado, si no, "Cargando..."
        title: Text(_pokemonDetail?.name ?? 'Cargando...'),
        backgroundColor: Colors.red, // Mantenemos el color
      ),
      body: _buildBody(), // Usamos una función helper para el cuerpo
    );
  }

  // Función helper para construir el cuerpo según el estado
  Widget _buildBody() {
    if (_isLoading) {
      // 1. Estado Cargando
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      // 2. Estado Error
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loadDetails, // Botón para reintentar
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    } else if (_pokemonDetail != null) {
      // 3. Estado Éxito (Mostramos los detalles)
      // TODO: Construir la UI detallada en el siguiente paso
      return Center(
        child: Text(
          '¡Detalles de ${_pokemonDetail!.name} cargados!',
          style: const TextStyle(fontSize: 20),
        ),
      );
    } else {
      // Estado inesperado (no debería ocurrir)
      return const Center(child: Text('Estado inesperado'));
    }
  }
}