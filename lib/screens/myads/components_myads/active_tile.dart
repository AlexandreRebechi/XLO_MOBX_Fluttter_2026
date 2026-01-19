import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/screens/ad/ad_screen.dart';
import 'package:xlo_mobx/screens/create/create_screen.dart';
import 'package:xlo_mobx/stores/myads_store.dart';

class ActiveTile extends StatelessWidget {
  ActiveTile({super.key, required this.ad, required this.store});

  final Ad ad;
  final MyAdsStore store;

  final List<MenuChoice> choices = [
    MenuChoice(index: 0, title: 'Editar', iconData: Icons.edit),
    MenuChoice(index: 1, title: 'Já vendi', iconData: Icons.thumb_up),
    MenuChoice(index: 2, title: 'Excluir', iconData: Icons.delete),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => AdScreen(ad: ad)));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Container(
          height: 80,
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: ad.images!.isEmpty
                      ? 'https://cdn-icons-png.flaticon.com/512/1695/1695213.png'
                      : ad.images!.first,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ad.title ?? 'Sem título',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        ad.price != null
                            ? ad.price!.formattedMoney()
                            : 'Preço não informado',
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '${ad.views} visitas ',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<MenuChoice>(
                onSelected: (choice) {
                  switch (choice.index) {
                    case 0:
                      editAd(context);
                      break;
                    case 1:
                      soldAd(context);
                      break;
                    case 2:
                      deleteAd(context);
                      break;
                  }
                },
                icon: Icon(Icons.more_vert, size: 20, color: Colors.purple),
                itemBuilder: (_) {
                  return choices
                      .map(
                        (choice) => PopupMenuItem<MenuChoice>(
                          value: choice,
                          child: Row(
                            children: <Widget>[
                              Icon(
                                choice.iconData,
                                size: 20,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                choice.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editAd(BuildContext context) async {
    final success = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CreateScreen(ad: ad)));
    if (success != null && success) {}
  }

  Future<void> soldAd(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Vendido'),
        content: Text('Confirmar a venda de ${ad.title}'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Não', style: TextStyle(color: Colors.purple)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              store.soldAd(ad);
            },
            child: Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAd(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Excluir'),
        content: Text('Confirmar a exclusão de ${ad.title}'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('Não', style: TextStyle(color: Colors.purple)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              store.deleteAd(ad);
            },
            child: Text('Sim', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class MenuChoice {
  MenuChoice({
    required this.index,
    required this.title,
    required this.iconData,
  });

  final int index;
  final String title;
  final IconData iconData;
}
