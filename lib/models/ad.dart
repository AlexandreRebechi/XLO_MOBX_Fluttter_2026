import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/models/address.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/models/uf.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';
import 'package:xlo_mobx/repositories/user_repository.dart';

enum AdStatus { PENDING, ACTIVE, SOLD, DELETED }

extension AdStatusMembers on AdStatus {
  String? get description => const {
    AdStatus.PENDING: 'Anúncio Pendente',
    AdStatus.ACTIVE: 'Anúncio Ativo',
    AdStatus.SOLD: 'Anúncio finalizado',
    AdStatus.DELETED: 'Anúncio removido',
  }[this];
}

class Ad {
  Ad({
    this.id,
    this.images,
    this.title,
    this.description,
    this.category,
    this.address,
    this.price,
    this.hidePhone = false,
    this.status = AdStatus.PENDING,
    this.created,
    this.user,
    this.views,
  });

  Ad.fromParse(ParseObject object)
    : id = object.objectId,
      title = object.get<String>(keyAdTitle),
      description = object.get<String>(keyAdDescription),
      hidePhone = object.get<bool>(keyAdHidePhone) ?? false,
      price = object.get<num>(keyAdPrice),
      created = object.createdAt,
      views = object.get<int>(keyAdViews, defaultValue: 0) {
    final parseImages = object.get<List>(keyAdImages);
    images = parseImages != null ? parseImages.map((e) => e.url).toList() : [];

    address = Address(
      district: object.get<String>(keyAdDistrict),
      city: City(name: object.get<String>(keyAdCity) ?? ''),
      cep: object.get<String>(keyAdPostalCode),
      uf: UF(initials: object.get<String>(keyAdFederativeUnit) ?? ''),
    );

    final owner = object.get<ParseUser>(keyAdOwner);
    user = owner != null ? UserRepository().mapParseToUser(owner) : null;

    final parseCategory = object.get<ParseObject>(keyAdCategory);
    category = parseCategory != null ? Category.fromParse(parseCategory) : null;

    final statusIndex = object.get<int>(keyAdStatus) ?? 0;
    status = AdStatus.values[statusIndex.clamp(0, AdStatus.values.length - 1)];
  }

  String? id;

  List? images = [];

  String? title;
  String? description;

  Category? category;

  Address? address;

  num? price;
  bool hidePhone = false;

  AdStatus? status;
  DateTime? created;

  User? user;

  int? views;

  @override
  String toString() {
    return 'Ad{id: $id, images: $images, title: $title, description: $description, category: $category, address: $address, price: $price, hidePhone: $hidePhone, status: $status, created: $created, user: $user, views: $views}';
  }
}
