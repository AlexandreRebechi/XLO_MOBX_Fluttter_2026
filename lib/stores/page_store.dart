import 'package:mobx/mobx.dart';

part 'page_store.g.dart';

class PageStore = _PageStore with _$PageStore;

abstract class _PageStore with Store {
  // observables
  @observable
  int page = 0;

  // actions
  @action
  void setPage(int value) => page = value;

  // computed
}

