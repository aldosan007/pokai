// lib/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokai/state/pokemon_list_controller.dart';
// En el próximo paso, importaremos 'pokemon_card.dart'

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Creamos el "espía" del scroll
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // 2. Le decimos al "espía" que llame a _onScroll CADA VEZ que haya scroll
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // 3. Lógica del Scroll Infinito
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent * 0.9) {
          
      // Si el scroll está al 90% del final
      // le pedimos al "cerebro" (Controller) que cargue más.
      // Usamos 'context.read' porque estamos en un método, no en 'build'.
      context.read<PokemonListController>().loadMore();
    }
  }

  @override
  void dispose() {
    // 4. "Despedimos" al espía para evitar fugas de memoria
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokai - Mi Pokédex'),
        // TODO: Añadir barra de búsqueda aquí
      ),
      // 5. Usamos Consumer para "escuchar" al cerebro
      body: Consumer<PokemonListController>(
        builder: (context, controller, child) {
          
          // --- CASO 1: Cargando por primera vez ---
          // Si la lista está vacía Y estamos cargando
          if (controller.pokemonList.isEmpty && controller.isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- CASO 2: Error o sin resultados (aún no implementado) ---
          // TODO: Añadir 'No se encontraron resultados'

          // --- CASO 3: Lista principal ---
          return ListView.builder(
            controller: _scrollController, // ¡Conectamos el "espía" al ListView!
            
            // 6. El tamaño es la lista + 1 (para el footer de carga)
            itemCount: controller.pokemonList.length + 1,
            
            itemBuilder: (context, index) {
              
              // 7. Lógica del Footer de Carga
              if (index == controller.pokemonList.length) {
                // Si es el último ítem
                if (controller.hasMore) {
                  // Y hay más por cargar, mostramos el spinner
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  // Si no hay más, mostramos un texto
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No hay más Pokémon')),
                  );
                }
              }

              // --- Ítem normal de la lista ---
              final pokemon = controller.pokemonList[index];
              
              // Placeholder temporal (reemplazaremos esto con PokemonCard)
              return ListTile(
                leading: Text('#${pokemon.id}'),
                title: Text(pokemon.name),
                // TODO: Reemplazar con PokemonCard
              );
            },
          );
        },
      ),
    );
  }
}