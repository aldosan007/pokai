// lib/presentation/widgets/pokemon_card.dart (Versión 2 - Con Fallback)

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokai/data/models/pokemon_list_item.dart';

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
      color: Colors.white,
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // TODO: Navegar a la pantalla de detalle en el Paso 7
          print('Tocaste a: ${pokemon.name}');
        },
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

                  // 2. Si la URL "oficial" falla (ej: por error 429)...
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

              // --- Columna del Nombre y Número ---
              Expanded(
                flex: 3, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${pokemon.id.toString().padLeft(4, '0')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                      style: GoogleFonts.pressStart2p(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                    ),
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