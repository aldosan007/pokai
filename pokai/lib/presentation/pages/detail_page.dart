import 'package:cached_network_image/cached_network_image.dart'; // Importar para la imagen
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart'; // Para fuentes
import 'package:provider/provider.dart';
import 'package:pokai/data/models/pokemon_detail.dart';
import 'package:pokai/data/repositories/pokemon_repository.dart';

class DetailPage extends StatefulWidget {
  final int pokemonId;

  const DetailPage({super.key, required this.pokemonId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  PokemonDetail? _pokemonDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    // Reiniciar estado si estamos reintentando
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repository = context.read<PokemonRepository>();
      final detail = await repository.getPokemonDetail(widget.pokemonId);
      if (mounted) {
        setState(() {
          _pokemonDetail = detail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'No se pudieron cargar los detalles. Verifica tu conexión.';
        });
      }
      print('Error en DetailPage._loadDetails: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el nombre capitalizado para el título
    final titleName = _pokemonDetail?.name != null
      ? '${_pokemonDetail!.name[0].toUpperCase()}${_pokemonDetail!.name.substring(1)}'
      : 'Cargando...';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
        backgroundColor: Colors.redAccent, // Un rojo un poco más vibrante
        elevation: 0, // Sin sombra para un look más plano
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                onPressed: _loadDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (_pokemonDetail != null) {
      // --- Estado Éxito: Construimos la UI con los detalles ---
      final pokemon = _pokemonDetail!;
      // Formateo de altura y peso
      final heightInMeters = (pokemon.height / 10).toStringAsFixed(1); // ej: 7 dm -> 0.7 m
      final weightInKilograms = (pokemon.weight / 10).toStringAsFixed(1); // ej: 69 hg -> 6.9 kg

      return SingleChildScrollView( // Para permitir scroll si el contenido es largo
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Imagen Grande
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5))
                ],
              ),
              child: CachedNetworkImage(
                imageUrl: pokemon.imageUrl,
                placeholder: (context, url) => Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: Icon(Icons.question_mark, size: 60, color: Colors.grey[400]),
                ),
                height: 250, // Más grande
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),

            // 2. Nombre y Número
            Text(
              '#${pokemon.id.toString().padLeft(4, '0')}',
            ),
            const SizedBox(height: 8),
            Text(
              '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Divider(color: Colors.grey[300]), // Separador visual
            const SizedBox(height: 20),

            // 3. Tipos (en Chips)
            Wrap( // Permite que los chips pasen a la siguiente línea si no caben
              spacing: 8.0, // Espacio horizontal entre chips
              runSpacing: 4.0, // Espacio vertical entre líneas de chips
              alignment: WrapAlignment.center,
              children: pokemon.types.map((type) => Chip(
                label: Text(
                  type.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: _getColorForType(type), // Función helper para el color
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              )).toList(),
            ),
            const SizedBox(height: 24),

            // 4. Altura y Peso (en una fila)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espaciado equitativo
              children: [
                _buildStatColumn('Altura', '$heightInMeters m'),
                _buildStatColumn('Peso', '$weightInKilograms kg'),
              ],
            ),
            const SizedBox(height: 20), // Espacio al final
          ],
        ),
      );
    } else {
      return const Center(child: Text('No hay datos para mostrar'));
    }
  }

  // Widget helper para mostrar Altura/Peso
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
        ),
        const SizedBox(height: 4),
        Text(
          value,
        ),
      ],
    );
  }

  // Función helper para asignar colores a los tipos
  // (Puedes expandir esto con más tipos o usar un paquete)
  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green.shade400;
      case 'fire': return Colors.red.shade400;
      case 'water': return Colors.blue.shade400;
      case 'bug': return Colors.lightGreen.shade400;
      case 'normal': return Colors.brown.shade300;
      case 'poison': return Colors.purple.shade400;
      case 'electric': return Colors.amber.shade600;
      case 'ground': return Colors.orange.shade300;
      case 'fairy': return Colors.pink.shade300;
      case 'fighting': return Colors.deepOrange.shade600;
      case 'psychic': return Colors.pinkAccent.shade400;
      case 'rock': return Colors.grey.shade600;
      case 'ghost': return Colors.deepPurple.shade400;
      case 'ice': return Colors.lightBlue.shade300;
      case 'dragon': return Colors.indigo.shade400;
      case 'dark': return Colors.black87;
      case 'steel': return Colors.blueGrey.shade400;
      case 'flying': return Colors.lightBlue.shade200;
      default: return Colors.grey.shade400;
    }
  }
}