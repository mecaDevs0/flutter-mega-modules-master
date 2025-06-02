import 'package:dio/dio.dart';
import 'package:mega_flutter_network/models/mega_response.dart';

import '../models/address.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/state.dart';

class AddressFormRepository {
  late Dio _dio;
  AddressFormRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.megaleios.com/api/v1',
        connectTimeout: 5000,
        receiveTimeout: 3000,
      ),
    );
    _dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));
  }

  Future<Address> loadFromCep(String cep) async {
    try {
      final response = await _dio.get('/City/GetInfoFromZipCode/$cep');

      return Address.fromJson(response.data['data']);
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<Country>> loadCountries() async {
    try {
      final response = await _dio.get('/City/ListCountry');

      return (response.data['data'] as List)
          .map((c) => Country.fromJson(c))
          .toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<StateModel>> loadStates() async {
    try {
      final response =
          await _dio.get('/City/ListState?countryId=${Country.brazil().id}');

      return (response.data['data'] as List)
          .map((c) => StateModel.fromJson(c))
          .toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }

  Future<List<City>> loadCities(String stateId) async {
    try {
      final response = await _dio.get('/City/$stateId');

      return (response.data['data'] as List)
          .map((c) => City.fromJson(c))
          .toList();
    } on DioError catch (e) {
      throw MegaResponse.fromDioError(e);
    }
  }
}
