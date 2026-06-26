import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/api/api_client.dart';
import 'package:mero_choice_application/core/api/api_endpoints.dart';
import 'package:mero_choice_application/features/place/data/datasources/place_datasource.dart';
import 'package:mero_choice_application/features/place/data/models/place_api_model.dart';

final placeRemoteDatasourceProvider = Provider<PlaceRemoteDatasource>((ref) {
  return PlaceRemoteDatasource(dio: ref.read(apiClientProvider));
});

class PlaceRemoteDatasource implements IPlaceRemoteDataSource {
  final Dio _dio;

  PlaceRemoteDatasource({required Dio dio}) : _dio = dio;
  @override
  Future<List<PlaceApiModel>> getPlaces() async {
    final response = await _dio.get(ApiEndpoints.places);

    final data = response.data;

    final List<dynamic> list;

    if (data is Map && data.containsKey('places')) {
      list = data['places'] as List<dynamic>;
    } else if (data is List) {
      list = data;
    } else {
      list = [];
    }

    return list
        .map((p) => PlaceApiModel.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
