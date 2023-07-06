import 'package:flutter/material.dart';
import 'package:pokemon_app_flutter/data/pokedex_pokemon_response.dart';
import 'package:pokemon_app_flutter/view/pokemon_details/pokemon_details_page.dart';

class PokedexListItem extends StatelessWidget {
  const PokedexListItem({
    required this.pokemon,
    Key? key,
  }) : super(key: key);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(pokemon.name ?? 'null name'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PokemonDetailsPage(
                    pokemon: pokemon,
                  )),
        ),
      );
}
