# Pokai: Pokédex Interactiva

Aplicación Flutter que usa la [PokeAPI](https://pokeapi.co/) para mostrar, buscar y explorar Pokémon.

---

## Funcionalidades
- Lista de Pokémon con número, nombre e imagen.  
- **Scroll infinito** para cargar más al llegar al final.  
- **Búsqueda en tiempo real** por nombre.  
- **Pantalla de detalle** con imagen, tipos, altura y peso.  
- **Modo oscuro/claro** y **favoritos**, guardados con `SharedPreferences`.  
- **Animación Hero** entre lista y detalle.  

---

## Tecnologías
- **Flutter / Dart**  
- **http** – Peticiones a la API  
- **provider** – Manejo de estado  
- **cached_network_image** – Cache de imágenes  
- **google_fonts** – Tipografía  
- **shared_preferences** – Datos locales  

---

## Ejecución
```bash
git clone https://github.com/aldosan007/pokai.git
cd pokai
flutter pub get
flutter run
```

---

## Desafíos Encontrados
•	Error 429 (Too Many Requests): Al hacer scroll rápido, el servidor bloquea temporalmente las imágenes.
🔹 Solución: Implementación de un “fallback” que intenta cargar otra imagen o muestra un ícono por defecto.
•	Animación Hero: Inicialmente no funcionaba porque la pantalla de detalle mostraba un CircularProgressIndicator.
🔹 Solución: Mantener el Hero activo mientras se cargan los demás datos para asegurar una transición fluida.

---

## Aprendizajes del Proyecto
•	Separación de la lógica en capas (Datos, Estado y Presentación).
•	Uso de Provider para manejo global del estado.
•	Implementación de scroll infinito con ScrollController.
•	Manejo de errores y límites de la API externa.
•	Temas dinámicos (oscuro / claro) con persistencia local.
•	Creación de animaciones implícitas (Hero) para una experiencia más profesional.

---