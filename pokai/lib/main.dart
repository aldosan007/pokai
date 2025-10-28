// lib/main.dart (¡Versión permanente!)

import 'package:flutter/material.dart';
import 'package:pokai/presentation/pages/home_page.dart';
import 'package:provider/provider.dart'; // 1. Importamos Provider

// Importamos nuestras clases (el "cerebro" y sus dependencias)
import 'package:pokai/data/repositories/pokemon_repository.dart';
import 'package:pokai/data/services/poke_api_service.dart';
import 'package:pokai/state/pokemon_list_controller.dart';
// (En el próximo paso, importaremos la HomePage aquí)


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
    ChangeNotifierProvider(
      
      // 'create' es la "fábrica" que construye nuestro cerebro.
      // Le pasamos el "gerente" (repository) que necesita para trabajar.
      create: (context) => PokemonListController(repository)
                          ..loadInitial(), // <-- El '..' es CLAVE:
                                          // Crea el cerebro E INICIA la 1ra carga de datos
      
      child: const MyApp(), // 4. Nuestra app principal es "hija" del Provider
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokai',
      debugShowCheckedModeBanner: false, // Quitamos la cinta de "Debug"
      theme: ThemeData( // Un tema base simple por ahora
        brightness: Brightness.light,
        primarySwatch: Colors.red, // Tono rojizo estilo Pokédex
        fontFamily: 'Roboto', 
      ),
      home: const HomePage(),
    );
  }
}