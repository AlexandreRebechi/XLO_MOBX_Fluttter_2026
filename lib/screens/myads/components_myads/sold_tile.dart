import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xlo_mobx/helpers/extensions.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/stores/myads_store.dart';

class SoldTile extends StatelessWidget {
  const SoldTile({super.key, required this.ad, required this.store});

  final Ad ad;
  final MyAdsStore store;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    store.deleteAd(ad);
                  },
                  icon: Icon(Icons.delete),
                  iconSize: 20,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
