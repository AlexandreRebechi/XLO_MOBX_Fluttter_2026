import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/screens/base/base_screen.dart';
import 'package:xlo_mobx/stores/category_store.dart';
import 'package:xlo_mobx/stores/chat_room_store.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';
import 'package:xlo_mobx/stores/home_store.dart';
import 'package:xlo_mobx/stores/page_store.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await configOneSignal();
  await initializeParse();
  setupLocators();
  runApp(const MyApp());
}

void setupLocators() {
  GetIt.I.registerSingleton(ConnectivityStore());
  GetIt.I.registerSingleton(PageStore());
  GetIt.I.registerSingleton(HomeStore());
  GetIt.I.registerSingleton(CategoryStore());
  GetIt.I.registerSingleton(UserManagerStore());
  GetIt.I<UserManagerStore>().getCurrentUser();
  GetIt.I.registerSingleton(FavoriteStore());
  GetIt.I.registerSingleton(ChatRoomStore());
}

Future<void> configOneSignal() async {
  // Inicializa o OneSignal
  OneSignal.initialize('1e6872fc-edd8-47b6-a894-97bc55ae423e');

  // Desativa compartilhamento de localização
  OneSignal.Location.setShared(false);

  // Solicita permissão (Android 13+)
  await OneSignal.Notifications.requestPermission(true);

  // Listener de clique na notificação
  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    if (data != null && data.containsKey('adId')) {
      // tratar navegação aqui
    }
  });
}

Future<void> initializeParse() async {
  const appId = 'Cuu7NPr5eYXFiN6fBNtavJOMGdOkVA1MHMdoIzD2';
  const clientKey = '9kyo6MbzPS2zAuixL0y97ecl2h4lZfHRJU1U4zmo';
  const serverURL = 'https://parseapi.back4app.com/';

  await Parse().initialize(
    'Cuu7NPr5eYXFiN6fBNtavJOMGdOkVA1MHMdoIzD2',
    'https://parseapi.back4app.com/',
    clientKey: '9kyo6MbzPS2zAuixL0y97ecl2h4lZfHRJU1U4zmo',
    autoSendSessionId: true,
    debug: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XLO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.purple,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.purple,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.orange,
        ),
      ),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: BaseScreen(),
    );
  }
}
