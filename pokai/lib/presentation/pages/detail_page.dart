import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:pokai/data/models/pokemon_detail.dart';
import 'package:pokai/data/repositories/pokemon_repository.dart';
import 'package:pokai/state/favorites_controller.dart';

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
    if (!mounted) return;
    // No reiniciamos el estado aquí para no causar un parpadeo
    // setState(() { _isLoading = true; _error = null; });

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
    // Para el título, podemos adivinar el nombre si aún está cargando,
    // o simplemente mostrar el ID hasta que cargue.
    final titleName = _pokemonDetail?.name != null
        ? '${_pokemonDetail!.name[0].toUpperCase()}${_pokemonDetail!.name.substring(1)}'
        : 'Pokémon #${widget.pokemonId}';

    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
        // Dejamos que el Tema Global maneje el color del AppBar
        // backgroundColor: Colors.redAccent, 
        elevation: 0,
        // --- AÑADIMOS BOTÓN DE FAVORITO AQUÍ TAMBIÉN ---
        actions: [
          if (_pokemonDetail != null) // Solo mostrar si el pokémon cargó
            Consumer<FavoritesController>( // Importa 'favorites_controller.dart'
              builder: (context, controller, child) {
                final bool esFavorito = controller.isFavorite(_pokemonDetail!.id);
                return IconButton(
                  icon: Icon(
                    esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: esFavorito ? Colors.white : Colors.white70,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(_pokemonDetail!.id);
                  },
                  tooltip: 'Marcar como favorito',
                );
              },
            ),
          const SizedBox(width: 8), // Pequeño espacio
        ],
      ),
      // Pasamos el control al _buildBody
      body: _buildBody(),
    );
  }

  // --- [FUNCIÓN _buildBody() COMPLETAMENTE REHECHA] ---
  Widget _buildBody() {
    // Si hay un error, mostramos el error primero
    if (_error != null) {
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
              ),
            ],
          ),
        ),
      );
    }

    // --- CONSTRUIMOS LA UI INMEDIATAMENTE ---
    // (Incluso si _isLoading es true)
    
    // Si _pokemonDetail no es nulo, lo usamos. Si es nulo, usamos 'null'.
    final pokemon = _pokemonDetail;
    
    // Formateamos los datos solo si NO está cargando
    final String heightInMeters =
        !_isLoading && pokemon != null ? (pokemon.height / 10).toStringAsFixed(1) : '...';
    final String weightInKilograms =
        !_isLoading && pokemon != null ? (pokemon.weight / 10).toStringAsFixed(1) : '...';

    // Construimos la URL de la imagen del Hero manualmente
    // Si ya cargó, usa la URL del detalle.
    // Si no, CONSTRUYE la URL oficial usando el ID que ya tenemos.
    final String heroImageUrl = pokemon?.imageUrl ??
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonId}.png';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Imagen Grande (SIEMPRE SE CONSTRUYE)
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
            child: Hero(
              // ¡EL TAG SE CONSTRUYE CON EL ID DEL WIDGET!
              tag: 'pokemon-image-${widget.pokemonId}',
              child: CachedNetworkImage(
                imageUrl: heroImageUrl, // Usamos la URL construida
                placeholder: (context, url) => Container(
                  height: 250,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  alignment: Alignment.center,
                  // Si falla, mostramos el fallback pixelado
                  child: CachedNetworkImage(
                    imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemonId}.png',
                    errorWidget: (context, url, error) => Icon(Icons.question_mark, size: 60, color: Colors.grey[400]),
                  ),
                ),
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. Nombre y Número
          Text('#${widget.pokemonId.toString().padLeft(4, '0')}'), // Usamos el ID del widget
          const SizedBox(height: 8),
          Text(
            // Mostramos el nombre cuando cargue, si no "Cargando..."
            _isLoading ? 'Cargando...' : '${pokemon!.name[0].toUpperCase()}${pokemon.name.substring(1)}',
            style: GoogleFonts.pressStart2p(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300]),
          const SizedBox(height: 20),

          // 3. Tipos (Muestra spinner si está cargando)
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Wrap( // Si ya cargó, muestra los chips
                  spacing: 8.0,
                  runSpacing: 4.0,
                  alignment: WrapAlignment.center,
                  children: pokemon!.types
                      .map((type) => Chip(
                            label: Text(
                              type.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: _getColorForType(type),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                          ))
                      .toList(),
                ),
          const SizedBox(height: 24),

          // 4. Altura y Peso (Muestra '...' si está cargando)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn('Altura', '$heightInMeters m'),
              _buildStatColumn('Peso', '$weightInKilograms kg'),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget helper (sin cambios)
  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Función de color (sin cambios)
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