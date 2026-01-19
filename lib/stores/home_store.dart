import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/repositories/ad_repository.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

import '../models/ad.dart';
import '../models/category.dart';
import 'connectivity_store.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  _HomeStore() {
    reaction<bool>((_) => connectivityStore.connected, (connected) {
      if (connected) loadInitialAds();
    });
  }

  ObservableList<Ad> adList = ObservableList<Ad>();

  @observable
  String search = '';

  @action
  void setSearch(String value) {
    search = value;
    loadInitialAds();
    resetPage();
  }

  @observable
  Category? category;

  @action
  void setCategory(Category value) {
    category = value;
    loadInitialAds();
    resetPage();
  }

  @observable
  FilterStore filter = FilterStore();

  //o observer não vê que os dados dentro da instância FilterStore() mudaram
  //então cria-se um clone, ai ele entenderá que mudou
  FilterStore get clonedFilter => filter.clone();

  //depois setamos o clone caso cliquemos no botão de filtrar, senão, as alterações são descartadas
  @action
  void setFilter(FilterStore value) {
    filter = value;
    loadInitialAds();
    resetPage();
  }

  @observable
  String? error;

  @action
  void setError(String? value) => error = value;

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  //paginação (fictícia, pois será uma lista)
  @observable
  int page = 0;

  @observable
  bool lastPage = false;

  //quando chegar no último item da,lista, carregas a proxima página
  //cada página vêm 20
  @action
  void loadingNextPage() {
    page++;
  }

  @action
  Future<void> loadNextPage() async {
    if (loading || lastPage) return;

    loading = true;
    page++;

    try {
      final newAds = await AdRepository().getHomeAdList(
        filter: filter,
        search: search,
        category: category,
        page: page,
      );

      addNewAds(newAds);
    } catch (_) {
      page--;
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> loadInitialAds() async {
    loading = true;
    error = null;
    page = 0;
    lastPage = false;

    try {
      final ads = await AdRepository().getHomeAdList(
        filter: filter,
        search: search,
        category: category,
        page: page,
      );

      adList
        ..clear()
        ..addAll(ads);

      if (ads.length < 10) lastPage = true;
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
    }
  }

  @action
  void addNewAds(List<Ad> newAds) {
    //se for menor que o número de itens por página, significa que acabou
    if (newAds.length < 10) {
      lastPage = true;
    }
    adList.addAll(newAds);
  }

  @computed
  //o +1 é o item de carregamento no fim da lista
  //se estiver na útima lista, não terá
  int get itemCount => lastPage ? adList.length : adList.length + 1;

  //toda vez que usar algum filtro, reseta a página e a lista
  void resetPage() {
    page = 0;
    adList.clear();
    lastPage = false;
  }

  @computed
  bool get showProgress => loading && adList.isEmpty;

  Future<Ad> getAdById(String id) async {
    return await AdRepository().getAdById(id);
  }
}
