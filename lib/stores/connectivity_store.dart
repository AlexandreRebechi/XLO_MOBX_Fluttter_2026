import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobx/mobx.dart';

part 'connectivity_store.g.dart';

class ConnectivityStore = _ConnectivityStore with _$ConnectivityStore;

abstract class _ConnectivityStore with Store {
  _ConnectivityStore() {
    _init();
  }

  final InternetConnection _internetConnection =
      InternetConnection.createInstance(
        checkInterval: const Duration(seconds: 5),
      );

  void _init() async {
    final hasInternet = await _internetConnection.hasInternetAccess;
    setConnected(hasInternet);

    _internetConnection.onStatusChange.listen((status) {
      setConnected(status == InternetStatus.connected);
    });
  }

  @observable
  bool connected = true;

  @action
  void setConnected(bool value) => connected = value;
}
