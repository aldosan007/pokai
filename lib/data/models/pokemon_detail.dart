class PokemonDetail {
  final int id;
  final String name;
  final String imageUrl;      // La imagen grande 
  final List<String> types;   // Los tipos (ej: ['grass', 'poison']) [cite: 28]
  final int height;           // Altura (en decímetros) [cite: 29]
  final int weight;           // Peso (en hectogramos) [cite: 29]

  PokemonDetail({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  // Constructor "de fábrica" que parsea el JSON de detalle
  factory PokemonDetail.fromApi(Map<String, dynamic> json) {
    
    // 1. Parsear la lista de tipos
    // El JSON 'types' es una lista de objetos.
    // Debemos iterar la lista y extraer el 'name' de cada tipo.
    final List<dynamic> typeListJson = json['types'];
    final List<String> typeNames = typeListJson.map((typeJson) {
      return typeJson['type']['name'] as String;
    }).toList();

    // 2. Parsear la URL de la imagen (sprite)
    // La API es quisquillosa. La imagen "oficial" está muy anidada.
    // A veces puede ser nula, así que ponemos un "fallback" (una imagen de respaldo).
    final String imageUrl = 
      json['sprites']['other']['official-artwork']['front_default'] ?? 
      json['sprites']['front_default']; // Fallback al sprite pixelado si el oficial no existe

    // 3. Crear y devolver el objeto
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'], // La API lo da en decímetros
      weight: json['weight'], // La API lo da en hectogramos
      types: typeNames,
      imageUrl: imageUrl,
    );
  }
}