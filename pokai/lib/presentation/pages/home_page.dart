// lib/presentation/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokai/state/pokemon_list_controller.dart';
import 'package:pokai/presentation/widgets/pokemon_card.dart';
// En el siguiente paso importaremos detail_page.dart

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controlador para el scroll infinito
  final ScrollController _scrollController = ScrollController();
  // Controlador para el campo de texto de búsqueda
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Añadir listener para el scroll infinito
    _scrollController.addListener(_onScroll);

    // Añadir listener para la búsqueda (llama a setQuery en el controller)
    _searchController.addListener(() {
      // Usamos context.read porque estamos fuera del 'build'
      context.read<PokemonListController>().setQuery(_searchController.text);
    });
  }

  // Lógica para cargar más al llegar al final (solo si no estamos buscando)
  void _onScroll() {
    // Verificamos si el scroll está cerca del final Y si no estamos en modo búsqueda
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        !context.read<PokemonListController>().isSearching) {
      // Pedimos al controller que cargue la siguiente página
      context.read<PokemonListController>().loadMore();
    }
  }

  @override
  void dispose() {
    // "Despedir" a los controladores para liberar memoria
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.removeListener(() {}); // Quitamos el listener explícitamente
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokai - Mi Pokédex'),
        // Usamos 'bottom' para colocar la barra de búsqueda debajo del título
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // Altura estándar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController, // Conectar al controlador de texto
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon...', // Texto de ayuda
                prefixIcon: const Icon(Icons.search, color: Colors.grey), // Ícono de lupa
                // Estilo del borde y fondo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
                  borderSide: BorderSide.none, // Sin línea de borde
                ),
                filled: true, // Habilitar color de fondo
                fillColor: Colors.white, // Fondo blanco
                contentPadding: EdgeInsets.zero, // Ajustar padding interno
                // Ícono 'X' para borrar (aparece solo si hay texto)
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear(); // Borrar texto
                          // Llamar a setQuery con '' resetea la búsqueda en el controller
                          context.read<PokemonListController>().setQuery('');
                          // Opcional: Quitar foco para ocultar teclado
                          FocusScope.of(context).unfocus();
                        },
                      )
                    : null, // Si no hay texto, no mostrar la 'X'
              ),
              // Llamado cada vez que el texto cambia
              onChanged: (value) {
                // Forzamos a redibujar el AppBar para que la 'X' aparezca/desaparezca
                // La lógica de búsqueda real la maneja el listener en initState
                setState(() {});
              },
            ),
          ),
        ),
        // Opcional: Darle un poco de elevación al AppBar
        elevation: 2.0,
        backgroundColor: Theme.of(context).primaryColor, // Usar color primario del tema
      ),
      // Usamos Consumer para escuchar los cambios del PokemonListController
      body: Consumer<PokemonListController>(
        builder: (context, controller, child) {
          // --- CASO 1: Cargando datos iniciales (solo si no estamos buscando) ---
          if (controller.pokemonList.isEmpty &&
              controller.isLoadingMore &&
              !controller.isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          // --- CASO 2: No se encontraron resultados para la búsqueda ---
          if (controller.isSearching && controller.pokemonList.isEmpty) {
            return const Center(
              child: Text(
                'No se encontraron resultados',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          // --- CASO 3: Mostrar la lista (completa o filtrada) ---
          return ListView.builder(
            controller: _scrollController, // Conectar el controlador de scroll
            // Si estamos buscando, el itemCount es solo la lista filtrada
            // Si no, es la lista + 1 para el espacio del footer de carga
            itemCount: controller.isSearching
                ? controller.pokemonList.length
                : controller.pokemonList.length + 1,
            itemBuilder: (context, index) {
              // --- Lógica del Footer (Solo si NO estamos buscando) ---
              if (!controller.isSearching && index == controller.pokemonList.length) {
                // Si es el último ítem (el '+1')
                if (controller.hasMore) {
                  // Si hay más por cargar, mostrar spinner
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0), // Más espacio
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  // Si ya no hay más, mostrar mensaje final
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('¡Has atrapado a todos!')),
                  );
                }
              }

              // --- Ítem normal de la lista (Pokémon) ---
              // Obtenemos el Pokémon correspondiente (de la lista original o filtrada)
              final pokemon = controller.pokemonList[index];
              // Devolvemos la tarjeta personalizada
              return PokemonCard(pokemon: pokemon);
            },
          );
        },
      ),
      // Opcional: Cambiar color de fondo general de la app
      backgroundColor: Colors.grey[100],
    );
  }
}