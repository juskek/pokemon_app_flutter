import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pokemon_app_flutter/data/pokedex_pokemon_response.dart';
import 'package:pokemon_app_flutter/view/pokedex_list/pokedex_list_item.dart';

class PokedexListView extends StatefulWidget {
  const PokedexListView({super.key});

  @override
  PokedexListViewState createState() => PokedexListViewState();
}

class PokedexListViewState extends State<PokedexListView> {
  final PagingController<String, Pokemon> _pagingController = PagingController(
      firstPageKey: "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20");

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageUri) {
      _fetchPage(pageUri);
    });
    super.initState();
  }

  Future<void> _fetchPage(String pageUri) async {
    try {
      final response = await http.get(Uri.parse(pageUri));
      final newItems =
          PokedexPokemonResponse.fromJson(jsonDecode(response.body));
      if (newItems.results == null) {
        return;
      }

      if (newItems.next == null) {
        _pagingController.appendLastPage(newItems.results!);
      } else {
        _pagingController.appendPage(newItems.results!, newItems.next);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => PagedListView<String, Pokemon>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Pokemon>(
          itemBuilder: (context, item, index) => PokedexListItem(
            pokemon: item,
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
