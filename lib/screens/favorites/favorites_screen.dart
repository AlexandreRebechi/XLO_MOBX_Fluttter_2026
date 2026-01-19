import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/custom_drawer/custom_drawer.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/screens/favorites/components_favorites/favorite_tile.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key, this.hideDrawer = false});

  final bool hideDrawer;
  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      drawer: hideDrawer ? null : CustomDrawer(),
      body: Observer(
        builder: (_) {
          if (favoriteStore.favoriteList.isEmpty) {
            return EmptyCard(text: 'Nenhum anúcio favoritado.');
          }
          return ListView.builder(
            padding: const EdgeInsets.all(2),
            itemCount: favoriteStore.favoriteList.length,
            itemBuilder: (_, index) =>
                FavoriteTile(ad: favoriteStore.favoriteList[index]),
          );
        },
      ),
    );
  }
}
