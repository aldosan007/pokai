import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokai/data/models/pokemon_list_item.dart';
import 'package:pokai/presentation/pages/detail_page.dart';
import 'package:provider/provider.dart';
import 'package:pokai/state/favorites_controller.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListItem pokemon;

  const PokemonCard({super.key, required this.pokemon});

  // URL del sprite pixelado (fallback)
  String get fallbackSpriteUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // Usamos el shape del tema
      shape: Theme.of(context).cardTheme.shape,
      // No definimos margen aquí, lo dejamos al GridView (crossAxisSpacing)
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(pokemonId: pokemon.id),
            ),
          );
        },
        splashColor: const Color.fromARGB(26, 244, 67, 54),
        highlightColor: const Color.fromARGB(13, 244, 67, 54),
        borderRadius:
            (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                .borderRadius
                .resolve(Directionality.of(context)),

        // --- [INICIO DEL CAMBIO DE LAYOUT] ---
        // Usamos una Columna en lugar de un Row
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Estirar hijos a lo ancho
          children: [
            // --- 1. IMAGEN (Ahora ocupa la parte de arriba) ---
            Expanded(
              flex: 6, // La imagen ocupa la mayor parte del espacio
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Un pequeño padding
                child: Hero(
                  // El tag debe ser único. Usamos el ID.
                  tag: 'pokemon-image-${pokemon.id}',
                  child: CachedNetworkImage(
                    imageUrl: pokemon.spriteUrl,
                    // ... (resto de tu código de CachedNetworkImage)
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.red.shade200,
                        strokeWidth: 2.0,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return CachedNetworkImage(
                        imageUrl: fallbackSpriteUrl,
                        errorWidget: (context, urlFallback, errorFallback) {
                          return Icon(
                            Icons.question_mark_rounded,
                            color: Colors.grey.shade400,
                            size: 40,
                          );
                        },
                        fit: BoxFit.contain,
                      );
                    },
                    fit: BoxFit.contain,
                  ),
                ),
                // --- FIN DEL WIDGET HERO --
              ),
            ),

            // --- 2. CONTENEDOR DE TEXTO Y FAVORITO (Abajo) ---
            Expanded(
              flex: 3, // Ocupa el espacio restante
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 4.0,
                ),
                child: Column(
                  // Centramos el texto y el ID
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Row para el ID y el Corazón ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Empuja el corazón a la derecha
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ID del Pokémon
                        Text(
                          '#${pokemon.id.toString().padLeft(4, '0')}',
                          style: TextStyle(
                            fontSize: 12, // ID más pequeño
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        // Botón de Favorito
                        Consumer<FavoritesController>(
                          builder: (context, controller, child) {
                            final bool esFavorito = controller.isFavorite(
                              pokemon.id,
                            );
                            return InkWell(
                              // Usamos InkWell para un área de toque más pequeña
                              onTap: () {
                                controller.toggleFavorite(pokemon.id);
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Icon(
                                esFavorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: esFavorito
                                    ? Colors.red
                                    : Colors.grey[400],
                                size: 24, // Icono más pequeño
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    // Espacio
                    const Spacer(),
                    // Nombre del Pokémon
                    Text(
                      '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 11, // Fuente más pequeña para que quepa
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4), // Pequeño espacio al fondo
                  ],
                ),
              ),
            ),
            // --- [FIN DEL CAMBIO DE LAYOUT] ---
          ],
        ),
      ),
    );
  }
}
