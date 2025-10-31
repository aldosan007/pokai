import 'package:flutter/material.dart';
import 'package:pokai/presentation/pages/home_page.dart';
import 'package:provider/provider.dart'; // 1. Importamos Provider

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
        Provider<PokemonRepository>(
          create: (_) => repository,
        ),

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
        // Podríamos añadir más providers aquí (ej: PokemonDetailController)
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

          // 1. Define el TEMA CLARO
          theme: buildAppTheme(), // Nuestra función de tema claro

          // 2. Define el TEMA OSCURO
          darkTheme: buildAppDarkTheme(), // Nuestra función de tema oscuro

          // 3. Elige QUÉ TEMA MOSTRAR
          // basado en el estado del ThemeController
          themeMode: themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const HomePage(),
        );
      },
    );
    // --- FIN DEL CONSUMER ---
  }
}