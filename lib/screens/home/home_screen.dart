import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/custom_drawer/custom_drawer.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/screens/home/components_home/ad_tile.dart';
import 'package:xlo_mobx/screens/home/components_home/create_ad_button.dart';
import 'package:xlo_mobx/screens/home/components_home/search_dialog.dart';
import 'package:xlo_mobx/screens/home/components_home/top_bar.dart';
import 'package:xlo_mobx/stores/home_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeStore homeStore = GetIt.I<HomeStore>();

  //final MyAdsStore store = MyAdsStore();

  final ScrollController scrollController = ScrollController();

  openSearch(BuildContext context) async {
    final search = await showDialog(
      context: context,
      builder: (_) => SearchDialog(currentSearch: homeStore.search),
    );
    if (search != null) {
      homeStore.setSearch(search);
    }

    print(search);
  }

  @override
  void initState() {
    super.initState();
    homeStore.loadingNextPage();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        homeStore.loadingNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Observer(
            builder: (_) {
              if (homeStore.search.isEmpty) {
                return Container();
              } else {
                return GestureDetector(
                  onTap: () => openSearch(context),
                  child: LayoutBuilder(
                    builder: (_, constraints) {
                      return SizedBox(
                        width: constraints.biggest.width,
                        child: Text(
                          homeStore.search,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          actions: [
            Observer(
              builder: (_) {
                if (homeStore.search.isEmpty) {
                  return IconButton(
                    onPressed: () {
                      openSearch(context);
                    },
                    icon: Icon(Icons.search),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      homeStore.setSearch('');
                    },
                    icon: Icon(Icons.close),
                  );
                }
              },
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            TopBar(),
            Expanded(
              child: Stack(
                children: <Widget>[
                  Observer(
                    builder: (_) {
                      if (homeStore.error != null) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.error, color: Colors.white, size: 100),
                              const SizedBox(height: 8),
                              Text(
                                'Ocorreu um erro!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      if (homeStore.showProgress) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      }
                      print(
                        'homeStore.adList.isEmpty2: ${homeStore.adList.isEmpty}',
                      );
                      if (homeStore.adList.isEmpty) {
                        print(
                          'homeStore.adList.isEmpty1: ${homeStore.adList.isEmpty}',
                        );
                        return const EmptyCard(
                          text: 'Nenhum anúcio encontrado',
                        );
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: homeStore.itemCount,
                        itemBuilder: (_, index) {
                          if (index < homeStore.adList.length) {
                            return AdTile(ad: homeStore.adList[index]);
                          }
                          homeStore.loadingNextPage();
                          return const SizedBox(
                            height: 10,
                            child: LinearProgressIndicator(),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: CreateAdButton(scrollController: scrollController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
