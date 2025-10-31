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

  // URL del sprite pixelado (nuestro fallback)
  String get fallbackSpriteUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // Usamos el shape del tema para bordes redondeados
      shape: Theme.of(context).cardTheme.shape, 
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              // Construimos la DetailPage, pasándole el ID del pokémon tocado
              builder: (context) => DetailPage(pokemonId: pokemon.id),
            ),
          );
        },
        // Estilos para el "splash" (onda) al tocar
        splashColor: Colors.red.withOpacity(0.1),
        highlightColor: Colors.red.withOpacity(0.05),
        // Asegurar que el splash respete los bordes redondeados
        borderRadius: (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
            .borderRadius
            .resolve(Directionality.of(context)), 

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // --- Columna de la Imagen (Sprite) ---
              Expanded(
                flex: 2,
                child: CachedNetworkImage(
                  // 1. Intenta cargar la imagen "oficial"
                  imageUrl: pokemon.spriteUrl, // La URL bonita
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Colors.red.shade200,
                    ),
                  ),

                  // 2. Si la URL "oficial" falla...
                  errorWidget: (context, url, error) {
                    // ...en lugar de un ícono, intentamos cargar
                    // la imagen de fallback (la pixelada).
                    return CachedNetworkImage(
                      imageUrl: fallbackSpriteUrl, // <-- Usamos el fallback
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      // Si INCLUSO el fallback falla, mostramos una '?'
                      errorWidget: (context, url, error) => Icon(
                        Icons.question_mark,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                      fit: BoxFit.contain,
                      height: 80,
                    );
                  },
                  fit: BoxFit.contain,
                  height: 80,
                ),
              ),
              const SizedBox(width: 16),

              // Columna del Nombre, Número Y BOTÓN DE FAVORITO
              Expanded(
                flex: 3, // Ocupa el espacio restante
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear contenido arriba
                  children: [
                    // Columna de texto (envuelta en Expanded)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, // Centrar texto
                        children: [
                          Text(
                            '#${pokemon.id.toString().padLeft(4, '0')}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600], // Color sutil (opcional)
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                            style: GoogleFonts.pressStart2p(
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // ---EL BOTÓN DE FAVORITO ---
                    // "Escucha" al FavoritesController para saber el estado
                    Consumer<FavoritesController>(
                      builder: (context, controller, child) {
                        // Verifica si este pokémon es favorito
                        final bool esFavorito = controller.isFavorite(pokemon.id);
                        
                        return IconButton(
                          // Muestra ícono de corazón lleno o vacío
                          icon: Icon(
                            esFavorito ? Icons.favorite : Icons.favorite_border,
                            // El color SÍ lo definimos aquí (rojo o gris)
                            color: esFavorito ? Colors.red : Colors.grey[400],
                            size: 28, // Tamaño del ícono
                          ),
                          onPressed: () {
                            // Llama a la función del controlador para añadir/quitar
                            controller.toggleFavorite(pokemon.id);
                          },
                          // Estilo para que el botón no añada padding extra
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        );
                      },
                    ),
                    // --- FIN DEL BOTÓN ---
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}