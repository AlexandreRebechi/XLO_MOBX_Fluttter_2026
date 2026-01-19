import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xlo_mobx/models/city.dart';
import 'package:xlo_mobx/models/uf.dart';

class IBGERepository {
  Future<List<UF>> getUFList() async {
    final preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey('UF_LIST')) {
      print('FOUND CACHE');
      final j = json.decode(preferences.get('UF_LIST').toString());

      return j.map<UF>((j) => UF.fromJson(j)).toList()..sort(
        (UF a, UF b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
      );
    }
    print('NOT FOUND ON CACHE');

    const endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados';

    try {
      final response = await Dio().get<List>(endpoint);

      preferences.setString('UF_LIST', json.encode(response.data));

      return response.data!.map<UF>((j) => UF.fromJson(j)).toList()..sort(
        (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
      );
    } on DioException {
      return Future.error('Falha ao obter lsita de Estados');
    }
  }

  Future<List<City>> geCityListFromApi(UF uf) async {
    final String endpoint =
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/${uf.id}/municipios';

    try {
      final response = await Dio().get<List>(endpoint);

      final cityList =
          response.data!.map<City>((j) => City.fromJson(j)).toList()..sort(
            (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
          );

      return cityList;
    } on DioException {
      return Future.error('Falha ao obter lsita de Cidades');
    }
  }
}
