import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/screens/myads/components_myads/active_tile.dart';
import 'package:xlo_mobx/screens/myads/components_myads/pending_tile.dart';
import 'package:xlo_mobx/screens/myads/components_myads/sold_tile.dart';
import 'package:xlo_mobx/stores/myads_store.dart';

class MyadsScreen extends StatefulWidget {
  const MyadsScreen({super.key, this.initialPage = 0});

  final int? initialPage;

  @override
  State<MyadsScreen> createState() => _MyadsScreenState();
}

class _MyadsScreenState extends State<MyadsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final MyAdsStore store = MyAdsStore();

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialPage!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Anúncios', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.orange,
          tabs: [
            Tab(
              child: Text('ATIVOS', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('PENDENTES', style: TextStyle(color: Colors.white)),
            ),
            Tab(
              child: Text('VENDIDOS', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: Observer(
        builder: (_) {
          if (store.loading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            );
          }
          return TabBarView(
            controller: tabController,
            children: <Widget>[
              Observer(
                builder: (_) {
                  if (store.activeAds.isEmpty) {
                    return EmptyCard(
                      text: 'Você não possui nenhum anúncio ativo!',
                    );
                  }
                  return ListView.builder(
                    itemCount: store.activeAds.length,
                    itemBuilder: (_, index) {
                      return ActiveTile(
                        ad: store.activeAds[index],
                        store: store,
                      );
                    },
                  );
                },
              ),
              Observer(
                builder: (_) {
                  if (store.pendingAds.isEmpty) {
                    return EmptyCard(
                      text: 'Você não possui nenhum anúncio pendente!',
                    );
                  }
                  return ListView.builder(
                    itemCount: store.pendingAds.length,
                    itemBuilder: (_, index) {
                      return PendingTile(ad: store.pendingAds[index]);
                    },
                  );
                },
              ),
              Observer(
                builder: (_) {
                  if (store.soldAds.isEmpty) {
                    return EmptyCard(
                      text: 'Você não possui nenhum anúncio vendido!',
                    );
                  }
                  return ListView.builder(
                    itemCount: store.soldAds.length,
                    itemBuilder: (_, index) {
                      return SoldTile(ad: store.soldAds[index], store: store);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
