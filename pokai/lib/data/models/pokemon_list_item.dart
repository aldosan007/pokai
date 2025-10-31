class PokemonListItem {
  final int id;
  final String name;
  final String spriteUrl;

  // Constructor principal
  PokemonListItem({
    required this.id,
    required this.name,
    required this.spriteUrl,
  });

  // Un "constructor de fábrica" que crea un PokemonListItem
  // desde el JSON que nos da la lista de la PokeAPI.
  factory PokemonListItem.fromApi(Map<String, dynamic> json) {
    
    // El JSON de la lista nos da "name" y "url"
    final String name = json['name'];
    final String url = json['url'];

    // 1. Extraemos el ID de la URL.
    // La URL es como ".../pokemon/25/"
    // Quitamos la barra final, dividimos por "/" y tomamos el penúltimo trozo.
    final id = int.parse(url.split('/')[url.split('/').length - 2]);

    // 2. Construimos la URL del sprite oficial.
    // Esta es la URL estándar para los sprites "oficiales" (mejores que los pixelados).
    final spriteUrl = 
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

    return PokemonListItem(
      id: id,
      name: name,
      spriteUrl: spriteUrl,
    );
  }
}