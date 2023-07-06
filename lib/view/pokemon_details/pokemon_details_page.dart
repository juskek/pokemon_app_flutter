import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app_flutter/data/pokedex_pokemon_response.dart';

class PokemonDetailsPage extends StatelessWidget {
  const PokemonDetailsPage({required this.pokemon, super.key});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pokemon.name ?? 'null name'),
        ),
        body: Center(
            child: FutureBuilder(
          future: http.get(Uri.parse(pokemon.url!)),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.connectionState == ConnectionState.done) {
              final data = jsonDecode(snapshot.data!.body);

              return Column(
                children: [
                  Text('Height: ${data['height']}'),
                  Text('Weight: ${data['weight']}'),
                  Text(
                      'Abilities: ${(data['abilities'] as List).map((e) => e['ability']['name']).join(', ')}'),
                ],
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const CircularProgressIndicator();
          },
        )));
  }
}
