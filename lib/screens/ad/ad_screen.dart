import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/screens/ad/components_ad/bottom_bar.dart';
import 'package:xlo_mobx/screens/ad/components_ad/description_panel.dart';
import 'package:xlo_mobx/screens/ad/components_ad/location_panel.dart';
import 'package:xlo_mobx/screens/ad/components_ad/main_panel.dart';
import 'package:xlo_mobx/screens/ad/components_ad/user_panel.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

class AdScreen extends StatefulWidget {
  const AdScreen({super.key, required this.ad});

  final Ad? ad;

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  int current = 0;

  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();
  final FavoriteStore favoriteStore = GetIt.I<FavoriteStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Anúncio', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          if (widget.ad!.status == AdStatus.ACTIVE &&
              userManagerStore.isLoggedIn)
            Observer(
              builder: (_) {
                return IconButton(
                  onPressed: () => favoriteStore.toggleFavorite(widget.ad!),
                  icon: Icon(
                    favoriteStore.favoriteList.any((a) => a.id == widget.ad!.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                );
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              SizedBox(
                height: 280,
                child: CarouselSlider(
                  carouselController: _carouselController,
                  items: widget.ad!.images!
                      .map(
                        (url) => CachedNetworkImage(
                          imageUrl: url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: false,
                    aspectRatio: 1.0,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    onPageChanged: (index, reason) {
                      setState(() {
                        current = index;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: current,
                  count: widget.ad!.images!.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 8,
                    activeDotColor: Colors.orange,
                    dotColor: Colors.transparent,
                  ),
                  onDotClicked: (index) {
                    _carouselController.animateToPage(index);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MainPanel(ad: widget.ad!),
                    Divider(color: Colors.grey[500]),
                    DescriptionPanel(ad: widget.ad!),
                    Divider(color: Colors.grey[500]),
                    LocationPanel(ad: widget.ad!),
                    Divider(color: Colors.grey[500]),
                    UserPanel(ad: widget.ad!),
                    SizedBox(
                      height: widget.ad!.status == AdStatus.PENDING ? 16 : 120,
                    ),
                  ],
                ),
              ),
            ],
          ),
          BottomBar(ad: widget.ad!),
        ],
      ),
    );
  }
}
