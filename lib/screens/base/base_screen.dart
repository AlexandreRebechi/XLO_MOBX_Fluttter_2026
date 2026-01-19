import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:xlo_mobx/screens/account/account_screen.dart';
import 'package:xlo_mobx/screens/ad/ad_screen.dart';
import 'package:xlo_mobx/screens/chat_room/chat_room_screen.dart';
import 'package:xlo_mobx/screens/create/create_screen.dart';
import 'package:xlo_mobx/screens/favorites/favorites_screen.dart';
import 'package:xlo_mobx/screens/home/home_screen.dart';
import 'package:xlo_mobx/screens/messages/messages_screen.dart';
import 'package:xlo_mobx/screens/offline/offline_screen.dart';
import 'package:xlo_mobx/stores/chat_room_store.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';
import 'package:xlo_mobx/stores/home_store.dart';
import 'package:xlo_mobx/stores/page_store.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  final PageStore pageStore = GetIt.I<PageStore>();
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  @override
  void initState() {
    super.initState();

    reaction((_) => pageStore.page, (page) => pageController.jumpToPage(page));

    autorun((_) {
      if (!connectivityStore.connected) {
        Future.delayed(Duration(milliseconds: 50)).then((value) {
          showDialog(context: context, builder: (_) => OfflineScreen());
        });
      }
    });
    oneSignalEvents();
  }

  void oneSignalEvents() async {
    /// Quando a notificação é aberta pelo usuário
    OneSignal.Notifications.addClickListener((
      OSNotificationClickEvent event,
    ) async {
      final data = event.notification.additionalData;

      if (data == null) return;

      if (data.containsKey('adId')) {
        final ad = await HomeStore().getAdById(data['adId']);

        if (ad != null) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => AdScreen(ad: ad)));
        }
      }

      if (data.containsKey('chatRoomId')) {
        final store = GetIt.I<ChatRoomStore>();

        final chatRoom = store.chatRoomList.firstWhere(
          (c) => c.id == data['chatRoomId'],
          orElse: () => store.chatRoom!,
        );

        if (chatRoom != null) {
          store.setChatRoom(chatRoom);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => MessageScreen()));
        }
      }
    });

    /// Decide se a notificação deve ser exibida em foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((
      OSNotificationWillDisplayEvent event,
    ) {
      final data = event.notification.additionalData;

      if (data != null && data.containsKey('chatRoomId')) {
        final store = GetIt.I<ChatRoomStore>();

        if (store.chatRoom != null &&
            store.chatRoom!.id == data['chatRoomId']) {
          event.preventDefault(); // não exibe
          return;
        }
      }

      event.notification.display(); // exibe normalmente
    });

    /// Solicita permissão (iOS / Android 13+)
    await OneSignal.Notifications.requestPermission(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          CreateScreen(),
          ChatRoomScreen(),
          FavoritesScreen(),
          AccountScreen(),
        ],
      ),
    );
  }
}
