import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/models/uf.dart';
import 'package:xlo_mobx/stores/home_store.dart';

part 'filter_store.g.dart';

enum OrderBy { DATE, PRICE }

const VENDOR_TYPE_PARTICUAR = 1 << 0;
const VENDOR_TYPE_PROFESSIONAL = 1 << 1;

class FilterStore = _FilterStore with _$FilterStore;

abstract class _FilterStore with Store {
  _FilterStore({
    this.orderBy = OrderBy.DATE,
    this.minPrice,
    this.maxPrice,
    this.vendorType = VENDOR_TYPE_PARTICUAR,
    this.uf,
    this.city,
  });

  @observable
  OrderBy orderBy = OrderBy.DATE;

  @action
  void setOrderBy(OrderBy value) => orderBy = value;

  @observable
  int? minPrice;

  @action
  void setMinPrice(int? value) => minPrice = value;

  @observable
  int? maxPrice;

  @action
  void setMaxPrice(int? value) => maxPrice = value;

  @computed
  String? get priceError =>
      maxPrice != null && minPrice != null && maxPrice! < minPrice!
      ? 'Faixa de Preço inálida'
      : null;

  @observable
  int vendorType;

  @action
  void selectVendorType(int value) => vendorType = value;

  void setVendorType(int type) => vendorType = vendorType | type;

  void resetVendorType(int type) => vendorType = vendorType & ~type;

  @computed
  bool get isTypeParticular => (vendorType & VENDOR_TYPE_PARTICUAR) != 0;

  bool get isTypeProfessional => (vendorType & VENDOR_TYPE_PROFESSIONAL) != 0;

  @computed
  bool get isFormValid => priceError == null;

  void save() {
    GetIt.I<HomeStore>().setFilter(this as FilterStore);
  }

  FilterStore clone() {
    return FilterStore(
      orderBy: orderBy,
      minPrice: minPrice,
      maxPrice: maxPrice,
      vendorType: vendorType,
      uf: null,
      city: null,
    );
  }

  @observable
  UF? uf;

  @action
  void setUf(UF value) => uf = value;

  @observable
  City? city;

  @action
  void setCity(City value) => city = value;

  copyWith({
    required int minPrice,
    required int maxPrice,
    required OrderBy orderBy,
    required int vendorType,
    required UF uf,
    required City city,
  }) {
    return FilterStore(
      minPrice: minPrice,
      maxPrice: maxPrice,
      orderBy: orderBy,
      vendorType: vendorType,
      uf: uf,
      city: city,
    );
  }
}
