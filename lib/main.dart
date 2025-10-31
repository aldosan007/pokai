import 'package:flutter/material.dart';
import 'package:pokai/presentation/pages/home_page.dart';
import 'package:provider/provider.dart'; // 1. Importamos Provider
import 'package:pokai/state/favorites_controller.dart';

// Importamos nuestras clases (el "cerebro" y sus dependencias)
import 'package:pokai/data/repositories/pokemon_repository.dart';
import 'package:pokai/data/services/poke_api_service.dart';
import 'package:pokai/state/pokemon_list_controller.dart';
import 'package:pokai/core/theme.dart';
import 'package:pokai/state/theme_controller.dart';

void main() {
  // --- Configuración de Dependencias ---
  // Creamos las instancias "de abajo hacia arriba":
  // 1. El Mensajero
  final PokeApiService apiService = PokeApiService();
  // 2. El Gerente (que usa al mensajero)
  final PokemonRepository repository = PokemonRepository(apiService);
  // --- Fin de Configuración ---

  runApp(
    // 3. "Inyectamos" el Cerebro (Controller) usando Provider
    // Usamos MultiProvider para inyectar MÁS DE UNA COSA
    MultiProvider(
      providers: [
        // 1. Proveemos el Repository directamente
        //    Cualquier widget hijo podrá pedirlo con context.read<PokemonRepository>()
        Provider<PokemonRepository>(create: (_) => repository),

        // 2. Proveemos el Controller (que DEPENDE del Repository)
        //    Usamos context.read() DENTRO de create para obtener el repo ya provisto.
        ChangeNotifierProvider<PokemonListController>(
          create: (context) => PokemonListController(
            context.read<PokemonRepository>(), // Le pasamos el repo
          )..loadInitial(), // Iniciamos la carga
        ),
        ChangeNotifierProvider<ThemeController>(
          create: (_) => ThemeController(), // Crea el cerebro del tema
        ),
        ChangeNotifierProvider<FavoritesController>(
          create: (_) => FavoritesController(), // Crea el cerebro de favoritos
        ),
      ],
      // MyApp sigue siendo el hijo principal
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // "Escucha" al ThemeController para redibujar cuando cambie el tema
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        // El Consumer nos da el 'themeController'
        return MaterialApp(
          title: 'Pokai',
          debugShowCheckedModeBanner: false,

          // Elige el tema instantáneamente
          theme: themeController.isDarkMode
              ? buildAppDarkTheme() // Si está en modo oscuro, usa el tema oscuro
              : buildAppTheme(), // Si no, usa el tema claro

          // Estas propiedades ya no son necesarias:
          // darkTheme: buildAppDarkTheme(),
          // themeMode: themeController.isDarkMode ...
          home: const HomePage(),
        );
      },
    );
    // --- FIN DEL CONSUMER ---
  }
}
