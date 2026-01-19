import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

class AdRepository {
  Future<List<Ad>> getHomeAdList({
    required FilterStore filter,
    required String? search,
    required Category? category,
    required int page,
  }) async {
    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));

      queryBuilder.includeObject([keyAdOwner, keyAdCategory]);

      queryBuilder.setAmountToSkip(page * 10);
      queryBuilder.setLimit(10);

      queryBuilder.whereEqualTo(keyAdStatus, AdStatus.ACTIVE.index);

      if (search != null && search.trim().isNotEmpty) {
        queryBuilder.whereContains(keyAdTitle, search, caseSensitive: false);
      }

      if (category != null && category.id != '*') {
        queryBuilder.whereEqualTo(
          keyAdCategory,
          (ParseObject(
            keyCategoryTable,
          )..set(keyCategoryId, category.id)).toPointer(),
        );
      }

      switch (filter.orderBy) {
        case OrderBy.PRICE:
          queryBuilder.orderByAscending(keyAdPrice);
          break;
        case OrderBy.DATE:
        default:
          queryBuilder.orderByDescending(keyAdCreatedAt);
          break;
      }

      if (filter.minPrice != null && filter.minPrice! > 0) {
        queryBuilder.whereGreaterThanOrEqualsTo(keyAdPrice, filter.minPrice);
      }
      if (filter.maxPrice != null && filter.maxPrice! > 0) {
        queryBuilder.whereLessThanOrEqualTo(keyAdPrice, filter.maxPrice);
      }

      if (filter.vendorType != null &&
          filter.vendorType > 0 &&
          filter.vendorType <
              (VENDOR_TYPE_PROFESSIONAL | VENDOR_TYPE_PARTICUAR)) {
        final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery());

        if (filter.vendorType == VENDOR_TYPE_PARTICUAR) {
          userQuery.whereEqualTo(keyUserType, UserType.PARTICULAR.index);
        }

        if (filter.vendorType == VENDOR_TYPE_PROFESSIONAL) {
          userQuery.whereEqualTo(keyUserType, UserType.PROFESSIONAL.index);
        }

        queryBuilder.whereMatchesQuery(keyAdOwner, userQuery);
      }

      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        return response.results!.map((po) => Ad.fromParse(po)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }
    } catch (e) {
      return Future.error('Falha de conexão');
    }
  }

  Future<void> save(Ad ad) async {
    try {
      final parseImage = await saveImage(ad.images!);

      final parseUser = await ParseUser.currentUser() as ParseUser;

      final adObject = ParseObject(keyAdTable);

      if (ad.id != null) {
        adObject.objectId = ad.id;
      }

      final parseAcl = ParseACL(owner: parseUser);
      parseAcl.setPublicReadAccess(allowed: true);
      parseAcl.setPublicWriteAccess(allowed: false);
      adObject.setACL(parseAcl);

      adObject.set<String>(keyAdTitle, ad.title!);
      adObject.set<String>(keyAdDescription, ad.description!);
      adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
      adObject.set<num>(keyAdPrice, ad.price!);
      adObject.set<int>(keyAdStatus, ad.status!.index);

      adObject.set<String>(keyAdDistrict, ad.address!.district!);
      adObject.set<String>(keyAdCity, ad.address!.city!.name!);
      adObject.set<String>(keyAdFederativeUnit, ad.address!.uf!.initials);
      adObject.set<String>(keyAdPostalCode, ad.address!.cep!);

      adObject.set<List<ParseFile>>(keyAdImages, parseImage);

      adObject.set<ParseUser>(keyAdOwner, parseUser);

      adObject.set<ParseObject>(
        keyAdCategory,
        ParseObject(keyCategoryTable)..set(keyCategoryId, ad.category!.id),
      );

      final response = await adObject.save();
      if (!response.success) {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }

      ad.id = adObject.objectId;
    } catch (e) {
      return Future.error('Falha ao salvar anúncio');
    }
  }

  Future<List<ParseFile>> saveImage(List images) async {
    final parseImages = <ParseFile>[];

    try {
      for (final image in images) {
        if (image is File) {
          final parseFile = ParseFile(image, name: path.basename(image.path));
          final response = await parseFile.save();
          if (!response.success) {
            return Future.error(
              ParseErrors.getDescription(response.error!.code)!,
            );
          }
          parseImages.add(parseFile);
        } else {
          final parseFile = ParseFile(null);
          parseFile.name = path.basename(image);
          parseFile.url = image;
          parseImages.add(parseFile);
        }
      }
    } catch (e) {
      return Future.error('Falha ao salvar imagens');
    }

    return parseImages;
  }

  Future<List<Ad>> getMyAds(User user) async {
    final currentUser = ParseUser('', '', '')..set(keyUserId, user.id);
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));
    queryBuilder.setLimit(100);
    queryBuilder.orderByDescending(keyAdCreatedAt);
    queryBuilder.whereEqualTo(keyAdOwner, currentUser.toPointer());
    queryBuilder.includeObject([keyAdCategory, keyAdOwner]);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.map((po) => Ad.fromParse(po)).toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

  Future<Ad> getAdById(String id) async {
    try {
      final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable))
        ..includeObject([keyAdOwner, keyAdCategory])
        ..whereEqualTo(keyAdId, id);

      final response = await queryBuilder.query();
      if (response.success && response.results != null) {
        return Ad.fromParse(response.results!.first);
      } else if (response.success && response.results == null) {
        return Future.error('Ad não encontrado');
      } else {
        return Future.error(ParseErrors.getDescription(response.error!.code)!);
      }
    } catch (e) {
      return Future.error('Falha de conexão');
    }
  }

  Future<void> sold(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);

    parseObject.set(keyAdStatus, AdStatus.SOLD.index);

    final response = await parseObject.save();
    if (!response.success) {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }

  Future<void> delete(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);

    parseObject.set(keyAdStatus, AdStatus.DELETED.index);

    final response = await parseObject.save();
    if (!response.success) {
      return Future.error(ParseErrors.getDescription(response.error!.code)!);
    }
  }
}
